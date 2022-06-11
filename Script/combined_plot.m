function combined_plot(gb_detection,info)
% COMBINED_PLOT This function plots the GB detection, GB lines and perp
% lines all on one plot so the user can see the overlay of features and
% compare more easily to the original data.
% The gb detection input comes from the GB_detection function, while the
% info is generated in the 'import_file' and 'import_xyz' functions and the line
% information is appended to info when plot_GBs and perp_line are called.

%Goes through the info packet and shades the pixels that belong to a GB line

line_pixels=info('GB_pixels');
for i=1:length(line_pixels)
    pixels_shade=line_pixels{i};
    for j=1:length(pixels_shade)
        pix=pixels_shade(j,:);
        gb_detection(pix(1),pix(2))=18; % set to 0.27 for contrast, any number could be chosen
    end
end

%Goes through the info packet and shades the pixels that belong to a perp line
perp_line_pixels=info('perp_line_pixels');
for i=1:length(perp_line_pixels)
    pixels_shade=perp_line_pixels{i};
    for j=1:length(pixels_shade)
        pix=pixels_shade(j,:);
        gb_detection(pix(1),pix(2))=16; % set to 0.8 for contrast, any number could be chosen
    end
end

imagesc(gb_detection)
set(gca,'YDir','normal');
labx=xlabel('x (pixels)');
labx.FontSize = 16;
laby=ylabel('y (pixels)');
laby.FontSize = 16;
axis square;
title(sprintf('GB detection for avpct= 0.950 and minpct= 1.012'))
set(gca,'fontsize',15);

if mean(contains(info.keys,('perp_whichGB')))~=0
    perp_GBno=info('perp_whichGB');
    %Goes through the info packet and shades the pixels that belong to a perp line
    perp_line_pixels=info('perp_line_pixels');
    for i=1:length(perp_line_pixels)
        pixels_shade=perp_line_pixels{i};
        for j=1:length(pixels_shade)
            pix=pixels_shade(j,:);
            gb_detection(pix(1),pix(2))=perp_GBno{i}; % set to 0.8 for contrast, any number could be chosen
        end
    end
    
    imagesc(gb_detection)
    set(gca,'YDir','normal');
    labx=xlabel('x (pixels)');
    labx.FontSize = 16;
    laby=ylabel('y (pixels)');
    laby.FontSize = 16;
    axis square;
    title(sprintf('GB detection for avpct= 0.950 and minpct= 1.012'))
    set(gca,'fontsize',15);

else
    disp('No GB numbers assigned')
end

end

