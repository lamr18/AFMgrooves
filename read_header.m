function [outputArg1, outputArg2] = read_header(filename)
%This function allows for an initial read of the file and partition into
%header and data. It returns a list with the length of the header and an unformatted
%header.


% If file got to this point, the filename corresponds to a file with a
% matching file type/ file extension. File check in main import function

all_lines = readlines(filename);
lines_header = find(contains(all_lines,'#!'))-1; % tells us where the data section starts and how many lines there are in the header
headerlines = all_lines(1:(lines_header)); % truncate the data beyond the end of the header

% counts characters in the header
len_header = 0; 
for i = 1:lines_header
    len_header = len_header + strlength(headerlines(i)) +2;
end

from = find(startsWith(headerlines,'[')); % all header sections start with '['
to = [from(2:end)-1; lines_header]-1; % removes end paragraph break

%header = arrayfun(@x x(from[i]:to[i]),headerlines)

outputArg1 = len_header;
outputArg2 = headerlines;


end

