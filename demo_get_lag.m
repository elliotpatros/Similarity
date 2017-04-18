%% summary

%% reset
clear all;

%% user parameters
target_file = 'voice1.wav';     % the sound we're trying to recreate
source_file = 'voice1.wav';     % the sound we're making the target out of

%% setup
% nT = ((0:101)/100)';
x = rand(1000, 1); %zeros(10, 1); %sin(2*pi*2.1*nT); % 
y = x(1:10); %zeros(6, 1); %cos(2*pi*2*nT); % 
% x(4) = 1;
% y(1) = 1;

x_len = length(x);
y_len = length(y);
n_frames = x_len + y_len - 1;
rms_vector = zeros(n_frames, 1);
lag_vector = zeros(n_frames, 1);

%% find whatever it is this is called
for n = 1:n_frames
    % zero pad
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
    
    % plot
    subplot(311); 
    plot([x_, y_]); 
    title('x and y');
    subplot(312); 
    plot(rms_vector(1:n)); 
    title('rms');
    subplot(313);
    plot(lag_vector(1:n));
    title('lag vector');
    drawnow;
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
