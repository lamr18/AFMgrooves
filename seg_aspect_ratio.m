function [outputArg1, outputArg2] = seg_aspect_ratio(mask)
%SEG_ASPECT_RATIO Summary of this function goes here
%   Detailed explanation goes here
for i=1:(length(mask))
    for j=1:(length(mask))
        if mask(j,i)==1
            coordsleft=[j,i];
            break
        end
    end
end
   
for i=1:length(mask)
    for j=1:length(mask)
        if mask(j,(length(mask)+1-i))==1
            coordsright=[j,(length(mask)+1-i)];
            break
        end
    end
end

pixels=[coordsleft;coordsright];

minvaluex=min(coordsleft(1),coordsright(1));
maxvaluex=max(coordsleft(1),coordsright(1));
minvaluey=min(coordsleft(2),coordsright(2));
maxvaluey=max(coordsleft(2),coordsright(2));

density=mean(mask(minvaluex:maxvaluex,minvaluey:maxvaluey),'all');    
if (0.01<density && density<0.65)==1
    pass = true;
else
    pass = false;
    %pixels=[0 0; 0 0];
end

if coordsleft(1)==coordsright(1)
    pass=true;
elseif coordsleft(2)==coordsright(2)
    pass=true;
end

outputArg1 = pass;
outputArg2 = pixels;

end

