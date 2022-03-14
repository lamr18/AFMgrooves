function [outputArg1,outputArg2] = import_file(filename,imageNo)
%IMPORT_FILE imports NanoSurf .nid AFM files
% This function imports the file, creates a formatted header and a frame
% with all of the chosen image's data.

% add file extension check
[~,~,ext] = fileparts(filename);
if ext~='.nid'
    error('This file format is not supported. Please input a .nid file.')
end

%Import file
[len_header, header]=read_header(filename); %load header
binlines = read_images(filename,header,len_header,imageNo); %load z data

%Image info
Dim0Min=get_image_info(header,imageNo,'Dim0Min',1);
Dim1Min=get_image_info(header,imageNo,'Dim1Min',1);

Dim0Range=get_image_info(header,imageNo,'Dim0Range',1);
Dim1Range=get_image_info(header,imageNo,'Dim1Range',1);
Dim2Range=get_image_info(header,imageNo,'Dim2Range',1);

Dim0Length=get_image_info(header,imageNo,'Points',1);
Dim1Length=get_image_info(header,imageNo,'Lines',1);
Dim2Bits=get_image_info(header,imageNo,'SaveBits',1);

%pre-allocate memory to frame
vartype={'double','double','double','double','double','double'};
varname={'x','y','z','x_nm','y_nm','z_nm'};
frame=table('Size',[length(binlines) 6],'VariableTypes',vartype,'VariableNames', varname); 

%build frame
x=repelem(1:Dim0Length,Dim0Length);
x_nm=repelem(linspace(Dim0Min,Dim0Min+Dim0Range,Dim0Length),Dim0Length);
y=repmat(1:Dim0Length,[1 Dim0Length]);
y_nm=repmat(linspace(Dim1Min,Dim1Min+Dim1Range,Dim1Length),[1 Dim1Length]);

frame.x=x(:);
frame.y=y(:);
frame.z=binlines;
frame.x_nm=x_nm(:)*1e9;
frame.y_nm=y_nm(:)*1e9;
frame.z_nm=binlines*(Dim2Range/(2^Dim2Bits))*1e9;

outputArg1 = frame;
outputArg2 = header;
end

