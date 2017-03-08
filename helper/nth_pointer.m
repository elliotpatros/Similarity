function [in, out] = nth_pointer(n, win, hop)

in = (n - 1) * hop + 1;
out = in + win - 1;

end

