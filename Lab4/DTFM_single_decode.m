function key = DTFM_single_decode(input, fsample)
%DTFM_SINGLE_DECODE Summary takes an audio signal sample array name as an
%input parameter and returns a text variable with the corresponding key
%value given the detected input tones
%   INPUTS:
%       input - audio file / input array to be analyzied
%       
%   OUTPUTS:
%       number - text variable with the key value

% Macros for testing
% load('C:\Users\Brad\Dropbox\My
% PC(DESKTOP-D1-R297)\Documents\MATLAB\459\Lab4\touchtones.mat')
% input = no_tone_noisy
% fsample = 8000

% Play tone
load('touchtones.mat');
%sound(input, fsample);

% Establish Low Freq and High Freq Group 
lfg = [697 770 852 941]; 
hfg = [1209 1336 1477];

% Plot DFT for input
[input_dft, Fd] = plot_DFT_mag(input, fsample, 1);

% Cut DFT from - 0 to 0.5
input_dft = input_dft(1: ceil(length(input_dft)/2));
Fd = Fd(1: ceil(length(Fd)/2));

% Set noise thrsh + find tones > thrsh
n_thrsh = 0.15;
potential_tones = find(abs(input_dft) > n_thrsh);
if isempty(potential_tones)
    key = '_';
    return;
end

% Make indicies found into their actual values and get magnitude
potential_tones = [fsample.*Fd(potential_tones)
abs(input_dft(potential_tones))].';

% sort potential tones by decreasing mag
potential_tones = sortrows(potential_tones, 2, 'descend')

% first freq is the max DFT mag freq
f1 = potential_tones(1, 1)

% Find second freq by finding second max (bw per f1 tone +- 10%)
for N = 2:length(potential_tones)
    if abs(potential_tones(N, 1) - f1) > f1*.05
        f2 = potential_tones(N, 1);
        break
    end
end

% match f1 + f2 to row/column freqs on a keypad
r_freq = min(f1, f2);
c_freq = max(f1, f2);

% Get indicies of tones by matching with standard button freqs 
r_freq_i = find(abs(lfg - r_freq) < 80/2); % Row freq BW ~ 80 Hz
c_freq_i = find(abs(hfg - c_freq) < 140/2); % Col freq Bw ~ 140 Hz

% Dereference using index
r_freq = lfg(r_freq_i)
c_freq = hfg(c_freq_i)

% Find DTMF key pressed
if isequal(r_freq,697) && isequal(c_freq,1209)
 key = '1';
elseif isequal(r_freq,697) && isequal(c_freq,1336)
 key = '2';
elseif isequal(r_freq,697) && isequal(c_freq,1477)
 key = '3';
elseif isequal(r_freq,697) && isequal(c_freq,1633)
 key = 'A';
elseif isequal(r_freq,770) && isequal(c_freq,1209)
 key = '4';
elseif isequal(r_freq,770) && isequal(c_freq,1336)
 key = '5';
elseif isequal(r_freq,770) && isequal(c_freq,1477)
 key = '6';
elseif isequal(r_freq,770) && isequal(c_freq,1633)
 key = 'B';
elseif isequal(r_freq,852) && isequal(c_freq,1209)
 key = '7';
elseif isequal(r_freq,852) && isequal(c_freq,1336)
 key = '8';
elseif isequal(r_freq,852) && isequal(c_freq,1477)
 key = '9';
elseif isequal(r_freq,852) && isequal(c_freq,1633)
 key = 'C';
elseif isequal(r_freq,941) && isequal(c_freq,1209)
 key = '*';
elseif isequal(r_freq,941) && isequal(c_freq,1336)
 key = '0';
elseif isequal(r_freq,941) && isequal(c_freq,1477)
 key = '#';
elseif isequal(r_freq,941) && isequal(c_freq,1633)
 key = 'D';
end

% Add key pressed text to plots
subplot(2,1,1)
%text(f2/fsample+.03, .25, key);
subplot(2,1,2)
%text(f2+200,.25, key);

end

