%% summary

%% reset
clear all;

%% user parameters
target_file = 'voice1.wav';     % the sound we're trying to recreate
source_file = 'voice1.wav';     % the sound we're making the target out of

%% setup
nT = ((0:101)/100)';
x = sin(2*pi*2*nT); % zeros(50, 1); %
y = cos(2*pi*2*nT); % zeros(50, 1); %
% x(5) = 1;
% y(11) = 1;
n_frames = 2 * max(length(x), length(y)) - 1;
rms_vector = zeros(n_frames, 1);
lag_vector = zeros(n_frames, 1);

%% find whatever it is this is called
for n = 1:n_frames
    % zero pad
    pad_len = floor(n_frames / 2) - n;
    
    % offset x and y
    if (pad_len > 0)
        x_ = [x; zeros(pad_len, 1)];
        y_ = [zeros(length(x_) - length(y), 1); y];
    else
        x_ = [zeros(abs(pad_len), 1); x];
        y_ = [y; zeros(length(x_) - length(y), 1)];
    end
    
    % get diff vector
    rms_vector(n) = rms(x_ - y_);
    lag_vector(n) = -pad_len;
    
    % plot
%     subplot(211); plot([x_, y_]);
%     subplot(212); plot(rms_vector);
%     drawnow; pause(0.01);
end

% find location where correlation is the greatest
[~, idx] = min(rms_vector);
offset = lag_vector(idx);

if offset < 0
    plot(x);
    hold on;
    y_hat = [zeros(-offset, 1); y];
    plot(y_hat(1:length(x)));
    hold off;
else
    plot(y);
    hold on;
    x_hat = [zeros(offset, 1); x];
    plot(x_hat(1:length(y)));
    hold off;
end







