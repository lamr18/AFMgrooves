function combined_plot(gb_detection,info)
%COMBINED_PLOT Summary of this function goes here
%   Detailed explanation goes here

%gb_detection=gb_detection*0.8;

line_pixels=info('GB_pixels');
for i=1:length(line_pixels)
    pixels_shade=line_pixels{i};
    for j=1:length(pixels_shade)
        pix=pixels_shade(j,:);
        gb_detection(pix(1),pix(2))=0.27;
    end
end


perp_line_pixels=info('perp_line_pixels');
for i=1:length(perp_line_pixels)
    pixels_shade=perp_line_pixels{i};
    for j=1:length(pixels_shade)
        pix=pixels_shade(j,:);
        gb_detection(pix(1),pix(2))=0.55;
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

end

