function bestFitIndex = morph(targetGrain, source)

Lgrain = length(targetGrain);
Lsource = length(source);

%% pick peaks
Ygrain = abs(fft(targetGrain));
Ygrain = Ygrain(1:end/2+1);
% [gPeaks, gLocs] = findpeaks(Ygrain);

bestFitIndex = 0;
bestFitValue = 0;

for n = 1:Lsource-Lgrain
    [in, out] = nth_pointer(n, length(targetGrain), 1);
    Y = abs(fft(source(in:out)));
    Y = Y(1:end/2+1);
%     [sPeaks, sLocs] = findpeaks(Y);
    r = abs(xcorr(Y, Ygrain, 0));
    
%     subplot(211);
%     plot([Y Ygrain]);
%     subplot(212);
%     plot(r);
%     drawnow;
    
    if r > bestFitValue
        bestFitValue = r;
        bestFitIndex = n;
    end
end

% plot(Ygrain);

end

