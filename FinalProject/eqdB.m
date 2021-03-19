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
