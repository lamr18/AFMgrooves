function [outputArg1] = get_image_info(header,imageNo,str,n)
%GET_IMAGE_INFO Function reads over the dataset's information and returns
%information relative to the input sting 'str'

from = find(startsWith(header,'[DataSet-')); % find the specific dataset for the loaded image
from=from(2:end); %first dataset section is not relevant here

%look for input string within the chosen dataset
nblines = find(contains(header(from(imageNo),:),str)); %find the index of the line where the string is
str_read=header(from(imageNo),nblines); %read the line using the found index
str_read=strsplit(str_read,'='); %split the string into its different components

if n==1 % if numerical value, needs to be converted into a double
    str_value=str2double(str_read(end));
else % else it is returned as a string
    str_value=str_read(end);
end

outputArg1 = str_value;
end


