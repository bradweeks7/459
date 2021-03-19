function [dn, n] = unit_sample(number_of_samples)
%UNIT_SAMPLE: Creates a complete unit sample sequence starting at n =0
%             Extends to number_of_samples, specifies by the user
%   INPUT(S):
%   dn        = an array of digital frequency values (in units of cycles/sample) 
%   OUTPUT(S):
%   n         = has the sample index values (starting at 0) corresponding
%               to each of the dn samples

dn = zeros(number_of_samples, 1);
dn(1) = 1;
n = 0:1:number_of_samples-1;
end
