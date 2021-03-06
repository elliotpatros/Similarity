%% summary

%% reset
clear all;

%% user parameters
target_file = 'voice1.wav';     % the sound we're trying to recreate
source_file = 'voice1.wav';     % the sound we're making the target out of

%% setup
x = rand(100, 1);
y = x(1:10);

x_len = length(x);
y_len = length(y);
[min_len, shorter] = min([x_len, y_len]);
max_len = max([x_len, y_len]);
n_frames = (max_len - min_len) + 1;

if 1 == shorter
    x_hat = x;
    y_hat = y;
else
    x_hat = y;
    y_hat = x;
end

rms_vector = zeros(n_frames, 1);
lag_vector = zeros(n_frames, 1);


%% find whatever it is this is called
for n = 1:n_frames
    % shift
    x_shift = x_hat;
    y_shift = y_hat(n:n+min_len-1);
    
    % get diff vector
    rms_vector(n) = rms(x_shift - y_shift);
    lag_vector(n) = n - 1;
    
    % plot
    subplot(311); 
    plot([x_shift, y_shift]); 
    title('x and y');
    subplot(312); 
    plot(rms_vector(1:n)); 
    title('rms');
    subplot(313);
    plot(lag_vector(1:n));
    title('lag vector');
    drawnow;
    pause;
end

% find location where correlation is the greatest
[~, idx] = min(rms_vector);
offset = lag_vector(idx);

figure;
if offset < 0
    plot(x);
    hold on;
    y_hat = [zeros(-offset, 1); y];
    plot(y_hat);
    hold off;
else
    plot(y);
    hold on;
    x_hat = [zeros(offset, 1); x];
    plot(x_hat);
    hold off;
end
