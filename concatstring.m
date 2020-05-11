function string_concat = concatstring(multi_line_string)

string_concat = '';
for i = 1:length(multi_line_string)
    element_string = multi_line_string(i);
    string_concat = string_concat+element_string;
end
end