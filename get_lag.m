function [lag] = get_lag(x, y)
    
% check that x and y are mono
if 1 ~= min(size(x)) || 1 ~= min(size(y))
    error('x and y must be either scalars or vectors');
end

% check that x and y are column vectors
if isrow(x) || isrow(y)
    error('x and y must be column vectors');
end

x_len = length(x);
y_len = length(y);
[min_len, shorter] = min([x_len, y_len]);
max_len = max([x_len, y_len]);
n_frames = (max_len - min_len) + 1;

if 1 == shorter
    x_shift = x;
    y_hat = y;
else
    x_shift = y;
    y_hat = x;
end

rms_vector = zeros(n_frames, 1);
lag_vector = zeros(n_frames, 1);

parfor n = 1:n_frames
    % shift
    y_shift = y_hat(n:n+min_len-1);
    
    % get diff vector
    rms_vector(n) = rms(x_shift - y_shift);
    lag_vector(n) = n - 1;
end

[~, idx] = min(rms_vector);
lag = lag_vector(idx);

% plot(rms_vector);
% title(['lag = ' num2str(lag)]);
% drawnow;
