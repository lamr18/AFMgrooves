function [outputArg1] = read_images(filename,header,len_header,imageNo)
%READ_IMAGES Imports the z data of the chosen image

fid = fopen(filename); % open a connection object
fseek(fid,len_header,'bof') %move to the end of the header
binlines = fread(fid, 'uint16'); %read the lines from the object

if binlines(1)~=8483 %check that first two lines are 35 and 33 (int8) (ie. correct location)
    error('file does not follow the allowed file format') 
end
binlines=binlines(2 : end); %trim binary to only have image data

lines=get_image_info(header,imageNo,"Lines",1); %get number of lines in an image
from=lines*lines*(imageNo-1)+1;
to=from+lines*lines-1;
binlines=binlines(from:to); % trim lines to only have chosen image's data

outputArg1 = binlines;
end

