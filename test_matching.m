L = 50;

Y1 = rand(L, 1);
Y2 = rand(L, 1);

[p1, locs1] = findpeaks(Y1, 'SortStr', 'descend');
[p2, locs2] = findpeaks(Y2);
nPeaks1 = length(p1);
nPeaks2 = length(p2);

M = zeros(L, 2);
for n = 1:nPeaks1
    bestMatch = [0, nPeaks1]; % [best index, best value]
    
    for k = 1:nPeaks2
        D = abs(locs1(n) - locs2(k));
        if D < bestMatch(2)
            bestMatch = [k, D];
        end
    end

    if isempty(M(M(:,2)==locs2(bestMatch(1))))
        M(n,:) = [locs1(n), locs2(bestMatch(1))];
    end
end

M(M(:,1)==0 & M(:,2)==0, :) = [];

plot3(1:L, zeros(1,L), Y1); % plot Y1
hold on;
plot3(1:L, ones(1,L), Y2);  % plot Y2
plot3(M(:,1), zeros(1,length(M)), Y1(M(:,1)), 'k.'); % plot peaks
plot3(M(:,2), ones(1, length(M)), Y2(M(:,2)), 'k.'); % plot peaks
for n = 1:length(M)
    plot3(M(n,:), [0 1], [Y1(M(n,1)), Y2(M(n,2))], 'k-');
end
hold off;


