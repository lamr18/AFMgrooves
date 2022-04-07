function [outputArg1] = plot_GBs(info)
% PLOT_GBS Plots the GB lines detected in GB_detection from the info file
% This function plots the grain boundary line ie. the exact GB line that is
% extracted from the GB detection mask.

list_GBs=info('list_GBs'); %read GB edge pixels from the info file
if mean(contains(info.keys,('GB_pixels')))~=0 %remove any pre-existing info packets about the GB lines
    remove(info,'GB_pixels');
    remove(info,'GB_lengths');
end

for i=1:length(list_GBs) % for each GB, obtain the coordinates of the edgepixels 
    edgepixels=list_GBs{i};
    info = get_line(info,edgepixels,true,0); % call the get_line function which returns a straight line between two pixels
    % info('GB_pixels') has been updated with the computed lines
end

% This section allows to print only the grain boundary lines drawn by this function, 
% rather than a combined plot from 'combined_plot.m'. Unhash to plot.


% GB_act_lines=zeros(info('x.pixels')); % create a new info packet
% 
% line_pixels=info('GB_pixels'); % read from info packet and 
% for i=1:length(line_pixels)
%    pixels_shade=line_pixels{i};
%    for j=1:length(pixels_shade)
%        pix=pixels_shade(j,:);
%        GB_act_lines(pix(1),pix(2))=1;
%    end
% end
% 
% imshow(GB_act_lines)
% set(gca,'YDir','normal');
% labx=xlabel('x (pixels)');
% labx.FontSize = 16;
% laby=ylabel('y (pixels)');
% laby.FontSize = 16;
% axis square;
% title(sprintf('GB detection for avpct= 0.950 and minpct= 1.012'))
% set(gca,'fontsize',15);

outputArg1 = info;

end

