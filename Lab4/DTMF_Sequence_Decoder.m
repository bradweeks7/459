function return_tones = DTMF_Sequence_Decoder(sequence_in, figure_num);
% function return_sequence = DTMF_Sequence_Decoder(sequence);
%
% Take a time signal tone, print the spectrogram for the sequence of tones, and determine
%   what sequence of numbers were pressed. If the function detects a
%   tone, it should print the tone's corresponding character, the
%   approximate duration of the tone, and the duration of the pause before
%   the tone
%
% Input:
%   sequence_in = time signal to be decoded
%   figure_num  = figure number used to print the spectrogram and
%           	consecutive tone DFT's
%
% Output:
%   return_tones	= characters corresponding to the DTMF encoded frequency
%               	in the input tone sequence

% set values for sampling and spectrogram parameters
fsample = 8000;
spec_window = 400;
spec_overlap = 0;

% create a spectrogram from input sequence
[sequence_array_freq, ffreq_raw, sampled_time_raw] = spectrogram(sequence_in, spec_window, spec_overlap, fsample, 'yaxis');

figure (figure_num);
spectrogram(sequence_in, spec_window, spec_overlap, fsample, 'yaxis');

% transpose sequence_array_freq so each row is a set of FFT values
sequence_array_freq = sequence_array_freq.';

% normalize ffreq_raw to Hz and sampled_time_raw to seconds
% ffreq = ffreq_raw.' ./ pi .*fsample;
ffreq = [0:length(sequence_array_freq(1,1:end))-1]/length(sequence_array_freq(1,1:end))/2 * fsample;
sampled_time = sampled_time_raw ./ sampled_time_raw(1) .* spec_window;


% go through each sequence of the spectrogram,
%   find next pause,
%   use DTMF_Decoder up to that point,
%   find next tone,
%   repeat until pause is > 10seconds or 10 tones are pressed

min_hold = (fsample/spec_window/5) - 1;
hold_counter = min_hold - 1;
diff_counter = 0;
current_fig = figure_num+1;
current_tone = DTMF_DFT_Decoder(sequence_array_freq(1, 1:end), ffreq);
return_tones = 'X';

for n = min_hold:length(sampled_time)
	tone_n = DTMF_DFT_Decoder(sequence_array_freq(n, 1:end), ffreq);
	timer = timer +1;
    
	% test for break conditions: when pause is held for 10.0 seconds or
	%   when 10 return_tones have been entered
	if hold_counter >= 100 / (spec_window/fsample) || length(return_tones)> 10
    	break
   	 
	% when a tone is held for longer than 3.0 seconds, change the n-th tone
	%   to be seen as a pause
	elseif (tone_n ~= '_' && hold_counter >= 30 / (spec_window/fsample))
    	tone_n = '_';
	end
    
    
	% when the tone is the same as the previous sequence, increment a
	%   counter for how long the tone has been held. if different,
	%   increment the counter for how long the two signals are different
	if current_tone ~= tone_n
    	diff_counter = diff_counter + 1;
	else
    	hold_counter = hold_counter + 1;
    	diff_counter = 0;
	end
    
    
	% when a 0.2 second pause is found, use the DTMF_Decoder to plot the
	% spectrum of the time signal from previous point to current point
	if tone_n == '_' && diff_counter >= min_hold
    	current_tone = DTMF_Decoder(sequence_in([spec_window*(n-hold_counter-min_hold)+1:spec_window*(n-min_hold)]), current_fig);
   	 
    	fprintf('Tone: ');
    	disp(current_tone);
    	fprintf('Tone Duration: ');
    	disp(hold_counter * (spec_window/fsample));
   	 
    	hold_counter = min_hold;
    	current_fig = current_fig + 1;
    	return_tones = [return_tones, current_tone];
    	% set current tone to the n-th tone so there is no difference
    	current_tone = tone_n;
    	diff_counter = 0;
    
	% when a 0.2 second tone is found, set current tone to the n-th tone
	%   and reset the counters, but don't plot the pause
	elseif (diff_counter >= min_hold) || (n == length(sampled_time) && tone_n == '_')
    	current_tone = tone_n;
    	fprintf('Pause Duration: ');
    	disp(hold_counter * (spec_window/fsample)); 	 
    	hold_counter = min_hold;
    	diff_counter = 0;
   	 
	end
   	 
end

% take out initial value in return_tones
return_tones(1) = [];

% determine if return_tones is a valid sequence of numbers. if not, return
%   error code
if length(return_tones) ~= 7 && length(return_tones) ~= 10
	return_tones = ['Error – Invalid Sequence ' return_tones];
end


