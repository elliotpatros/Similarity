%% summary
% this script shows how to use xcorr to offset one signal to match another.
% xcorr returns two values, CORRELATION and LAG.
%   CORRELATION - a measure of the similarity of two signals sliding
%   against each other. it returns a vector sized 2 * max(length(x),
%   length(y)) - 1. higher amplitude means higher correlation, and negative
%   values mean negative correlation (i.e. negative phase relationship)
%   LAG - the offset, or distance between the start of x and y.
% to get the offset of the x to correlate maximally to y, find the index of
% the correlation vector with the largest amplitude. that index is the
% index of the lag vector that will line up the two signals. zero pad the
% beginning of x by lag(index) samples to line them up.

%% reset
clear all;

%% setup
L = 60;
loc = 17;
y = zeros(L, 1);
y(loc) = -1;

x = zeros(5, 1);
x(1) = 1;


%% how to use xcorr to find time offset between two signals
[correlation, lag] = xcorr(y, x);
[~, idx] = max(abs(correlation));
offset = lag(idx);
x_hat = [zeros(offset, 1); x];

%% show results
subplot(211);
plot(y(1:length(x_hat)));
title('y');
subplot(212);
plot(x_hat);
title('x hat')
