function wins = windows_in_length(L, win, hop)

wins = ceil((L - (win - 1)) / hop);

end

