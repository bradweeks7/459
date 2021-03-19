function plot_freq_responses(Fd, HF, fsample, figure_num)
%PLOT_FREQ_RESPONSES: Plots any DTFT frequency response from its complex
%                     H(F) data point vallues (rather than analytical H(F))
%   INPUTS:
%   Fd         = an array of digital frequency values (in units of cycles/sample) 
%                that correspond to the H(F) frequency response data values 
%   HF         = an array of complex H(F) DTFT frequency response values to plot 
%   fsample    = sampling frequency (in units of samples / second) 
%   figure_num = number of the 1st figure to use for the two plots 

% Get Analog Frequency Array
Fa = Fd.*fsample;

figure(figure_num+1)
% Plot the Magnitude Response 
subplot(2,1,1)  % Display plots in 2 rows / 1 column; This is the 1st plot.

% Plot the magnitude of HF on a linear scale
plot(Fd, abs(HF))
grid on
xlabel('Digital Frequency  F (cycles/sample)')
ylabel('Magnitude Response')
title('H(F) vs F (digital frequency)')

% Plot the Phase Response below the Magnitude Response
subplot(2,1,2) % Display plots in 2 rows / 1 column; This is the 2nd plot.

% Plot the Phase Angle vs Frequency     
plot(Fd, angle(HF)/pi)   % Normalize angle radian values by pi radians
grid on
xlabel('Digital Frequency  F (cycles/sample)')
ylabel('Phase Response /pi')

%Plot Analog Frequency
figure(figure_num+2)
% Plot the magnitude of HF on a linear scale
subplot(2,1,1);
plot(Fa, db(abs(HF)))
grid on
xlabel('Analog Frequency  f (seconds^-1)')
ylabel('Magnitude Response (dB)')
title('H(F) in dB vs f(analog)')

% Plot the Phase Angle vs Frequency
unit_sample_response(Bk, Ak, number_of_samples, figure_number+3)

end

