function bestFitIndex = morph(targetGrain, source)

% Lgrain = length(targetGrain);
% Lsource = length(source);

%% pick peaks
Ygrain = abs(fft(targetGrain));
Ygrain = Ygrain(1:end/2+1);
[gPeaks, gLocs] = findpeaks(Ygrain);

bestFitIndex = 1;
bestFitValue = 999999;

for n = 1:Lsource-Lgrain
    [in, out] = nth_pointer(n, length(targetGrain), 1);
    Y = abs(fft(source(in:out)));
    Y = Y(1:end/2+1);
    [sPeaks, sLocs] = findpeaks(Y);
end

plot(Ygrain);

end

