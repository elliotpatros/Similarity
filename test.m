clear all;
clc;
addpath(genpath('.'))

%% user parameters
% window size
win = 4096;
 % overlap scalar
overlap = 2;

% the sound we're trying to recreate
target_file = 'voice2.wav'; 
% the sound we're making the target out of
source_file = 'voice1.wav'; 


%% load samples
[target, fs] = audioread(['./sources/', target_file]);
[source, FS] = audioread(['./sources/', source_file]);
L = length(target);


%% complain
if fs ~= FS
    error('both signals must have the sample sample rate');
end
clear FS;
if L ~= length(source)
    error('both signals must be the same length');
end


%% make granular stuff
hwin = hanning(win);
hop = win / overlap;
nGrains = windows_in_length(L, win, hop);

% target grains
tGrains = zeros(win, nGrains);
pin = 1;
pout = win;
for n = 1:nGrains
    tGrains(:, n) = target(pin:pout);
    pin = pin + hop;
    pout = pout + hop;
end


%% find best matches
nGrainsStr = num2str(nGrains);
h = waitbar(0, 'progress');
for n = 1:nGrains
    pin = xcorr_1(tGrains(:, n), source);
    pout = (pin + win) - 1;
    
    sNorm = 1 / max(abs(source(pin:pout)));
    tNorm = 1 / max(abs(tGrains(:, n)));
    tGrains(:, n) = source(pin:pout) .* hwin .* sNorm ./ tNorm;
    
    waitbar(n / nGrains);
    pause(0.1)
end
close(h)


%% reconstruct
y = zeros(L, 1);
pin = 1;
pout = win;
for n = 1:nGrains
    y(pin:pout) = y(pin:pout) + tGrains(:, n);
    pin = pin + hop;
    pout = pout + hop;
end


%% plot
plot(y)











