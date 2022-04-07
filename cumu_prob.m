function [outputArg1,outputArg2] = cumu_prob(C,info)
%CUMU_PROB Extract the grain boundary profile geometry and calculate the cumulative
%probability distribution. One symmetric table and one asymetric table are
%created and output. 4 plots with titles are generated.

% Collect information for the info packets
perp_line_pixels=info('perp_line_pixels');
perp_line_lengths=info('perp_line_lengths');
perp_whichGB=info('perp_whichGB');

%Store the geometry and energy information from the 2 analyses in 2 tables
%with the same format
vartype={'double','double','double','double','double','double'};
varname={'width','depth','beta','dihedral_angle','gamma_ratio','lineno'};
symm_tab=table('Size',[length(perp_line_pixels) 6],'VariableTypes',vartype,'VariableNames', varname); 
nosymm_tab=table('Size',[length(perp_line_pixels)*2 6],'VariableTypes',vartype,'VariableNames', varname);

nosymmcount=1;
for i=1:length(perp_line_pixels) % circle through the perpendicular profile lines
    %obtain the line of pixels that defines the GB
    perp_line_pix=perp_line_pixels{i};
    perp_line_len=perp_line_lengths{i};
    perp_GBno=perp_whichGB{i}; % which GB number
    geom_en=profile_plot(C,perp_line_pix,perp_line_len,perp_GBno); %compute profile geometry 
    
    %add the geometric information to the correct table
    nosymm_tab(nosymmcount,:)=num2cell(geom_en(1,:));
    nosymm_tab(nosymmcount+1,:)=num2cell(geom_en(2,:));
    nosymmcount=nosymmcount+2;
    symm_tab(i,:)=num2cell(geom_en(3,:));
end

%Plot symmetric profile information (normal format)
figure(4)
diha=symm_tab.dihedral_angle;
[cumul_pb_symm, cumu_diha]=ecdf(diha);
scatter(cumu_diha, cumul_pb_symm)
xlabel('Dihedral angle (°)');
ylabel('Cumulative probability');
axis square;
%axis([80 180 0 1]);
title(sprintf('Distribution of thermal groove energy for %d symmetric profiles',length(perp_line_pixels)))
set(gca,'fontsize',15);
box on

%Plot non symmetric profile information (normal format)
figure(5)
diha=nosymm_tab.dihedral_angle;
[cumul_pb_nosymm, cumu_diha]=ecdf(diha);
scatter(cumu_diha,cumul_pb_nosymm)
xlabel('Dihedral angle (°)');
ylabel('Cumulative probability');
axis square;
%axis([80 180 0 1]);
title({sprintf('Distribution of thermal groove energy for %d non symmetric profiles',length(perp_line_pixels)*2)})
set(gca,'fontsize',15);
box on

%Attach a color to a GBno
colorlines=[nosymm_tab.dihedral_angle nosymm_tab.lineno];
colorlines=sortrows(colorlines);
colorlines=unique(colorlines,'rows');
firstline=[nosymm_tab.dihedral_angle(1) nosymm_tab.lineno(1)];
colorlines=[firstline;colorlines]
colorlines=colorlines(:,2);
size(colorlines)

%Plot non symmetric profile information with data point colors
%corresponding to GBno
figure(6)
diha=nosymm_tab.dihedral_angle;
[cumul_pb_nosymm, cumu_diha]=ecdf(diha);
size(cumu_diha)
scatter(cumu_diha, cumul_pb_nosymm,50,colorlines,'filled')
xlabel('Dihedral angle (°)');
ylabel('Cumulative probability');
axis square;
%axis([80 180 0 1]);
title({sprintf('Distribution of thermal groove energy for non symmetric profiles'),sprintf('for %d segments and %d profiles',max(colorlines),length(perp_line_pixels)*2)})
set(gca,'fontsize',15);
box on

%Average value plot for non symmetric profiles
avnosymm_tab=table('Size',[max(colorlines) 6],'VariableTypes',vartype,'VariableNames', varname);

counter={0};
for i=1:max(colorlines) %Compute the mean value of all the asymmetric profiles taken across a single GB line
    d_mean=0;
    w_mean=0;
    beta_mean=0;
    diha_mean=0;
    gar_mean=0;
    count=0;
    for j=1:height(nosymm_tab)
        if nosymm_tab.lineno(j)==i
            w_mean=w_mean+nosymm_tab.width(j);
            d_mean=d_mean+nosymm_tab.depth(j);
            beta_mean=beta_mean+nosymm_tab.beta(j);
            diha_mean=diha_mean+nosymm_tab.dihedral_angle(j);
            gar_mean=gar_mean+nosymm_tab.gamma_ratio(j);
            count=count+1;
        end
    end
    if count~=0
        counter{end+1}=count;
    end
    avnosymm_tab(i,:)=num2cell([w_mean/count d_mean/count beta_mean/count diha_mean/count gar_mean/count i]);
end
%Attach a color to a GBno
avnosymm_tab=rmmissing(avnosymm_tab);
colorsav=avnosymm_tab.lineno;
colorsav(end+1)=colorsav(end)+1;
counter(1)=counter(2);

figure(7)
diha=avnosymm_tab.dihedral_angle;
[cumul_pb_avnosymm, cumu_diha]=ecdf(diha);
scatter(cumu_diha, cumul_pb_avnosymm,50,colorsav,'filled')
for i=1:length(cumu_diha)
    text((cumu_diha(i)+0.015),(cumul_pb_avnosymm(i)+0.015),string(counter(i))); % label the datapoints
end
xlabel('Dihedral angle (°)');
ylabel('Cumulative probability');
axis square;
%axis([80 180 0 1]);
title({sprintf('Distribution of thermal groove energy for non symmetric profiles'),sprintf('for %d segments averaged over %d segments',length(perp_line_pixels)*2,max(colorsav))})
set(gca,'fontsize',15);
box on

outputArg1 = symm_tab;
outputArg2 = nosymm_tab;
end

