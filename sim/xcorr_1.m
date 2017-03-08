function bestFitIndex = xcorr_1(targetGrain, sourceAudio)
%FIND_BEST_MATCH uses cross correlation that returns the 
%   sample which starts to most closely match the target grain.

[cor, lag] = xcorr(targetGrain, sourceAudio);
[~, I] = max(abs(cor));
bestFitIndex = -lag(I);

end

