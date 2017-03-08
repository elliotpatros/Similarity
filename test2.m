clear all;
clc;
addpath(genpath('.'));

%% user parameters
win = 256;  % window size (samples)
overlap = 2; % hop size == Lwin / overlap

target_filename = 'voice2.wav'; % sound we're trying to recreate
source_filename = 'voice1.wav'; % sound we're making target from

%% interface
show_progressbar = false;
plot_progress = true;
play_result = false;

%% load resources
[target, fs] = audioread(['./sources/', target_filename]);
[source, FS] = audioread(['./sources/', source_filename]);

%% complain
if fs ~= FS
    error('both signals must have the same sample rate');
end
clear FS;

%% setup
hwin = hanning(win);
hop = win / overlap;

Ltarget = length(target);
y = zeros(next_multiple(Ltarget, win), 1);
nGrains = windows_in_length(Ltarget, win, hop);

% zero pad target
target = [target; zeros(length(y) - Ltarget, 1)];

if plot_progress
    show_progressbar = false;
end

%% do it
if show_progressbar
h = waitbar(0, 'progress');
end
for n = 1:nGrains
    % get nth target grain (grain that we're trying to recreate)
    [tin, tout] = nth_pointer(n, win, hop);
    tgrain = target(tin:tout);
    tgrain = tgrain .* hwin;
    
    % find best grain
    sin = morph(tgrain, source); %xcorr_1(tgrain, source);
    sout = sin + win - 1;
    sgrain = source(sin:sout);
    sgrain = sgrain .* hwin;
    
    % normalize
    snorm = 1 / max(abs(sgrain));
    tnorm = 1 / max(abs(tgrain));
    sgrain = sgrain .* snorm ./ tnorm;
    
    % add grain to output
    y(tin:tout) = y(tin:tout) + sgrain;
    
    % show progress
    if plot_progress
        subplot(211);
        target_progress = zeros(size(target));
        target_progress(tin:tout) = tgrain;
        plot([target target_progress]);
        subplot(212);
        source_progress = zeros(size(source));
        source_progress(sin:sout) = sgrain;
        plot([source source_progress]);
        drawnow;
    end

    if show_progressbar
        waitbar(n / nGrains);
    end
end
if show_progressbar
    close(h);
end

%% display results
if play_result
    soundsc(y, fs);
end

%% clean up
clear n sgrain tgrain sin sout snorm tin tout tnorm 