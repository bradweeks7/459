%% Part 3 - Verification Testing
clear all;

%% Load Corrupted Tones From Prof Pilkington
load corrupted_tones;

%plot DFT of corrupted tones at 360Hz
[DFTy_corruput, Fd_corrupt] = plot_DFT_mag(y, 360, 1);

% IIR filter to attenuate 60 Hz + harmonics
zeros = [exp(1i*2*pi/6), exp(-1i*2*pi/6), exp(1i*2*pi/3), exp(-1i*2*pi/3), exp(1i*2*pi/2)];
poles = zeros*0.931;

% generate difference equation coefficients from the filter's pole and zero locations
fsample = 360;
[Ak,Bk,HF,Fd,hn,n] = show_filter_responses(poles, zeros, 1/1.1868, fsample, 720, 72, 2);

%% Get pole zero plot and magnitude vs analog freq.
y_filt = filter(Bk, Ak, y);
[DFTy_filt, FD_filt] = plot_DFT_mag(y_filt, fsample, 6);

%% 20 point hn
[filt_unit_samp,n] = unit_sample_response(Ak, Bk, 20, 7);
yn = fftconv(y, filt_unit_samp, 8);

%% 60 point hn
[filt_unit_samp,n] = unit_sample_response(Ak, Bk, 60, 9);
yn = fftconv(y, filt_unit_samp, 10);
