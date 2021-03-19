function [hn, n] = unit_sample_response(Bk, Ak, number_of_samples, figure_number)
%function [hn, n] = unit_sample_response(Bk, Ak, number_of_samples, figure_number)
%UNIT_SAMPLE: Creates a complete unit sample sequence starting at n =0
%             Extends to number_of_samples, specifies by the user
%   INPUT(S):
%   Bk                = a list of the Bk coefficients of the filter difference 
%                       equation (coefficients of the "x" terms)
%   Ak                = a list of the Ak coefficients of the filter difference
%                       equation
%   number_of_samples = # of unit sample response sequence samples to find
%   figure_number     = # figure for the hn sequence plot
%   OUTPUT(S):
%   hn                = 
%   n                 = has the sample index values (starting at 0) corresponding
%                       to each of the dn samples

dn = zeros(number_of_samples, 1);
dn(1) = 1;
hn = filter(Bk, Ak, dn); 
n = 0:1:number_of_samples-1;
figure(figure_number);
stem(n,hn,'.');
grid on;
xlabel('Sample Indicies [n]')
ylabel('Magnitude of h[n]')
title('Unit Sample Response')
end
