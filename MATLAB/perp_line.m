function [outputArg1 outputArg2]= perp_line(info,Nblines,line_half_length)
% PERP_LINE Create perpendicular lines to the GB lines. Nb of lines per segment 
% and their length is set by the user. 

GB_pixels=info('GB_pixels'); %read GB line pixels from the info file
pix_bounds=info('x.pixels');

if mean(contains(info.keys,('perp_line_pixels')))~=0 %remove any pre-existing info packets about perp lines
    remove(info,'perp_line_pixels');
    remove(info,'perp_line_lengths');
    remove(info,'perp_whichGB');
end


for i=1:length(GB_pixels) % circle through each GB line
    GBno=i; %counter to know which GB is being profiled

    %obtain the line of pixels that defines the GB
    GB_pix=GB_pixels{i};
    GB_pix=sortrows(GB_pix); %sort rows in x to get the GB going from left to right
    startpix=GB_pix(1,:);
    endpix=GB_pix(end,:);
    

    Dx=endpix(1)-startpix(1); %compute dx to evaluate slope of GB line
    Dy=endpix(2)-startpix(2); %compute dy to evaluate slope of GB line
    perp_slope=-1/(Dy/Dx); %slope of perpendicular line (-1/m) where m is the slope of the GB line
    
    % If the user requests more perp lines through the GB line than there are 
    % pixels in the GB line, Nblines is reset to the length of the GB line
    % (which is the max nb of lines you can draw through the GB line)
    
    N_lines=0;
    if Nblines>length(GB_pix)
        N_lines=length(GB_pix);
    else 
        N_lines=Nblines;
    end
    
    % Randomly pick the pixels from GB line where the perp lines will intersect
    rand_pix=randperm(length(GB_pix),N_lines); 
    
    for j=1:length(rand_pix) %for each intersection, create a perpendicular line going through
        perp_pixels=[];
 
        mx=-1*Dy/sqrt(Dy^2+Dx^2); %normalized unit of movement in x
        my=1*Dx/sqrt(Dy^2+Dx^2); %normalized unit of movement in y

        % Move by (normalized unit * half length) distance in x and y and -x and -y 
        % Then round to an integer number (pixels are integers)
        perp_pixels(1,1)=round(GB_pix(rand_pix(j),1)+(mx)*line_half_length); %move by certain distance and round to an integer number
        perp_pixels(1,2)=round(GB_pix(rand_pix(j),2)+(my)*line_half_length);
        perp_pixels(2,1)=round(GB_pix(rand_pix(j),1)-(mx)*line_half_length);
        perp_pixels(2,2)=round(GB_pix(rand_pix(j),2)-(my)*line_half_length);
        
        % Making sure all the pixels are within the range [1 pix_bound]
        if ((perp_pixels(1,1)<1) || (perp_pixels(1,2)<1) || (perp_pixels(2,1)<1) || (perp_pixels(2,2)<1) || ...
                (perp_pixels(1,1)>pix_bounds) || (perp_pixels(1,2)>pix_bounds) || (perp_pixels(2,1)>pix_bounds) || (perp_pixels(2,2)>pix_bounds))
            continue
        end
        info = get_line(info,perp_pixels,false,GBno);
         % info('perp_line_pixels') has been updated with the computed lines
    end
end

% This section allows to print only the perpendicular profile lines drawn by this function, 
% rather than a combined plot from 'combined_plot.m'. Unhash to plot.

perp_lines=zeros(info('x.pixels'));

perp_line_pixels=info('perp_line_pixels');
count_lines=0;
for i=1:length(perp_line_pixels)
    pixels_shade=perp_line_pixels{i};
    count_lines=count_lines+1;
    for j=1:length(pixels_shade)
        pix=pixels_shade(j,:);
        perp_lines(pix(1),pix(2))=1;
    end
end

% imshow(perp_lines)
% set(gca,'YDir','normal');
% labx=xlabel('x (pixels)');
% labx.FontSize = 16;
% laby=ylabel('y (pixels)');
% laby.FontSize = 16;
% axis square;
% title(sprintf('Perp lines for avpct= 0.950 and minpct= 1.012'))

outputArg1 = info;
outputArg2 = count_lines;

end

