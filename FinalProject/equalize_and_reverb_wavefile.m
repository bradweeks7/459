function Processed_wav=equalize_and_reverb_wavefile(inwavfilename,EQdBsettings,Dk_delays_msec,alphak_gains,outwavfilename)
%     INPUTS:
%       inwavfilename  - Audio read file (.wav)
%       EQdBsettings   - EQ dB gain array (9 Bands)
%       Dk_delays_msec - delays (ms)
%       alphak_gains   - mag of corresponding delays for Dk_delays msec
%       outwavfilename - Audio write file (.wav0
%     OUTPUT(S):
%       Processed_wav  - Audio Array (XxY): X = SAMPLES, N = CHANNELS

% read in audio file using built-in audioread()
[stereo,fs]=audioread(inwavfilename);
% generate EQ and Echo response arrays
hnEQ  = eqdB(EQdBsettings,10,fs);
hnEcho= echo_filter(Dk_delays_msec,alphak_gains,fs);
% add echo to EQ for a total response
hnTotal=fftconv(hnEQ,hnEcho);

% Set buffer to filter+input length
outsize=length(stereo)+length(hnTotal)-1;
Processed_wav=zeros(outsize,2);
% loop both channels and add in convolution results
for n=1:size(stereo,2)
    Processed_wav(:,n)=fftconv(stereo(:,n).',hnTotal).';
end
% Normalize by largest matrix value to prevent clipping
Processed_wav=Processed_wav/max(abs(Processed_wav),[],'all');
% write to output
audiowrite(outwavfilename,Processed_wav,fs);

% Plots    
% create specified filter's total frequency response
[HF,Wd]=freqz(hnEQ,[1 zeros(1,length(hnEQ)-1)],1E6);
% radian => Hz
Fd=Wd/2/pi;

figure(1)
% Log Scale
% H[F] (dB) vs Analog Freq (Hz)
semilogx(Fd*fs,mag2db(abs(HF)))
% Analog Freq Marks
marks = [ 62.5 125 250 500 1000 2000 4000 8000 16000];
set(gca, 'XTick', marks);
% Logarithmic limiting 
xlim([32.25 fs/2])
grid on
xlabel('Analog Frequency: f(Hz)')
ylabel('Magnitude Response: H(dB)')
title('H[F] dB vs f (Hz)')
end



