function Cxy=NormCrossCorrelate(xn, yn, figure_num)
%function Cxy=NormCrossCorrelate(xn, yn);
%
% Plot the normalized cross correlation between the signals xn and yn and
%   return the result as a time domain sequence of values
%
% Inputs:
%   xn = time domain samples of the first sequence
%   yn = time domain samples of the second sequence
%   figure_num = figure for the Cross correlations to be ploted
% Outputs:
%   Cxy = Normalized Cross Correlatation between xn and yn

%finds the Auto-correlation of signal xn at the 0 lag position
Ex=CrossCorrelate(xn,xn);
%finds the Auto-correlation of signal yn at the 0 lag position
Ey=CrossCorrelate(yn,yn);
%finds the crosscorrelation and normalizes it
Cxy=CrossCorrelate(xn,yn)./(sqrt(Ex(1).*Ey(1)));
 
% plot the xn sequence against time
figure(figure_num);
subplot(3,1,1);
stem(xn,'.');
stem(0.02*[1:length(xn)],xn,'.');
title('xn');
xlabel('time (ms)');
ylabel('Magnitude');
xlim([0 0.02*length(xn)]);

% plot the yn sequence against time
subplot(3,1,2);
stem(yn,'.');
stem(0.02*[1:length(yn)],yn,'.');
title('yn');
xlabel('time (ms)');
ylabel('Magnitude');
xlim([0 0.02*length(yn)]);
 
% plot the Cxy sequence against time
subplot(3,1,3);
stem(Cxy,'.');
stem(0.02*[1:length(Cxy)],Cxy,'.');
title('Normalized Cross Correlation');
xlabel('time (ms)');
ylabel('Normalized Magnitude');
xlim([0 0.02*length(Cxy)]);
end


