function [outputArg1]=plot_image(frame,imageNo,pixel)
%PLOT_IMAGE Plots the input image 
% Creates an array of the image values and plots it with either pixel or nm
% axes

%Create array of the z_nm values of size(pixels.x, pixels.y)
C=zeros(max(frame.x));
for i = 1:(length(frame.z_nm))
    C(frame.x(i),frame.y(i))=frame.z_nm(i);
end

if pixel==true
    imagesc(C/1e3)
    colormap(gray);
    c=colorbar;
    c.Title.String = 'z (µm)';
    c.FontSize=16;
    set(gca,'YDir','normal');
    labx=xlabel('x (pixels)');
    labx.FontSize = 16;
    laby=ylabel('y (pixels)');
    laby.FontSize = 16;
    set(gca,'fontsize',14);
    axis square;
    %title(sprintf('AFM map of image %d',imageNo))
else
    x=linspace(min(frame.x_nm),max(frame.x_nm),max(frame.x))/1e3;
    y=linspace(min(frame.y_nm),max(frame.y_nm),max(frame.y))/1e3;
    [X,Y]=meshgrid(x,y); %create mesh in µm
    %2D map
    figure(1)
    pcolor(X,Y,C/1e3)
    shading flat;
    colormap(gray);
    c=colorbar;
    c.Title.String = 'z (µm)';
    c.FontSize=16;
    axis square;
    labx=xlabel('x (µm)');
    labx.FontSize = 16;
    laby=ylabel('y (µm)');
    laby.FontSize = 16;
    set(gca,'fontsize',14);
    box off;
    %title(sprintf('AFM map of image %d',imageNo))

    %3D map
    figure(2)
    surf(X,Y,C/1e3)
    shading flat;
    colormap(gray);
    c=colorbar;
    c.Title.String = 'z (µm)';
    c.FontSize=16;
    labx=xlabel('x (µm)');
    labx.FontSize = 16;
    laby=ylabel('y (µm)');
    laby.FontSize = 16;
    set(gca,'fontsize',14);
    axis square;
    box on;
    %title(sprintf('AFM map of image %d',imageNo))
end
outputArg1=C;
end

