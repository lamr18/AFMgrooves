function [outputArg1,outputArg2,outputArg3] = GB_detection(info,C,gridsize)
%GB_Detection This function detects grain boundaries and saves their
%locations
%   Detailed explanation goes here
%Need to choose appropriate grid size for the grain microstructure
tot=0;
segmentsthrough=[];
av=median(C,"all");
s=linspace(1,info('x.pixels'),gridsize);
for k=1:(length(s)-1)
    for l=1:(length(s)-1)
        tot=tot+1;%total number of segments
        figure(tot);
        segment=C(s(l):s(l+1),s(k):s(k+1));
        imagesc(segment);
        colormap(gray);
        c=colorbar;
        set(gca,'YDir','normal');
       
        %seg_median=median(segment,'all')% compute average of the segment
        seg_min=min(segment,[],'all') % compute min of the segment


        if seg_min<(av*0.85) %discard segment if its average is above the total median
            %mask=zeros(size(segment));
            Mask=segment<(seg_min*1.02);
            segmentsthrough(end+1)=tot;

        end
    end
end

outputArg1 = Mask;
outputArg2 = segment;
outputArg3=segmentsthrough;
end

