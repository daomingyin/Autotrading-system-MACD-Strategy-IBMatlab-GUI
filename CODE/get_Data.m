function ABC=get_Data(FutureTicker)
data = IBMatlab('action','realtime', 'LocalSymbol', FutureTicker, 'exchange', 'Globex', 'SecType', 'FUT', 'QuotesNumber', inf,'QuotesBufferSize', 5000);
high=data.data.high(end);
low=data.data.low(end);
close=data.data.close(end);
open=data.data.open(end);
ABC=table(high,low,close,open)
end
