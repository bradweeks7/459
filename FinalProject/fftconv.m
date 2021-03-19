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

