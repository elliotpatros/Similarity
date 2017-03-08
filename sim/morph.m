function bestFitIndex = morph(targetGrain, source)

Lgrain = length(targetGrain);
Lsource = length(source);

%% pick peaks
Ygrain = abs(fft(targetGrain));
Ygrain = Ygrain(1:end/2+1);
[gPeaks, gLocs] = findpeaks(Ygrain);
ngPeaks = length(gPeaks);

bestFitIndex = 0;
bestFitValue = 0;

hop = Lgrain/8;
nGrains = windows_in_length(Lsource, Lgrain, hop);

for n = 1:nGrains
    [in, out] = nth_pointer(n, Lgrain, hop);
    
    Y = abs(fft(source(in:out) .* hanning(Lgrain)));
    Y = Y(1:end/2+1);
    [sPeaks, sLocs] = findpeaks(Y);
    nsPeaks = length(sPeaks);
    
    
    
    r = abs(xcorr(Y, Ygrain, 0));
    
    if r > bestFitValue
        bestFitValue = r;
        bestFitIndex = in;
    end
end

% plot(Ygrain);

end

