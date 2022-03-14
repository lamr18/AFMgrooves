function [outputArg1] = file_info(filename,header,imageNo)
%FILE_INFO Returns the essential information relative to the imported file.
% Parses through the header to return chosen information

k={'filename','history','Instrument','Imaging Mode', 'x.pixels', 'y.pixels', 'x.unit', 'y.unit', 'z.unit'};
v={filename, ' ','NanoSurf', 'Phase Contrast', get_image_info(header,imageNo,'Points',1), ...
    get_image_info(header,imageNo,'Lines',1), get_image_info(header,imageNo,'Dim0Unit',0), ...
    get_image_info(header,imageNo,'Dim1Unit',0), get_image_info(header,imageNo,'Dim2Unit',0)};

info=containers.Map(k,v); % create map container with keys and values (similar to a dictionary)
outputArg1 = info;
end

