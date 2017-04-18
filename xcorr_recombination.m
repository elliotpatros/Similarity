%% summary

%% reset
clear all;

%% user parameters
win_len = 8;                    % window size
overlap = 2;                    % overlap scalar

target_file = 'voice1.wav';     % the sound we're trying to recreate
source_file = 'voice1.wav';     % the sound we're making the target out of

%% setup
target = audioread(target_file);
source = audioread(source_file);

len = length(target);
hop_len = win_len / overlap;
n_windows = ceil((len - (win_len - 1)) / hop_len);

%% let's recombinate
for n = 1:n_windows
    % get target grain (the nth grain we're trying to recreate)
    t_from = (n - 1) * hop_len + 1;
    t_till = t_from + win_len - 1;
    t_grain = target(t_from:t_till);
    
    [correlation, lagVector] = xcorr(t_grain, source);
    [~, index] = max(abs(correlation));
    offset = lagVector(index);
    
    
end

%     [correlation, lag] = xcorr(y, x);
%     [~, idx] = max(abs(correlation));
%     offset = lag(idx);
%     x_hat = [zeros(offset, 1); x];







