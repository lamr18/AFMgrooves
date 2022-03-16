function [outputArg1,outputArg2,outputArg3] = GB_detection(info,C,gridsize,aspect_ratio)
%GB_Detection This function detects grain boundaries and saves their
%locations
%   Detailed explanation goes here
%Need to choose appropriate grid size for the grain microstructure
tot=0;
segmentsthrough=[];
av=median(C,"all");
s=linspace(1,info('x.pixels'),gridsize);
gb_detection=zeros(length(C));
for k=1:(length(s)-1)
    for l=1:(length(s)-1)
        tot=tot+1;%total number of segments
        %figure(tot);
        segment=C(s(l):s(l+1),s(k):s(k+1));
        %imagesc(segment);
        %colormap(gray);
        %c=colorbar;
        %set(gca,'YDir','normal');
       
        %seg_median=median(segment,'all')% compute average of the segment
        seg_min=min(segment,[],'all'); % compute min of the segment
        if seg_min<(av*0.92) %discard segment if its average is above the total median
            Mask=segment<(seg_min*1.02);
            if aspect_ratio==true
                pass=seg_aspect_ratio(Mask);
            else
                pass=true;
            end
            if pass==true % for segments that pass the checks:
                segmentsthrough(end+1)=tot;
                gb_detection(s(l):s(l+1),s(k):s(k+1))= Mask;
            end
        end
    end
end
imshow(gb_detection)
set(gca,'YDir','normal');

outputArg1 = gb_detection;
outputArg2 = tot;
outputArg3 = segmentsthrough;
end

