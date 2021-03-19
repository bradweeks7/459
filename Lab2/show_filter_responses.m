function [poles, zeros, HF, Fd, hn, n] = show_filter_responses(AK,BK,fsample, num_of_f_points, num_of_n_points, figure_num)
%function [poles, zeros, HF, Fd, hn, n] = show_filter_responses(AK,BK,fsample, num_of_f_points, num_of_n_points, figure_num)
% Description: Analyzes and provide frequency response plots for an
% arbitrary digital filter (FIR or IIR, any length)
% INPUTS:
%   Ak = a list of the Ak coefficients of the filter difference equation
%        ("y" coefficients)
%   Bk = a list of the Bk coefficients of the filter difference equation
%        ("x" coefficients)
%   fsample = sampling frequency
%   num_of_f_points = the # of points for the freq. response plot
%   num_of_n_points = the # of points for the unit sample response plot
%   figure_num      = number of the 1st figure to use for plots
%
% OUTPUTS;
%   poles = a list of the complex pole locations (z values) for the
%           Transfer Function (roots of the H(x) denominator polynomial)
%   zeros = a list of the complex zero locations (z values) for the
%           Transfer Function (roots of the H(z) numerator polynomial)
%   HF = the complex DTFT frequency response values (linear scale)
%   Fd = digital frequencies that match the freq response values
%   hn = has the unit sample response sequence values
%   n  = has the corresponding sample inices (0 to [num_of_points - 1]);

% Plot a Pole/Zero diagram:
figure(figure_num);
zplane(BK, AK);
grid on;
title('Pole/Zero Plot');

%Poles and Zeros Calculations 

poles = roots(AK);
zeros = rooks(BK);
%Two Frequency Response Plots of H(F) vs F (digital frequency)
%   1. H(F) vs F (digital frequency): Uisng a digital frequency axis
%   2. H(F) vs dB vs fanalog: Using an equivalent analog frequency axis,
%   from f = 0 to f = fsample/2
[HF, Fd_not_normalized] = freqz(BK, AK, num_of_f_points);
Fd = Fd_not_normalized/(2*pi);

% gen freq response values in dB adn freq in Hz
HF_dB = 20*log10(abs(HF));
Fd_hz = Fd*fsample;

%plot digital and analog freq resp
plot_freq_responses(Fd, HF, fsample, figure_num+1);

%A Unit Sample Response Plot h[n] vs n
[hn, n] = unit_sample_response(Bk, Ak, num_of_n_points, figure_number+2);

%Find peak freq value in resp and print mag and freq
lin_max = max(HF);
max_index = find(HF == lin_max);
freq_max = Fd(max_index);
fprintf('\nPeak Magnitude = %d', abs(linear_max));
fprintf('\nPeak Magnitude Frequency (cycles/sample) = %d', freq_max);

%Find min freq value in resp and print mag and freq
lin_min = min(HF);
min_index = find(HF == lin_min);
freq_min = Fd(min_index);
fprintf('\Minimum Magnitude = %d', abs(linear_min));
fprintf('\nMinimum Magnitude Frequency (cycles/sample) = %d', freq_min);

% find difference in dB between peak and min magnitudes
maxval = max(HF_dB);
minval = min(HF_dB((HF > -inf)));
attenuation = maxval-minval;
fprintf("Maximum Attenuation (dB) = %d", attenuation);

% find half-power+3dB mag
half_power_mag = abs(lin_max)/sqrt(2);
mag_3dB = 20*log10(half_power_mag);
fprintf("Magnitude @ 3dB Cutoff Frequency = %d", mag_3dB); 

% Find filter type
% Based on Peak and Min Magnitude Freqs, finds and prints 3dB freq + BW
if freq_min > 0.1 && min_freq < 0.4
    fprintf("Filter Typer: Band-Stop (Notch)\n\n");
    indices_3dB = find(HF_dB <= maxval-3);
    freq_under_3dB = Fd(indices_3dB);
    freq_3dB = [freq_under_3dB(1), freq_under_3dB(length(freq_under_3dB))];
    bw = freq_3dB(2) - freq_3dB(1);
    fprintf("3 dB Frequencies (cycles/sample) = %d", freq_3dB);
    fprintf("3 dB Bandwidth (cycles/sample) = %d", bw);

elseif freq_max > 0.1 && freq_min < 0.5
    fprintf("Filter Typer: Band-Pass\n\n");
    indices_3dB = find(HF_dB <= maxval-3);
    freq_under_3dB = Fd(indices_3dB);
    freq_3dB = [freq_under_3dB(1), freq_under_3dB(length(freq_under_3dB))];
    bw = freq_3dB(2) - freq_3dB(1);
    fprintf("3 dB Frequencies (cycles/sample) = %d", freq_3dB);
    fprintf("3 dB Bandwidth (cycles/sample) = %d", bw); 

elseif freq_min < 0.1
    fprintf("Filter Typer: High-Pass\n\n");
    indices_3dB = find(HF_dB <= maxval-3);
    freq_under_3dB = Fd(indices_3dB);
    freq_3dB = [freq_under_3dB(1), freq_under_3dB(length(freq_under_3dB))];
    bw = freq_3dB(2) - freq_3dB(1);
    fprintf("3 dB Frequencies (cycles/sample) = %d", freq_3dB);
    fprintf("3 dB Bandwidth (cycles/sample) = %d", bw);

else 
    fprintf("Filter Typer: \n\n");
    indices_3dB = find(HF_dB <= maxval-3);
    freq_under_3dB = Fd(indices_3dB);
    freq_3dB = [freq_under_3dB(1), freq_under_3dB(length(freq_under_3dB))];
    bw = freq_3dB(2) - freq_3dB(1);
    fprintf("3 dB Frequencies (cycles/sample) = %d", freq_3dB);
    fprintf("3 dB Bandwidth (cycles/sample) = %d", bw);
end

% Digital frequency response plot
figure(figure_num+1);
subplot(2,1,1)
hold on;

% get max and min magnitudes
plot(Fd(max_index), abs(lin_max), '^r');
plot(Fd(min_index), abs(lin_min), 'vr');

% half-power (3dB) magnitude(s)
plot([Fd(1), Fd(num_of_f_points)],[half_power_mag, half_power_mag], 'g--');
plot(bw, [half_power_mag, half_power_mag], '*g', 'LineStyle', 'none');

% Analog frequency response plot
figure(figure_num+2);
subplot(2,1,1);
hold on;

% max and min magnitudes
plot(Fd_hz(max_index), maxval, '^r');
plot(Fd_hz(min_index), minval, 'vr');

% Vertical mag diff
plot(Fd_hz(1), maxval, '+r');
plot(Fd_hz(1), minval, '+r');

% 3dB magn(s)
plot([Fd_hz(1), Fd_hz(num_of_f_points)],[mag_3db, mag_3db], 'g--');
plot(bw*fsample, [mag_3db, mag_3db], '*g', 'LineStyle', 'none');



