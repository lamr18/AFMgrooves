function [outputArg1] = plot_GBs(info)
%PLOT_GBS Plots the GB lines detected in GB_detection
%   Detailed explanation goes here

list_GBs=info('list_GBs');
if mean(contains(info.keys,('GB_pixels')))~=0
    remove(info,'GB_pixels');
    remove(info,'GB_lengths');
end

for i=1:length(list_GBs)
    %obtain the pixels of the GB
    edgepixels=list_GBs{i};
    info = get_line(info,edgepixels,true,0);
end

GB_act_lines=zeros(info('x.pixels'));

line_pixels=info('GB_pixels');
for i=1:length(line_pixels)
    pixels_shade=line_pixels{i};
    for j=1:length(pixels_shade)
        pix=pixels_shade(j,:);
        GB_act_lines(pix(1),pix(2))=1;
    end
end


imshow(GB_act_lines)
set(gca,'YDir','normal');
labx=xlabel('x (pixels)');
labx.FontSize = 16;
laby=ylabel('y (pixels)');
laby.FontSize = 16;
axis square;
title(sprintf('GB detection for avpct= 0.950 and minpct= 1.012'))
set(gca,'fontsize',15);

outputArg1 = info;

end

