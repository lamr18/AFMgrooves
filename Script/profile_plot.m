function outputArg1=profile_plot(C,perp_line_pix,perp_line_len,lineno)
%PROFILE_PLOT Plot line profile across a perp line item, and compute the
%geometry of the groove

% Obtain the Z data at each pixel of the perp line
zData=[];
for i=1:length(perp_line_pix)
    zData(i)=C(perp_line_pix(i,1),perp_line_pix(i,2));
end

% These two lines print out the line profile in z of the perpendicular line input
%plot(perp_line_len,zData)
%title(sprintf('perplinepixels %d %d %d %d', perp_line_pix(1,1),perp_line_pix(1,2),perp_line_pix(end,1),perp_line_pix(end,2)))

geom_en=[0 0 0 0 0 0];
%Find the global minimum in z along the profile
i_min=find(zData==min(zData));
perp_line_len_min=perp_line_len(i_min(end));

% Separate the profile into 2 parts, the left side of the min and the right
% side of the min, to do an asymmetric groove analysis

% Left profile
l_prof=zData(1:i_min);
l_Imax=find(l_prof==max(l_prof)); %x value of the max z value in the profile

%Geometry calculations, as explained in the README
d_l=abs(l_prof(l_Imax(end))-l_prof(end)); %depth of left profile
w_l=abs(perp_line_len(l_Imax(end))-perp_line_len_min); %half width of left profile
beta_l=atand(4.6*d_l/(0.974*2*w_l)); %geom angle beta from Robertson
halfdi_l=90-beta_l;  %geom angle half of psi (dihedral angle)
en_ratio_l=2*cosd(halfdi_l); %energy ratio
geom_en(1,:)=[(2*w_l) d_l beta_l (2*halfdi_l) en_ratio_l lineno]; %combine all the info

%Right profile, repeat the same analysis
r_prof=zData(i_min:end);
r_Imax=find(r_prof==max(r_prof)); %x value of the max z value in the profile

d_r=abs(r_prof(r_Imax(1))-r_prof(1)); %depth of right profile
w_r=abs(perp_line_len(r_Imax(1)+i_min(1)-1)-perp_line_len_min); %half width of right profile
beta_r=atand(4.6*d_r/(0.974*2*w_r)); %geom angle beta from Robertson
halfdi_r=90-beta_r;  %geom angle half of psi (dihedral angle)
en_ratio_r=2*cosd(halfdi_r); %energy ratio
geom_en(2,:)=[(2*w_r) d_r beta_r (2*halfdi_r) en_ratio_r lineno]; %combine all the info

%Symmetric groove, only taking one measurement across the groove
lr_max=(l_prof(l_Imax(end))+r_prof(r_Imax(1)))/2;
d_lr=abs(lr_max-min(zData));
w_lr=abs(perp_line_len(l_Imax(end))-perp_line_len(r_Imax(1)+i_min(1)-1))/2; %half width of full profile
beta_lr=atand(4.6*d_lr/(0.974*2*w_lr)); %geom angle beta from Robertson
halfdi_lr=90-beta_lr;  %geom angle half of psi (dihedral angle)
en_ratio_lr=2*cosd(halfdi_lr); %energy ratio
geom_en(3,:)=[2*w_lr d_lr beta_lr (2*halfdi_lr) en_ratio_lr lineno]; %combine all the info

outputArg1=geom_en;
end

