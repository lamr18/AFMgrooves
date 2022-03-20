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

%Plot symmetric profile information(normal format)
diha=symm_tab.dihedral_angle;
gar=symm_tab.gamma_ratio;
[cumul_pb_symm, cumu_diha]=ecdf(diha);
figure(1)
scatter(cumu_diha, cumul_pb_symm)
%labx=xlabel('\gamma_{GB} / \gamma_S');
labx=xlabel('Dihedral angle (°)');
labx.FontSize = 16;
laby=ylabel('Cumulative probability');
laby.FontSize = 16;
axis square;
axis([0 180 0 1]);
%title(sprintf('Distribution of thermal groove energy for symmetric profiles'))
%title({sprintf('Distribution of thermal groove energy for symmetric profiles'),sprintf('for %d segments and %d profiles',max(colorlines),length(perp_line_pixels))})
set(gca,'fontsize',15);
box on

%Plot non symmetric profile information (normal format)
diha=nosymm_tab.dihedral_angle;
gar=nosymm_tab.gamma_ratio;
%[cumul_pb_nosymm, cumu_gar]=ecdf(gar);
[cumul_pb_nosymm, cumu_diha]=ecdf(diha);
figure(3)
scatter(cumu_diha,cumul_pb_nosymm)
%scatter(cumu_diha, cumul_pb_nosymm,50,colorlines,'filled')
%labx=xlabel('\gamma_{GB} / \gamma_S');
labx=xlabel('Dihedral angle (°)');
%labx.FontSize = 16;
laby=ylabel('Cumulative probability');
laby.FontSize = 16;
axis square;
axis([0 180 0 1]);
%title({sprintf('Distribution of thermal groove energy for non symmetric profiles'),sprintf('for %d segments and %d profiles',max(colorlines),length(perp_line_pixels)*2)})
set(gca,'fontsize',15);
%ax1=gca;
box on
%ax2=axes('Position',ax1.Position,'XAxisLocation','top','XDir','reverse','YAxisLocation','right','color','none');
%hold(ax2,'on')
%axis square;
%set(ax2,'fontsize',15);
%ax2.YAxis.Visible = 'off';
%labx.FontSize = 16;
%cumu_gar=2*cosd(cumu_diha/2);
%scatter(ax2,cumu_gar,cumul_pb_nosymm)
%hold(ax2,'off')

%Plot non symmetric profile information with different GB colors
diha=nosymm_tab.dihedral_angle;
gar=nosymm_tab.gamma_ratio;
%[cumul_pb_nosymm, cumu_gar]=ecdf(gar);
[cumul_pb_nosymm, cumu_diha]=ecdf(diha);
figure(2)
%scatter(cumu_diha,cumul_pb_nosymm)
scatter(cumu_diha, cumul_pb_nosymm,50,colorlines,'filled')
%labx=xlabel('\gamma_{GB} / \gamma_S');
labx=xlabel('Dihedral angle (°)');
labx.FontSize = 16;
laby=ylabel('Cumulative probability');
laby.FontSize = 16;
axis square;
axis([0 180 0 1]);
%title({sprintf('Distribution of thermal groove energy for non symmetric profiles'),sprintf('for %d segments and %d profiles',max(colorlines),length(perp_line_pixels)*2)})
set(gca,'fontsize',15);
box on

%Average value plot for non symmetric profiles
avnosymm_tab=table('Size',[max(colorlines) 6],'VariableTypes',vartype,'VariableNames', varname);

for i=1:max(colorlines)
    %disp(i)
    d_mean=0;
    w_mean=0;
    beta_mean=0;
    diha_mean=0;
    gar_mean=0;
    count=0;
    for j=1:height(nosymm_tab)
        %disp(j)
        if nosymm_tab.lineno(j)==i
            %disp(nosymm_tab.lineno(j))
            w_mean=w_mean+nosymm_tab.width(j);
            d_mean=d_mean+nosymm_tab.depth(j);
            beta_mean=beta_mean+nosymm_tab.beta(j);
            diha_mean=diha_mean+nosymm_tab.dihedral_angle(j);
            gar_mean=gar_mean+nosymm_tab.gamma_ratio(j);
            count=count+1;
        end
    end
    avnosymm_tab(i,:)=num2cell([w_mean/count d_mean/count beta_mean/count diha_mean/count gar_mean/count i]);
end
colorsav=1:max(avnosymm_tab.lineno)-1;

diha=avnosymm_tab.dihedral_angle;
[cumul_pb_avnosymm, cumu_diha]=ecdf(diha);
figure(4)
scatter(cumu_diha, cumul_pb_avnosymm,50,colorsav,'filled')
%labx=xlabel('\gamma_{GB} / \gamma_S');
labx=xlabel('Dihedral angle (°)');
labx.FontSize = 16;
laby=ylabel('Cumulative probability');
laby.FontSize = 16;
axis square;
axis([0 180 0 1]);
%title({sprintf('Distribution of thermal groove energy for non symmetric profiles'),sprintf('for %d segments averaged over %d segments',length(perp_line_pixels)*2,max(colorsav))})
set(gca,'fontsize',15);
box on

outputArg1 = symm_tab;
outputArg2 = nosymm_tab;
end

