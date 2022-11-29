clc; clear; close all;
x = 1:8;
y = fft(x);

fuck = fantasticfft_fft8(x);
actual_fuck = fuck(1:2:end) + 1i*fuck(2:2:end);