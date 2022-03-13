function [outputArg1] = get_image_info(header,imageNo,str,n)
%UNTITLED Function reads over the dataset's information and returns
%information relative to the input 'str'

from = find(startsWith(header,'[DataSet-'));
from=from(2:end); %first dataset section is not relevant here

nblines = find(contains(header(from(imageNo),:),str));
str_read=header(from(imageNo),nblines);
str_read=strsplit(str_read,'=');

if n==1 % if numerical value, needs to be converted into a double
    str_value=str2double(str_read(end));
else % else it is returned as a string
    str_value=str_read(end);
end

outputArg1 = str_value;
end


