function bestFitIndex = naive_morph(targetGrain, source)

Lgrain = length(targetGrain);
Lsource = length(source);

Ygrain = abs(fft(targetGrain));
Ygrain = Ygrain(1:end/2+1);

bestFitIndex = 0;
bestFitValue = 0;

hop = Lgrain/8;
nGrains = windows_in_length(Lsource, Lgrain, hop);

for n = 1:nGrains
    [in, out] = nth_pointer(n, Lgrain, hop);

    Y = abs(fft(source(in:out) .* hanning(Lgrain)));
    Y = Y(1:end/2+1);
    
    r = abs(xcorr(Y, Ygrain, 0));
    
    if r > bestFitValue
        bestFitValue = r;
        bestFitIndex = in;
    end
end

end

