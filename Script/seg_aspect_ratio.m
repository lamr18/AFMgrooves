function [outputArg1, outputArg2] = seg_aspect_ratio(mask)
%SEG_ASPECT_RATIO Corrects GB_detection by removing detected regions that
%do not have an elongated shape. This is a sensitive function and should
%be used after thoroughly evaluating its impact on the input data. Its
%efficiency varies greatly on the input data, gridsize and other threshold
%parameters.

sz=size(mask);
for i=1:(sz(2)) %leftmost pixel with '1' value (detected GB)
    for j=1:(sz(1))
        if mask(j,i)==1
            coordsleft=[j,i];
            break
        end
    end
end
   
for i=1:(sz(2))
    for j=1:(sz(1)) %rightmost pixel with '1' value (detected GB)
        if mask(j,(sz(2)+1-i))==1
            coordsright=[j,(sz(2)+1-i)];
            break
        end
    end
end

pixels=[coordsleft;coordsright];

%Draw out a rectangle from the coordinates of leftmost and rightmost highlighted 
% ('1') pixels
minvaluex=min(coordsleft(1),coordsright(1));
maxvaluex=max(coordsleft(1),coordsright(1));
minvaluey=min(coordsleft(2),coordsright(2));
maxvaluey=max(coordsleft(2),coordsright(2));

density=mean(mask(minvaluex:maxvaluex,minvaluey:maxvaluey),'all');

% The so-called density of highlighted pixels in the drawn rectangle is
% evaluated by taking the mean value of the rectangle. If it is within
% threshold parameters, it is in the allowed shape. The chosen threshold parameters 
% seem to work best, and beware as adjustments can have drastic impact on
% detection.

if (density>0.001 && density<0.5) 
    pass = true;
else
    pass = false;
end

outputArg1 = pass;
outputArg2 = pixels;

end

