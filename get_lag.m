function [lag] = get_lag(x, y, resample_factor, should_normalize)
    
if (resample_factor ~= 1)
    x = resample(x, 1, resample_factor);
    y = resample(y, 1, resample_factor);
end

% check if we should normalize
if nargin < 4
    should_normalize = false;
end

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

% normalization
x_norm = max(abs(x_shift));

for n = 1:n_frames 
    % shift
    z = n - 1;
    y_shift = y_hat(n:z+min_len);
    
    % get diff vector
    if should_normalize
        rms_vector(n) = rms(x_shift ./ x_norm - y_shift ./ max(abs(y_shift)));
    else
        rms_vector(n) = rms(x_shift - y_shift);
    end
    
    lag_vector(n) = z;
end

[~, idx] = min(rms_vector);
lag = lag_vector(idx) * resample_factor;

plot(rms_vector);
title(['lag = ' num2str(lag)]);
drawnow;
