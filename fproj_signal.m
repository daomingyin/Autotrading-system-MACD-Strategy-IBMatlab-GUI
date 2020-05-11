function signal = fproj_signal(t)

t = t(end-35:end, :);
[macdLine, signalLine] = macd(t);

slow = macdLine.Close(end-1:end);
fast = signalLine.Close(end-1:end);

signal1 = 0;
signal2 = 0;

if fast(1) < slow(1) && fast(2) > slow(2)
    signal1 = 1;
elseif fast(1) > slow(1) && fast(2) < slow(2)
    signal1 = -1;
end

if fast(1) < 0 && fast(2) > 0 
    signal2 = 1;
elseif fast(1) >0 && fast(2) < 0
    signal2 = -1;
end

signal = signal1 + signal2;

end