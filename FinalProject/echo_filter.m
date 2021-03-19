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

