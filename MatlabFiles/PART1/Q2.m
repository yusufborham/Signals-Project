
t = -0.01:1e-6:0.01;  
Ts = t(2) - t(1);     
Fs = 1/Ts;            

sinc_func = sin(pi * (10^3) .* t) ./ (pi * (10^3) .* t);   
sinc_func(isnan(sinc_func)) = 1;  

m_t = sinc_func .^ 2;


figure;
plot(t, m_t, 'LineWidth', 1.5);
title('Signal m(t) = sinc^2(10^{-3}t)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

N = length(m_t);
M_f = abs(fftshift(fft(m_t, N))) * Ts;   
f = linspace(-Fs/2, Fs/2, N);           

figure;
plot(f, M_f, 'LineWidth', 1.5);
title('Magnitude Spectrum |M(\omega)| of m(t)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

fc = 1e5;   
carrier = cos(2 * pi * fc * t);  
r_t = m_t .* carrier;

figure;
plot(t, r_t, 'LineWidth', 1.5);
title('Modulated Signal r(t) = m(t)cos(2\pi10^5t)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

R_f = abs(fftshift(fft(r_t, N))) * Ts;

figure;
plot(f, R_f, 'LineWidth', 1.5);
title('Magnitude Spectrum |R(\omega)| of r(t)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

disp('The spectrum R(\omega) is a shifted version of M(\omega) to +/- fc.');
disp('This is due to the modulation property of the Fourier Transform.');
