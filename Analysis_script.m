%Analysis_script This script allows for the automated analysis of AFM images of thermal grooves. 
%It calls the correct functions from the AFM grooves package.
%This function can only be used with square images, where x pixels = y pixels

%Add Script folder to path to call the function from any file folder
userpath='/Users/louiserosset/Documents/GitHub/AFMgrooves'; % Path to AFM package eg. '/Users/louiserosset/Documents/GitHub/AFMgrooves'
addpath (strcat(userpath,'/Script'))

% User inputs
filenamenid='NF_P_02016.nid';
filenamexyz='NF_P_02016_MPS.xyz';
imageNo=1;
gridsize=7;
aspect_ratio=false;
avpct=0.92;
minpct=1.015;
Nblines=10;
line_half_length=40;


[~,~,extxyz] = fileparts(filenamexyz);

% Automated script
% This section chooses the correct import function for the provided files,
% either .nid or .xyz functions
if extxyz== '.xyz' % if an .xyz file is provided, it will be read
    [frame header info] = import_xyz(filenamenid,filenamexyz,imageNo);
else  % if an .xyz file is not provided, the normal .nid process will be called
    [frame header info] = import_file(filenamenid,imageNo);
end

%From the imported frame, the 2D and 3D views are plotted as default. User can plot
%the 3D pixel view by manually importing and calling plot_image with the
%argument 'pixel' set to 'true'.
%This function returns the C matrix which contains the z data in a matrix of x*y pixels
figure(1)
figure(2)
C=plot_image(frame,imageNo,false);

% From the C matrix, the GB detection can be called to analyze the object 
% and detect the GBs. The parameters are user controlled, and it is
% strongly recommended for the user to determine the best gb detection
% parameters prior to calling the 'groove_analysis' function as this will
% significantly increase computational time. This function outputs the
% gb_detection binary matrix, the updated info object, and the number of
% detected segments (segs).
[gb_detection info segs]=GB_detection(info,C,gridsize,aspect_ratio,avpct,minpct);

%Plot the GB lines from the info file
info=plot_GBs(info);

%Create perpendicular lines to the GB lines. Nb of lines per segment and their length
%is set by the user.
[info countlines]= perp_line(info,Nblines,line_half_length);

%Create combined plot of the GB detection, GB lines and the perp lines
figure(3)
combined_plot(gb_detection,info);

%Extract the grain boundary profile geometry and calculate the cumulative
%probability distribution. One symmetric table and one asymetric table are
%created.

figure(4)
figure(5)
figure(6)
figure(7)
[symm_tab nosymm_tab] = cumu_prob(C,info);