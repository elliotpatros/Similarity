%% reset
clear all;

%% setup
fs1 = 44100;
fs2 = 48000;

freq = 5;
dur = 1;

nT1 = (0:fs1*dur-1)/fs1;
x1 = sin(2*pi*freq*nT1);

nT2 = (0:fs2*dur-1)/fs2;
x2 = sin(2*pi*freq*nT2);

y = resample(x2, fs1, fs2); % convert x2 to sample rate of x1

subplot(311);
plot(x1);
title(['sampling rate = ', num2str(fs1)]);
subplot(312);
plot(x2);
title(['sampling rate = ', num2str(fs2)]);
subplot(313);
plot(y);
title(['x2 resampling factor = ', num2str(fs1/fs2)]);