function [outputArg1] = read_xyz_image(filenamexyz)
%READ_XYZ_IMAGE Function allows to import .xyz files that have been
% modified and exported from Gwyddion

%Import lines from .xyz file
all_lines=readlines(filenamexyz);
all_lines=all_lines(1:(end-1)); %removes last line (empty)
all_lines=split(all_lines); %splits line along the delimiter
all_lines=str2double(all_lines); %converts string into double values

%Need to re-orient image so that the axes are drawn the same way as in .nid
all_lines(:,2)=abs(all_lines(:,2)-max(all_lines(:,2)))+min(all_lines(:,1));
all_lines=sortrows(all_lines);
all_lines(:,4)=all_lines(:,1);
all_lines(:,1)=all_lines(:,2);
all_lines(:,2)=all_lines(:,4);
all_lines=all_lines(:,1:3);
all_lines=sortrows(all_lines);

all_lines=all_lines(:,3);

outputArg1 = all_lines;
end

