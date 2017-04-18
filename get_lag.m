function [lag] = get_lag(x, y)

x_len = length(x);
y_len = length(y);
n_frames = x_len + y_len - 1;
rms_vector = zeros(n_frames, 1);
lag_vector = zeros(n_frames, 1);
    
for n = 1:n_frames
    % shift x against y
	shift = n_frames - (n - 1);
    x_ = zeros(n_frames, 1);
    y_ = zeros(n_frames, 1);
    if shift >= y_len
        y_from = shift - (y_len - 1);
        y_till = shift;
        y_(y_from:y_till) = y;
        
        x_from = 1;
        x_till = x_len;
        x_(x_from:x_till) = x;
    else
        y_from = 1;
        y_till = y_len;
        y_(y_from:y_till) = y;
        
        x_from = y_len - (shift - 1);
        x_till = x_from + x_len - 1;
        x_(x_from:x_till) = x;
    end
    
    % get diff vector
    rms_vector(n) = rms(x_ - y_);
    lag_vector(n) = x_from - y_from;
end

% find location where correlation is the greatest
[~, idx] = min(rms_vector);
lag = lag_vector(idx);
