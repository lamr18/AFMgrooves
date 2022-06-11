RL=(5*10^3)/512;
tab=nosymm_tab2017;
delpsi=[];
diha_adjusted=[];

for i=1:length(tab.dihedral_angle)
    W=tab.width(i);
    beta=tab.beta(i);
    psi=tab.dihedral_angle(i);
    del=1.152*(beta*100*(sind(psi/2))*RL/W)^(1/2);
    diha=psi-del;
    delpsi=[delpsi; del];
    diha_adjusted=[diha_adjusted; diha];

end
nosymm_tab2017 = addvars(nosymm_tab2017,delpsi,diha_adjusted)