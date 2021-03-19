[dn, n] = unit_sample(16);
figure(1);
stem(n,dn,'.');
grid on;
xlabel('Sample Indexes [n]')
ylabel('Magnitude')
title('Unit Sample Response n vs dn')