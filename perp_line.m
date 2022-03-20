function [outputArg1 outputArg2]= perp_line(info,Nblines,line_half_length)
%PERP_LINE Draws the lines perpendicular to the GBs  Summary of this function goes here
%   Detailed explanation goes here
info1=info;

GB_pixels=info1('GB_pixels');
%length_GBs=info('GB_lengths');

if mean(contains(info1.keys,('perp_line_pixels')))~=0
    remove(info1,'perp_line_pixels');
    remove(info1,'perp_line_lengths');
end


for i=1:length(GB_pixels)
    GBno=i; %which GB is profiled

    %obtain the line of pixels that defines the GB
    GB_pix=GB_pixels{i};
    GB_pix=sortrows(GB_pix); %sort rows them in x
    startpix=GB_pix(1,:);
    endpix=GB_pix(end,:);
    

    Dx=endpix(1)-startpix(1);
    Dy=endpix(2)-startpix(2);
    perp_slope=-1/(Dy/Dx); %slope of perpendicular line (-1/m)
    
    N_lines=0;
    if Nblines>length(GB_pix)
        N_lines=length(GB_pix);
    else 
        N_lines=Nblines;
    end

    rand_pix=randperm(length(GB_pix),N_lines);
    
    for j=1:length(rand_pix)
        perp_pixels=[];

        mx=-1*Dy/sqrt(Dy^2+Dx^2);
        my=1*Dx/sqrt(Dy^2+Dx^2);

        perp_pixels(1,1)=round(GB_pix(rand_pix(j),1)+(mx)*line_half_length);
        perp_pixels(1,2)=round(GB_pix(rand_pix(j),2)+(my)*line_half_length);
        perp_pixels(2,1)=round(GB_pix(rand_pix(j),1)-(mx)*line_half_length);
        perp_pixels(2,2)=round(GB_pix(rand_pix(j),2)-(my)*line_half_length);
        
        %disp(perp_pixels)
        if ((perp_pixels(1,1)<1) || (perp_pixels(1,2)<1) || (perp_pixels(2,1)<1) || (perp_pixels(2,2)<1) || ...
                (perp_pixels(1,1)>512) || (perp_pixels(1,2)>512) || (perp_pixels(2,1)>512) || (perp_pixels(2,2)>512))
            continue
        end
        info1 = get_line(info1,perp_pixels,false,GBno);
        %perp_line_pixels=info1('perp_line_pixels');
        %length(perp_line_pixels)
    end
end

perp_lines=zeros(info1('x.pixels'));

perp_line_pixels=info1('perp_line_pixels');
count_lines=0;
for i=1:length(perp_line_pixels)
    pixels_shade=perp_line_pixels{i};
    count_lines=count_lines+1;
    for j=1:length(pixels_shade)
        pix=pixels_shade(j,:);
        perp_lines(pix(1),pix(2))=1;
    end
end

imshow(perp_lines)
set(gca,'YDir','normal');
labx=xlabel('x (pixels)');
labx.FontSize = 16;
laby=ylabel('y (pixels)');
laby.FontSize = 16;
axis square;
%title(sprintf('Perp lines for avpct= 0.950 and minpct= 1.012'))

outputArg1 = info1;
outputArg2 = count_lines;

end

