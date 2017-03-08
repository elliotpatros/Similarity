function total_distance = match_peaks(Y1, Y2)

L = length(Y1);
total_distance = 0;

[p1, locs1] = findpeaks(Y1, 'SortStr', 'descend');
[p2, locs2] = findpeaks(Y2);
nPeaks1 = length(p1);
nPeaks2 = length(p2);

M = zeros(L, 2);
for n = 1:nPeaks1
    bestMatch = [0, nPeaks1]; % [best index, best value]
    
    % calculate distance between this (nth loudest peak1) and the kth
    % highest frequency peak2. the two peaks with the shortest distance
    % will be saved in bestMatch
    for k = 1:nPeaks2
        D = abs(locs1(n) - locs2(k));
        if D < bestMatch(2)
            bestMatch = [k, D];
        end
    end

    % if the kth peak hasn't been matched yet, save the connection in M
    if isempty(M(M(:,2)==locs2(bestMatch(1))))
        total_distance = total_distance + bestMatch(2);
        M(n,:) = [locs1(n), locs2(bestMatch(1))];
    end
end

% get average distance
div = length(M(M(:,1)~=0));
if (div > 0)
    total_distance = total_distance / div;
else
    total_distance = 999999;
end


% delete non-connections
% M(M(:,1)==0 & M(:,2)==0, :) = [];


end

