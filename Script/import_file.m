function [outputArg1,outputArg2, outputArg3] = import_file(filename,imageNo)
%IMPORT_FILE imports NanoSurf .nid AFM files
% This function imports the file, creates a formatted header and a frame
% with all of the chosen image's data.
% File extension check
[~,~,ext] = fileparts(filename);
if ext~='.nid'
    error('This file format is not supported. Please input a .nid file.')
end

%Import file
[len_header, header]=read_header(filename); %load header
binlines = read_images(filename,header,len_header,imageNo); %load z data

%Create container to hold essential information
info=file_info(filename, header, imageNo);

%Read image info to fill the info container from above
Dim0Min=get_image_info(header,imageNo,'Dim0Min',1);
Dim1Min=get_image_info(header,imageNo,'Dim1Min',1);
Dim0Range=get_image_info(header,imageNo,'Dim0Range',1);
Dim1Range=get_image_info(header,imageNo,'Dim1Range',1);
Dim2Range=get_image_info(header,imageNo,'Dim2Range',1);
Dim2Bits=get_image_info(header,imageNo,'SaveBits',1);

%Pre-allocate memory to frame
vartype={'double','double','double','double','double','double'};
varname={'x','y','z','x_nm','y_nm','z_nm'};
frame=table('Size',[length(binlines) 6],'VariableTypes',vartype,'VariableNames', varname); 

%Build frame
x=repelem(1:info('x.pixels'),info('x.pixels')); %range of pixels from 1 to max pixel
x_nm=repelem(linspace(Dim0Min,Dim0Min+Dim0Range,info('x.pixels')),info('x.pixels')); % same as above but in nm
y=repmat(1:info('y.pixels'),[1 info('y.pixels')]); %range of pixels from 1 to max pixel
y_nm=repmat(linspace(Dim1Min,Dim1Min+Dim1Range,info('y.pixels')),[1 info('y.pixels')]); % same as above but in nm

frame.x=x(:); 
frame.y=y(:);
frame.z=binlines; %data from binlines
frame.x_nm=x_nm(:)*1e9;
frame.y_nm=y_nm(:)*1e9;
frame.z_nm=binlines*(Dim2Range/(2^Dim2Bits))*1e9; %data from binlines converted to nm

%Add information to 'info' container
info('x.conv')=(max(frame.x_nm))/(max(frame.x-1));
info('y.conv')=(max(frame.y_nm))/(max(frame.y-1));
info('z.conv')=frame.z_nm(1)/frame.z(1);

outputArg1 = frame;
outputArg2 = header;
outputArg3 = info;
end

