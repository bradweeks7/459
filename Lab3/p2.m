function yn = fftconv(xn, hn, figure_num)
% function yn = fftconv(xn, hn)
%
%   Returns convolution between input and transfer function in the
%   time-domain.
%   If the input functions are smaller than 1000 samples, the function will
%   also plot the inputs, output, and their FFT's.
%
% INPUTS:
%   xn  = td input values
%   hn  = td system values
%   figure_num  = figure number for each different plot
%
% OUTPUTS:
%   yn  = rconvolution of xn and hn

% save required len of output
yn_len = length(xn) + length(hn) - 1;

% take FFT of inputs xn and hn
FFTx = fft([xn, zeros(1, length(hn)-1)]);
FFTh = fft([hn, zeros(1, length(xn)-1)]);

% Multiplication in freq domain = Convolution in Time Domain
FFTy = FFTx .* FFTh;

% inverse FFT of the zero-padded output
yn = ifft(FFTy);

% remove zero-padding from output
yn = yn(1:yn_len);

% decide if the sequence is too long
if length(xn) < 1000 || length(hn) < 1000
	figure(figure_num);
	% plot the magnitude of xn
	subplot(3,2,1);
	stem([0:length(xn)-1], xn, '.');
	title('x[n] Sequence');
	xlabel('Sample, n');
	ylabel('Magnitude');
	xlim([0, length(xn)-1]);
	% plot the magnitude response of the FFT of xn
	subplot(3,2,2);
	plot([0:length(FFTx)-1]/length(FFTx), abs(FFTx));
	title('X[k] Spectrum');
	xlabel('Digital Frequency (cycles/sample)');
	ylabel('Magnitude Response');
    
	% plot the magnitude of hn
	subplot(3,2,3);
	stem([0:length(hn)-1], hn, '.');
	title('h[n] Sequence');
	xlabel('Sample, n');
	ylabel('Magnitude');
	xlim([0, length(hn)-1]);
	% plot the magnitude response of the FFT of hn
	subplot(3,2,4);
	plot([0:length(FFTh)-1]/length(FFTh), abs(FFTh));
	title('H[k] Spectrum');
	xlabel('Digital Frequency (cycles/sample)');
	ylabel('Magnitude Response');
    
	% plot the magnitude of yn
	subplot(3,2,5);
	stem([0:length(yn)-1], yn, '.');
	title('y[n] Sequence');
	xlabel('Sample, n');
	ylabel('Magnitude');
	xlim([0, length(yn)-1]);
	% plot the magnitude response of the FFT of yn
	subplot(3,2,6);
	plot([0:length(FFTy)-1]/length(FFTy), abs(FFTy));
	title('Y[k] Spectrum');
	xlabel('Digital Frequency (cycles/sample)');
	ylabel('Magnitude Response');
end
