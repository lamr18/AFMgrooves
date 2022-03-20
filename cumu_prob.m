function [outputArg1,outputArg2] = cumu_prob(C,info)
%CUMU_PROB Summary of this function goes here
%   Detailed explanation goes here

perp_line_pixels=info('perp_line_pixels');
perp_line_lengths=info('perp_line_lengths');
perp_whichGB=info('perp_whichGB');

%store the geometry and energy information from the 2 analyses
vartype={'double','double','double','double','double','double'};
varname={'width','depth','beta','dihedral_angle','gamma_ratio','lineno'};
symm_tab=table('Size',[length(perp_line_pixels) 6],'VariableTypes',vartype,'VariableNames', varname); 
nosymm_tab=table('Size',[length(perp_line_pixels)*2 6],'VariableTypes',vartype,'VariableNames', varname);

nosymmcount=1;
for i=1:length(perp_line_pixels)
    %obtain the line of pixels that defines the GB
    perp_line_pix=perp_line_pixels{i};
    perp_line_len=perp_line_lengths{i};
    perp_GBno=perp_whichGB{i};
    geom_en=profile_plot(C,perp_line_pix,perp_line_len,perp_GBno);

    nosymm_tab(nosymmcount,:)=num2cell(geom_en(1,:));
    nosymm_tab(nosymmcount+1,:)=num2cell(geom_en(2,:));
    nosymmcount=nosymmcount+2;
    symm_tab(i,:)=num2cell(geom_en(3,:));
end

colorlines=[nosymm_tab.gamma_ratio nosymm_tab.lineno];
colorlines=sortrows(colorlines);
colorlines=colorlines(:,2);
colorlines(end+1)=colorlines(end);

diha=symm_tab.dihedral_angle;
gar=symm_tab.gamma_ratio;
[cumul_pb_symm, diha]=ecdf(gar);
figure(1)
scatter(diha, cumul_pb_symm)
labx=xlabel('\gamma_{GB} / \gamma_S');
labx.FontSize = 16;
laby=ylabel('Cumulative probability');
laby.FontSize = 16;
axis square;
title(sprintf('Distribution of thermal groove energy for symmetric profiles'))
set(gca,'fontsize',15);

diha=nosymm_tab.dihedral_angle;
gar=nosymm_tab.gamma_ratio;
[cumul_pb_nosymm, diha]=ecdf(gar);
disp(cumul_pb_nosymm(end))
disp(diha(end))
figure(2)
scatter(diha, cumul_pb_nosymm,50,colorlines,'filled')
labx=xlabel('\gamma_{GB} / \gamma_S');
labx.FontSize = 16;
laby=ylabel('Cumulative probability');
laby.FontSize = 16;
axis square;
title(sprintf('Distribution of thermal groove energy for non symmetric profiles'))
set(gca,'fontsize',15);

outputArg1 = symm_tab;
outputArg2 = nosymm_tab;
end

