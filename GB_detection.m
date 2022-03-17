function [outputArg1,outputArg2,outputArg3] = GB_detection(info,C,gridsize,aspect_ratio,avpct,minpct)
%GB_Detection This function detects grain boundaries and saves their
%locations
%   Detailed explanation goes here
%Need to choose appropriate grid size for the grain microstructure
tot=0;
segmentsthrough=[];
av=median(C,"all");
s=linspace(1,info('x.pixels'),gridsize);
gb_detection=zeros(length(C));
list_GBs={[0]};

for k=1:(length(s)-1)
    for l=1:(length(s)-1)
        tot=tot+1;%total number of segments
        %figure(tot);
        segment=C(s(l):(s(l+1)-1),s(k):(s(k+1)-1));
        %imagesc(segment);
        %colormap(gray);
        %c=colorbar;
        %set(gca,'YDir','normal');
       
        %seg_median=median(segment,'all')% compute average of the segment
        seg_min=min(segment,[],'all'); % compute min of the segment
        if seg_min<(av*avpct) %discard segment if its average is above the total median
            Mask=segment<(seg_min*minpct);
            
            %frame
            if tot==1
                Mask(1:15,:)=0;
                Mask(:,1:15)=0;

            elseif tot==(gridsize-1)
                Mask((end-15):end,:)=0;
                Mask(:,1:15)=0;

            elseif tot==((gridsize-1)^2-gridsize)
                Mask(1:15,:)=0;
                Mask(:,(end-15):end)=0;

            elseif tot==(gridsize-1)^2
                Mask((end-15):end,:)=0;
                Mask(:,(end-15):end)=0;

            end

            if mean(Mask,'all')==0
                continue
            end

            if aspect_ratio==true
                [pass pixels]=seg_aspect_ratio(Mask);
                if pass==false
                    pixels=[0 0; 0 0];
                end
            else
                [pass pixels]=seg_aspect_ratio(Mask);
                pass=true;
            end
            
            if (mean(pixels,'all')~=0 && pass~=false)==true % for segments that pass the checks
                pixels(:,1)=pixels(:,1)+s(l);
                pixels(:,2)=pixels(:,2)+s(k);
                segmentsthrough(end+1)=tot;
                gb_detection(s(l):(s(l+1)-1),s(k):(s(k+1)-1))= Mask;
                list_GBs(end+1)={pixels};
            end
        end
    end
end

list_GBs=list_GBs(2:end);
info('list_GBs')=list_GBs;

%clear the edges with a frame of '0'
gb_detection(1:15,:)=0;
gb_detection((end-15):end,:)=0;
gb_detection(:,1:15)=0;
gb_detection(:,(end-15):end)=0;

imshow(gb_detection)
set(gca,'YDir','normal');
labx=xlabel('x (pixels)');
labx.FontSize = 16;
laby=ylabel('y (pixels)');
laby.FontSize = 16;
axis square;
title(sprintf('GB detection for avpct= %.3f and minpct= %.3f',avpct,minpct))
set(gca,'fontsize',15);

outputArg1 = gb_detection;
outputArg2 = info;
outputArg3 = segmentsthrough;
end

