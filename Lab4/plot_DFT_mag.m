function [DFTx, Fd] = plot_DFT_mag(x, fsample, figure_num)
%PLOT_FREQ_RESPONSES: Plots any DTFT frequency response from its complex
%                     H(F) data point vallues (rather than analytical H(F))
%   INPUTS:
%      x = time domain samples of a discrete-time sequence
%      fsample = sampling frequency (samples / second) 
%      figure_num = number of the figure to use for the two plots 
%   OUTPUTS:
%      DFTX = DFT spectrum values (complex) [same # samples as x]
%      Fd = Digital frequency values for each DFT sample

% Take FFT of x to get freq domain version
DFTx = fft(x);
Fd = 0:1/length(x):(1-1/length(x));
Fa = Fd*fsample;
figure(figure_num);
subplot(211); stem(Fd, abs(DFTx)/length(Fd), '.');
xlabel("Digital Frequency [Cycles/Sample]"); ylabel("Magnitude of DFT(x)");
subplot(212); stem(Fa, abs(DFTx)/length(Fa), '.');
xlabel("Analog Frequency [Hz]"); ylabel("Magnitude of DFT(x)");