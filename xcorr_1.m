clear all;
clc;
addpath(genpath('.'));


%% user parameters
% window size
win = 1024;
% overlap scalar
overlap = 16;
% plot?
should_plot = false;
% the sound we're trying to recreate
target_file = 'voice2.wav'; 
% the sound we're making the target out of
source_file = 'voice1.wav'; 


%% load samples
[target, fs] = audioread(['./sources/', target_file]);
[source, FS] = audioread(['./sources/', source_file]);
L = length(target);

% output
y = zeros(L, 1);


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


%% plotting constants
maxAmp = max(abs([target; source]));
nT = (0:1/fs:L/fs-1/fs)';
co = [0 0 1;
      1 0.5 0;
      0 0.5 0.5;
      0 1 0;
      0.75 0 0.75;
      0.75 0.75 0;
      0.25 0.25 0.25];
set(groot,'defaultAxesColorOrder',co)

%% find best matches
nGrainsStr = num2str(nGrains);
for n = 1:nGrains
    % find best matching section of source for current target
    pin = find_best_match(tGrains(:, n), source);
    pout = (pin + win) - 1;
    bestMatch = source(pin:pout) .* hwin;
    
    % normalize and window source grain
    sNorm = 1 / (overlap .* max(abs(bestMatch)));
    tNorm = 1 / max(abs(tGrains(:, n)));
    
    % add source grain to output
    rin = (n - 1) * hop + 1;
    rout = (rin + win) - 1;
    y(rin:rout) = y(rin:rout) ...
        + bestMatch .* (sNorm / tNorm);
    
    if should_plot
        % show where samples come from
        toDisplay = zeros(L, 1);
        toDisplay(pin:pout) = source(pin:pout);

        subplot(211);
        plot(nT, ...
            [source + maxAmp, target - maxAmp, toDisplay - maxAmp]);
        axis([-inf, inf, -maxAmp * 2, maxAmp * 2]);
        title('best match');

        % show reconstruction progress
        subplot(212);
        plot(nT, [target, y]);
        axis([-inf, inf, -maxAmp, maxAmp]);
        title('progress');

        % plot
        drawnow;
    end
    
    clc;
    disp([num2str(100*n/nGrains), '%']);
end


function bestFitIndex = find_best_match(targetGrain, sourceAudio)
    %FIND_BEST_MATCH uses cross correlation that returns the 
    %   sample which starts to most closely match the target grain.

    [cor, lag] = xcorr(targetGrain, sourceAudio);
    [~, I] = max(abs(cor));
    bestFitIndex = -lag(I);
end
