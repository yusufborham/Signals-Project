T = pi;                     
omega0 = 2;                 
k = -10:10;                 
 
ck = zeros(size(k));         

for i = 1:length(k)
    k_val = k(i);
    exponent = 1 + 1j * omega0 * k_val;  
    numerator = exp(-exponent * T) - 1; 
    ck(i) = (1 / T) * (numerator / -exponent);
end

ck_magnitude = abs(ck);
ck_phase = angle(ck);

figure;

subplot(2,1,1);
stem(k, ck_magnitude, 'filled', 'r');
title('Magnitude of Fourier Series Coefficients |c_k|');
xlabel('k');
ylabel('|c_k|');
grid on;

subplot(2,1,2);
stem(k, ck_phase, 'filled', 'b');
title('Phase of Fourier Series Coefficients \angle c_k');
xlabel('k');
ylabel('Phase (radians)');
grid on;
