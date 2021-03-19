function [sequence] = DTMF_sequence(input, fsample)
%function [sequence] =  DTMF_sequence(input, fsample)
% DTMF_SEQUENCE Breaks input .mat file into smaller sample windows and inputs them to DTFM_single_deocde.m
%       INPUTS:
%               input    - .mat file input array
%               fsample  -  sample rate (8kHz for Project 4)
%       OUTPUTS:
%               sequence -  array of characters from all tones decoded from
%                           input file from INPUT input

%Debug/Test Inputs
clf;
clear all;
clc;
load('DTMFverificationtest.mat')
input = VerificationTest6;
fsample = 8000;
% Display Spectrogram
figure(5);
window = floor(fsample*.1);
noverlap = floor(fsample*.09);
numfpoints = fsample;
spectrogram(input, window, noverlap, numfpoints, fsample)
sound(input, fsample);
% shortest space between tones is .100 seconds.
% need > 500 samples to distinguish a noisy DTMF tone. This has a time length of
% 500 * 1/fsample -> ~60ms
% Set block length in samples (100ms)
block_length = ceil(.100 * fsample)
% Iterate through the array in 100ms blocks 
num_tones = 0;
prev_tone = '_';
clear tone;
for N = 1 : floor(length(input) / block_length)
 input_N = input(block_length*(N - 1) + 1 : block_length*N);
 tone(N) = DTFM_single_decode(input_N, fsample)
 fprintf('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n')
 subplot(2,1,1)
 ylim([0 .3])
 subplot(2,1,2)
 ylim([0 .3])

 % Limit of 10 tones
 currentTone = tone(N);
 % silence/error => next tone
 if strcmp(currentTone,'_') || strcmp(currentTone,'~')
 continue;
 % else, there is a tone
 %If it matches previous tone (or is error), continue
 elseif strcmp(currentTone, prev_tone) || strcmp(currentTone, '~')
 continue;
 % no match previous, increment count.
 else
 num_tones = num_tones + 1;
 end
 prev_tone = currentTone;

 % If we've heard 10 tones, stop recording.
 if num_tones == 10
 break;
 end

 % For debugging
 %sound(input_N, fsample);
 %pause
end

disp(tone);
% Store each grouping of characters into its own string in an array
tone_split(1) = convertCharsToStrings(tone(1)); %store first character into string
in the split array
n = 1; %track which split currently on
for N = 2 : length(tone)
 % If same character as previous, extract and place onto final string
 if strcmp(tone(N), tone(N-1))
 tone_split(n) = tone_split(n) + convertCharsToStrings(tone(N));
 else %new characters start a new string in the array
 n = n+1;
 tone_split(n) = convertCharsToStrings(tone(N));
 end
end
% Find length of each grouping
for N = 1: length(tone_split)
 split_count(N,1) = strlength(tone_split(N));
 split_count(N,2) = split_count(N,1) * block_length;
 split_count(N,3) = split_count(N,2) * 1/fsample;
end
% Make a table to show results
format shortg;
T = table(tone_split.', split_count(:,1), split_count(:,2), split_count(:,3), 'VariableNames', {'Sequence_Recorded', 'Num_Blocks','Num_Samples', 'Num_Seconds'});
filename = 'tone_decoder_output.xlsx';
writetable(T,filename,'Sheet',1,'Range','A1')

% Extract number sequence
sequence = '';
for N = 1 : length(tone_split)
 current_string = char(tone_split(N));
 if strcmp(current_string(1), '_') || strcmp(current_string(1), '~')
 continue;
 end
 sequence = [sequence current_string(1)];
end
disp(['The full sequence is: ' sequence]);
% Ignore numbers after the 10th digit
if length(sequence) > 10
 sequence = sequence(1:10);
end
% Display if correct length, else state invalid phone number.
if length(sequence) == 7 || length(sequence) == 10
 disp(['The first 10 digits are: ' sequence]);
else
 disp('Error: Sequence is not a valid phone number.')
end
end