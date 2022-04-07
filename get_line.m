function [outputArg1] = get_line(info,pixels,GB,GBno)
%GET_LINE This function computes a straight line between two pixels using
%the Bresenham line algorithm. It is a simple algorithm based on integer
%arithmetics.

%The function is called to draw the GB lines and the perpendicular profile
%lines. Depending on which it is called from, the lines are appended to
%differenf info packets.
if GB==true
    key_label1='GB_pixels';
    key_label2='GB_lengths';
elseif GB==false 
    key_label1='perp_line_pixels';
    key_label2='perp_line_lengths';
end

%Check that all pixels are within image range
width_x=info('x.pixels');
Mask=pixels>(width_x);
if mean(Mask)~=0
    error('one or more pixels out of image range')
end

%Get the first and last pixels of the line
startpixel=pixels(1,:);
endpixel=pixels(2,:);
pix=startpixel;

if startpixel(1)==endpixel(1) % if the line is flat, the line Bresenham algorithm is circuited by a simpler form
    if endpixel(2)<startpixel(2) %rearrange such that the line is drawn from left to right
        endpixel=pixels(1,:);
        startpixel=pixels(2,:);
    end
    
    %Draw a straight line between the points
    r1=startpixel;
    q2=0;
    r2=[q2];

    for i=(startpixel(2)+1):endpixel(2)
        q2=q2+info('x.conv');
        r2(end+1,:)=q2;
        r1(end+1,:)=[endpixel(1),i];
    end
    
    %If the line is less than 15 pixels in length, it should be skipped as
    %it is not long enough to be relevant.
    if length(r2)<15
        outputArg1=info;
        return
    end
    
    %Add the line pixels and line lengths information to the relevant info packet
    if mean(contains(info.keys,(key_label1)))==0
        info(key_label1)={r1};
        info(key_label2)={r2};
    else
        %add line pixels
        line_pixels=info(key_label1);
        line_pixels{end+1}=r1;
        info(key_label1)=line_pixels;

        %add line lengths
        line_lengths=info(key_label2);
        line_lengths{end+1}=r2;
        info(key_label2)=line_lengths;
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

% If the line is less than 15 pixels in length, it should be skipped as
% it is not long enough to be relevant.
if length(r2)<15
    outputArg1 = info;
    return
end

%Add the line pixels and line lengths information to the relevant info packet
if mean(contains(info.keys,(key_label1)))==0
    info(key_label1)={r1};
    info(key_label2)={r2};
else
    %add line pixels
    line_pixels=info(key_label1);
    line_pixels{end+1}=r1;
    info(key_label1)=line_pixels;

    %add line lengths
    line_lengths=info(key_label2);
    line_lengths{end+1}=r2;
    info(key_label2)=line_lengths;

end

%For the perpendicular line profiles, we also want to know which grain
%boundary the line profile is taken across, so this is added in the info
%packet.
if GB==false
    if mean(contains(info.keys,('perp_whichGB')))==0
        info('perp_whichGB')={GBno};
    else
        %add line pixels
        perp_whichGB=info('perp_whichGB');
        perp_whichGB{end+1}=GBno;
        info('perp_whichGB')=perp_whichGB;
    end
end

outputArg1 = info;

end

