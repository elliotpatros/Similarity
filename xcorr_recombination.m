%% summary

%% reset
clear all;
addpath(genpath('.'));

%% user parameters
win_len = 8;                 % window size
overlap = 2;                    % overlap scalar

% target_file = 'voice1.wav';     % the sound we're trying to recreate
% source_file = 'voice2.wav';     % the sound we're making the target out of
target_file = '02 Ready for the Weekend.m4a';
source_file = '16 Vamp (Live Edit).m4a';

%% setup
[target, fs] = audioread(target_file);
[source, FS] = audioread(source_file);

% make mono
target = sum(target, 2);
source = sum(source, 2); 

% take only the first few seconds
target = target(fs*20:fs*21);
source = source(fs*20:fs*21);

win = hanning(win_len);

len = length(target);
hop_len = win_len / overlap;
n_windows = ceil((len - (win_len - 1)) / hop_len);

y = zeros(len, 1);


%% let's recombinate
for n = 1:n_windows
    clc;
    disp(['sorting window ' num2str(n) ' of ' num2str(n_windows)]);
    
    % get target grain (the nth grain we're trying to recreate)
    t_from = (n - 1) * hop_len + 1;
    t_till = t_from + win_len - 1;
    t_grain = target(t_from:t_till);
    
    % find out it's lag relative to source
    lag = get_lag(t_grain, source, true);
    
    % get source grain from lag
    s_from = lag+1;
    s_till = s_from + win_len - 1;
    s_grain = source(s_from:s_till);
    
    % window both grains
    t_grain = t_grain .* win;
    s_grain = s_grain .* win;
    
    % get normalization values for target and source grains\
    norm = max(abs(t_grain)) ./ max(abs(s_grain));
    
    % add source grain to y
    y(t_from:t_till) = y(t_from:t_till) + s_grain .* norm;
end

subplot(211);
plot(target);
subplot(212);
plot(y);
