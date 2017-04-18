function bestFitIndex = morph(targetGrain, source)

Lgrain = length(targetGrain);
Lsource = length(source);

%% pick peaks
Ygrain = abs(fft(targetGrain));
Ygrain = Ygrain(1:end/2+1);

bestFitIndex = 0;
bestFitValue = 999999;

hop = Lgrain/4;
nGrains = windows_in_length(Lsource, Lgrain, hop);

for n = 1:nGrains
    [in, out] = nth_pointer(n, Lgrain, hop);
    
    Y = abs(fft(source(in:out) .* hanning(Lgrain)));
    Y = Y(1:end/2+1);
    
    peak_distance = match_peaks(Y, Ygrain);
    if bestFitValue > peak_distance
        bestFitValue = peak_distance;
        bestFitIndex = in;
    end
end

% plot(Ygrain);

end

