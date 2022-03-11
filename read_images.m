function [outputArg1] = read_images(filename)
%READ_IMAGES Summary of this function goes here
%   Detailed explanation goes here

con = fopen(filename); % open a connection object
binlines = fread(con); %read the lines from the object

outputArg1 = binlines;
%outputArg2 = inputArg2;
end

