function Rxy = CrossCorrelate(xn, yn)
%function Rxy = CrossCorrelate(xn, yn);
% calculates the cross correlation between the signals xn and yn
% Inputs:
%   xn = time domain samples of the first sequence
%   yn = time domain samples of the second sequence
% Outputs:
%   Rxy = Cross Correlation between xn and yn

%m+n-1 to the next largest 2^x
newlength = 2^(ceil(log2(length(xn)+length(yn)-1)));

Fd=[0:newlength-1]/newlength;

% FFT of signals, zero padded to the new length
FFTxn=fft(xn,newlength);
FFTyn=fft(yn,newlength);

% multiply FFTxn by complex conjugate of FFTyn to perform time domain correlation equivalent
FFTrk=FFTxn.*conj(FFTyn);

% converts back to time
Rxy=ifft(FFTrk);

% resets the length of the signal
Rxy=Rxy(1:(length(xn)+length(yn)-1));
end


