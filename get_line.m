function [outputArg1] = get_line(info,pixels)
%GET_LINE Summary of this function goes here
%   Detailed explanation goes here
width.x=info('x.pixels');
width.y=info('y.pixels');

Mask=pixels>(width.x);
if mean(Mask)~=0
    error('one or more pixels out of image range')
end

%x1.pixel=startpixel(1);
%y1.pixel=startpixel(2);

startpixel=pixels(1,:);
endpixel=pixels(2,:);
pix=startpixel;

if startpixel(1)==endpixel(1)
    if endpixel(2)<startpixel(2)
        endpixel=pixels(1,:);
        startpixel=pixels(2,:);
    end
    
    r1=startpixel;
    q2=0;
    r2=[q2];

    for i=(startpixel(2)+1):endpixel(2)
        q2=q2+info('x.conv');
        r2(end+1,:)=q2;
        r1(end+1,:)=[endpixel(1),i];
    end
    
    if length(r2)<10
        outputArg1=info;
        return
    end

    if mean(contains(info.keys,('line_pixels')))==0
        info('line_pixels')={r1};
        info('line_lengths')={r2};
    else
        %add line pixels
        line_pixels=info('line_pixels');
        line_pixels{end+1}=r1;
        info('line_pixels')=line_pixels;

        %add line lengths
        line_lengths=info('line_lengths');
        line_lengths{end+1}=r2;
        info('line_lengths')=line_lengths;
    end
    outputArg1=info;
    return
end

%Bresenham line algorithm
Dx=abs(endpixel(1)-startpixel(1));
Sx=sign(endpixel(1)-startpixel(1));
Dy=-abs(endpixel(2)-startpixel(2));
Sy=sign(endpixel(2)-startpixel(2));
er=Dx+Dy;

%set up length measurement
r1=startpixel;
q2=0;
r2=[q2];

while (pix(1)~=endpixel(1) || pix(2)~=endpixel(2))
%while pix(2)~=endpixel(2) %stops when you reach endpixel
    %disp(pix)
    %disp(endpixel)
    er2=2*er;
    lx=0;
    ly=0;
    if er2>=Dy
        er=er+Dy;
        pix(1)=pix(1)+Sx;
        lx=info('x.conv');
    end

    if er2<=Dx
        er=er+Dx;
        pix(2)=pix(2)+Sy;
        ly=info('y.conv');
    end

    r1(end+1,:)=pix;
    q2=q2+sqrt(lx^2+ly^2);
    r2(end+1,:)= q2;
end

if length(r2)<10
    outputArg1 = info;
    return
end

if mean(contains(info.keys,('line_pixels')))==0
    info('line_pixels')={r1};
    info('line_lengths')={r2};
else
    %add line pixels
    line_pixels=info('line_pixels');
    line_pixels{end+1}=r1;
    info('line_pixels')=line_pixels;

    %add line lengths
    line_lengths=info('line_lengths');
    line_lengths{end+1}=r2;
    info('line_lengths')=line_lengths;

end

outputArg1 = info;

end

