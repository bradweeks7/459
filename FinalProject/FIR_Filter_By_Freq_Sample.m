function [hn,HF,F]=FIR_Filter_By_Freq_Sample(HF_mag_samples,figurenum)
%     INPUTS:
%       HF_mag_samples - H[k] Magnitude Response samples 
%       figure_num     - Figure # for plotting Mag Response (dB & Linear)
%     OUTPUTS:
%       hn             - impulse response of filter
%       HF             - complex frequency response values
%       F              - HF frequency vector

% Digital freeq vector, spaced at 1/M
M=length(HF_mag_samples);
    
% M must be odd, use group delay for 0 =< i < M 
i=0:1:M-1;
Fdft=0:1/M:1-1/M;
% group delay equation for all angles of |H(F)| samples
Hk=HF_mag_samples.*exp(-j*pi*i*(M-1)/M);
% inverse fft to yield hn array, use real to truncate floating point
% arithmetic errors from complex numbers.
hn=real(ifft(Hk));  
% generate DTFT H(F) & F using zero-padding
HF=fft(hn,2048);
F=0:1/2048:1-1/2048;    
% plot mangitude/phase vs digital frequency
if figurenum~=0
figure(figurenum)
clf
subplot(2,1,1)
plot(F,abs(HF),'r')
grid on
% overlay the discrete sample magnitudes
hold on
stem(Fdft,abs(Hk),'b.')
xlabel('Digital Frequency F (cycles/sample)')
ylabel('Magnitude Response')
title('Frequency Response of FIR Filter')
subplot(2,1,2)
plot(F,angle(HF)/pi,'r')
grid on
% overlay the discrete sample angles
hold on
stem(Fdft,angle(Hk)/pi,'b.')
xlabel('Digital Frequency F (cycles/sample)')
ylabel('Phase / pi')
title('Frequency Response of FIR Filter')

% plot dB magnitude response
figure(figurenum+1)
clf
plot(F,20*log10(abs(HF)),'r')
grid on
hold on
stem(Fdft,20*log10(abs(Hk)),'b.')
xlabel('Digital Frequency F (cycles/sample)')
ylabel('Magnitude Response')
title('Frequency Response of FIR Filter')
end
