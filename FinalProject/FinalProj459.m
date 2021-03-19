%% Innitialization
% bad test case instantiation
fs = 44100;
% Bad tests
in    = 'Zarathustra.wav';
eq    = [12 -6 -12 -12 -6 12 -6 12 -6];
echo  = [250 400 520 660 750 1220];
alpha = [0.7 0.6 0.5 0.33 0.2 0.8];
out   = 'Zarawful.wav';

% Good test cas einstantiation
%in      = 'Zarathustra.wav';
%eq      = [12 10 8 7 8 5 10 11 12];
%echo    = [120 300 600 900 1200 2000];
%alpha   = [0.4 0.2 0.08 0.03 0.01 0.005];
%out     = 'Zarawesome.wav';
%% Just for testing eq levels
hnEQ = eqdB(eq,10,fs);
[stereo, fs] = audioread(in);
outlen = length(stereo)+length(hnEQ)-1;
Processed_wav = zeros(outlen,2);
for i=1:size(stereo,2)
    Processed_wav(:,i) = fftconv(stereo(:,i).',hnEQ).';
end
Processed_wav = Processed_wav/max(abs(Processed_wav), [], 'all');
% play sound with native device, matlab's sound isn't very good
% writing EQ file here, change if good/bad test case
audiowrite('ZaraEQ.wav', Processed_wav,fs);

%% Add reverb levels
audio = equalize_and_reverb_wavefile(in,eq,echo,alpha,out);
% Write Echo+Reverb audio to Zarawesome.wav
audiowrite(out, audio, fs);

%% Parametric Equalizer ( 9 Band )
function eq_hn=eqdB(dBbands,Mscale,fs)
%     INPUTS:
%       dBbands - Equalizer Band Settings Array
%       Mscale  - Scaling coefficeint for M, making Mag Resp. more accurate
%       fs      - sampling rate
%     OUTPUTS:
%       eq_hn   - EQ unit sample response
    
% fundamental harmonic frequency
f0=62.5;
% generate filter length, scale by scaling coefficient
M=Mscale*floor(fs/f0);
% Check if filter is odd length, if not, add 1
if mod(M,2)==0
    M=M+1;
end
% Make DFT freqs from 0=<n<(0.5) to ensure odd # of samples
dft=0:1/M:0.5-1/M;
% Array for value of each band location
freqs = [ 62.5 125 250 500 1000 2000 4000 8000 16000];
    
% Response buffer
HmagdB=zeros(1,length(dft));
% Interpolate Mag inputs: Low pass, BandPass*7, HighPass
dBbands =[dBbands(1) dBbands dBbands(end)];
% Interpolate band locations as well 
freqsP=[0 freqs 0.5];
% Loop through all bands
for i=1:10
    % gain setting for current freq in array
    bandnum=dft>=freqsP(i) & dft < freqsP(i+1);
    % interpolate samples corresponding to each added band
    stitched=linspace(dBbands(i),dBbands(i+1),length(HmagdB(bandnum))+1);
    HmagdB(bandnum)=stitched(1:end-1);
end
% Logarithmic->Linear
Hmag=db2mag(HmagdB);
% Add mirrored Hmag to original Hmag, but stay away from nyquist (0.5)
Htot     = [Hmag fliplr(Hmag(2:end))];
[hn,~,~] = FIR_Filter_By_Freq_Sample(Htot,0);
% Apply Tukey window to Total response to suppress natural artifacts from FFT 
window=tukeywin(length(Htot)).';
eq_hn=hn.*window;
end
%% Echo Filter 
function [echo_filter_hn]=echo_filter(Dk_delays_msec,alphak_gains,Fsample)
%     INPUTS:
%       Dk_delays_msec - delay array (ms)
%       alphak_gains   - mag of delay coefficients
%       Fsample        - sampling rate
%     OUTPUTS:
%       echo_filter_hn - hn unit sample response

% ms delay -> # of samples
delays = Dk_delays_msec*Fsample*1E-3;
% FIR resp vector (minus DC)
echo_filter_hn = [1 zeros(1,delays(end)-1)];
% place gains at appropriate samples
echo_filter_hn(delays) = alphak_gains;
end

%% Equalize and Reverb
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

%% FFT Convolution
function yn=fftconv(xn,hn)
%     INPUTS:
%       xn - discrete-time input time samples
%       hn - discrete-time unit response samples
%     OUTPUTS:
%       yn - discrete-time system output samples
    
% calculate in and transfer lengths
xL=length(xn);
hL=length(hn);
% calculate output length 
M=xL+hL-1;
% radix reduces speed
radix=2^nextpow2(M);
% fft both input and unit sample response
X=fft(xn,radix);
H=fft(hn,radix);    
% convolution (time) = multiplication (freq)
Y=X.*H;
% inverse fourrier trans is faster with radix-valued array
ynPad=ifft(Y,radix);
% take out extraneous zero artifacts from radix calc
yn=ynPad(1:M);
end

%% FIR By Freq Sample (w/ a little help from tukey window)
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
end