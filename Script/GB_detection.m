function [gb_detection,info,segmentsthrough] = GB_detection(info,C,gridsize,aspect_ratio,avpct,minpct)
%GB_DETECTION Detects grain boundaries in the AFM image.
% Please read more about choosing threshold parameters in the README file.

tot=0; %counter for the total number of segments gridded by the image
segmentsthrough=[]; %list containing the IDs (grid number) of the segments in which features were detected
av=median(C,"all"); %median z value of the matrix

%Create grid on the image to break it down into smaller sub-images (referred 
% to as 'segments') that are analyzed one by one.
sz=floor(info('x.pixels')/gridsize);
s=linspace(0,sz*(gridsize-1),gridsize)+1;
s(end+1)=info('x.pixels');

%Create a matrix of zeros, of the size of the image. This matrix will be 
% modified with '1' values in locations where elements are detected.
gb_detection=zeros(length(C));
list_GBs={[0]};

for k=1:(length(s)-1)
    for l=1:(length(s)-1)
        tot=tot+1; %total number of segments
        segment=C(s(l):(s(l+1)),s(k):(s(k+1))); %cut the image into a grid segment
       
       
        seg_min=min(segment,[],'all'); % compute min z value of the segment
        if seg_min<(av*avpct) %discard segment if its average is above the total median
            %Apply a mask to the segment, which returns a matrix of '0', with '1' values
            %where the z value in the segment is below the mask parameter.
            %This mask parameter is a value that is a chosen percentage of the segment minimum.
            %This means the mask highlights all of the values that are within a certain 
            %threshold of the minimum value of the segment. This makes sense for GBs as 
            %the GB is straight and should have a relatively stable value along the bottom of the groove.
            
            Mask_s=segment<(seg_min*minpct);
           
            % Create a frame on the corner segments of the image, as these
            % segments will be hard to profile across. The corner segments
            % correspond to the 4 tot values below.
            if tot==1
                Mask_s(1:20,:)=1;
                Mask_s(:,1:20)=1;
            elseif tot==(gridsize)
                Mask_s((end-20):end,:)=1;
                Mask_s(:,1:20)=1;
            elseif tot==(((gridsize)^2)-gridsize+1)
                Mask_s(1:20,:)=1;
                Mask_s(:,(end-20):end)=1;
            elseif tot==(gridsize)^2
                Mask_s((end-20):end,:)=1;
                Mask_s(:,(end-20):end)=1;
            end
            
            % If the mask is a matrix of zeros, segment can be skipped
            if mean(Mask_s,'all')==0
                continue
            end
            
            % Append the segment to the list of segments that had detected features
            segmentsthrough(end+1)=tot; 
            
            %Call the aspect ratio function to obtain edgepixels and
            %determine shape. If aspect_ratio is 'false', then the shape
            %will be discarded in the detection.
            if aspect_ratio==true
                [pass pixels]=seg_aspect_ratio(Mask_s);
                if pass==false
                    pixels=[0 0; 0 0];
                end
            else
                [pass pixels]=seg_aspect_ratio(Mask_s);
                pass=true;
            end
            
            %Segments that pass the checks are added to the gb_detection
            %matrix and the edgepixels are saved
            if (mean(pixels,'all')~=0 && pass~=false)==true
                pixels(:,1)=pixels(:,1)+s(l);
                pixels(:,2)=pixels(:,2)+s(k);
               
                gb_detection(s(l):(s(l+1)),s(k):(s(k+1)))= Mask_s;
                list_GBs(end+1)={pixels};
            end
        end
    end
end

%Append the edgepixels to the info packet. 
list_GBs=list_GBs(2:end);%remove first item as it's a placeholder
if mean(contains(info.keys,('list_GBs')))~=0
    remove(info,'list_GBs');
end
info('list_GBs')=list_GBs;

% This section allows to print only the GB_detection drawn by this function, 
% rather than a combined plot from 'combined_plot.m'. Unhash to plot.
%imshow(gb_detection)
%set(gca,'YDir','normal');
%labx=xlabel('x (pixels)');
%labx.FontSize = 16;
%laby=ylabel('y (pixels)');
%laby.FontSize = 16;
%axis square;
%title(sprintf('GB detection for avpct= %.3f and minpct= %.3f',avpct,minpct))
%set(gca,'fontsize',15);

end

