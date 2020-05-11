% sdate = transpose(Data.dateTime);
function CumReturns = get_return(ticker)
Data   = IBMatlab('action', 'history', 'LocalSymbol', ticker, 'barSize','5 secs', 'DurationValue', 7200, 'DurationUnits', 'S', 'exchange', 'Globex', 'SecType', 'FUT');
Open = transpose(Data.open);
High = transpose(Data.high);
Low = transpose(Data.low);
Close = transpose(Data.close);
Volume = transpose(Data.volume);
periods = transpose(1:length(Open));

t = table(Open, High, Low, Close, Volume);

[MACDLine, signalLine]= macd(t);
MACDLine = addvars(MACDLine, periods, 'Before', 'Open');
signalLine = addvars(signalLine, periods, 'Before', 'Open');

slow = MACDLine.Close;
fast = signalLine.Close;

Signals = [];
Positions = [];
if fast(1) > 0
    Positions(1) = 1;
elseif fast(1) < 0
    Positions(1) = -1;
else
    Positions(1) = 0;
end

for i = 36:length(fast)
    j = i-35;
    signal1 = 0;
    signal2 = 0;
    signal = 0;
    
    if fast(i-1)<slow(i-1) && fast(i)>slow(i)
        signal1 = 1;
    elseif fast(i-1)>slow(i-1) && fast(i)<slow(i)
        signal1 = -1;
    else 
        signal1 = 0;
    end
    
    if fast(i-1)<0 && fast(i)>0
        signal2 = 1;
    elseif fast(i-1)>0 && fast(i)<0
        signal2 = -1;
    else signal2 = 0;
    end
    
    signal = signal1+signal2;
    Signals(j) = signal;
    Positions(j+1) = Positions(j) + signal;
    if Positions(j+1) > 1
        Positions(j+1) = 1;
    elseif Positions(j+1) < -1
        Positions(j+1) = -1;
    end
end

Positions = Positions(2:end-1);
Price_current = Data.close(36:end-1);
Price_future = Data.close(37:end);
Returns = [];
for i = 1:length(Price_current)
    Returns(i) = (Price_future(i) - Price_current(i))/Price_current(i);
end

MyReturns = Returns.*Positions;

CumReturns = [MyReturns(1)];
for i = 2:length(MyReturns)
    CumReturns(i) = (1+CumReturns(i-1))*(1+MyReturns(i)) -1;
end

FinalCumReturn = CumReturns(end);

CumReturns_nosignal = [Returns(1)];
for i = 2:length(Returns)
    CumReturns_nosignal(i) = (1+CumReturns_nosignal(i-1))*(1+Returns(i)) -1;
end

FinalCumReturn = CumReturns(end);
FinalCumReturn_nosignal = CumReturns_nosignal(end);
end

% plot(MACDLine.periods,MACDLine.Close,signalLine.periods,signalLine.Close);
% legend('MACDLine','NinePerMA')
% title('MACD')
