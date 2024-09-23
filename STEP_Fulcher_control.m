folder = '/home/kver/Downloads/STEP_BKool/';
X = SOLPS_ExtractParams_ForOpticalModel_balance([folder,'balance.nc'],[folder,'fort.44'],[folder,'fort.46'],[folder,'fort.33'],[folder,'fort.34']);
X = SOLPS_Balmer_Model(X,1,1,0,1,'3_2_3d');

%optimise LoS geometry
RD = 3.1926;
ZD = -4.9;
theta1 = -0.0448;
theta2 = -1.8;
LoS = 7;
theta = linspace(theta1,theta2,LoS);
%remove cone feature
Iprof = theta./theta;
A = theta.*0;

RD=[3.0,3,3,3.4,3.4,3.4,3.4,3.6,3.6,3.6,3.6,3.6];
ZD=[-4.7,-4.7,-4.7,-5.3,-5.3,-5.3,-5.3,-5.8,-5.8,-5.8,-5.8,-5.8];
theta=2*pi*([-15,-30,-45,-15,-28,-41,-54,-30,-50,-70,-90,-110]./(360)); 


%remove cone feature
Iprof = theta./theta;
A = theta.*0;

modified_fname = [folder,'STEP_v1_mod.mat'];

load(modified_fname,'DCD');
DCD.RD = RD.*(theta./theta);
DCD.ZD = ZD.*(theta./theta);
DCD.theta = theta;
DCD.Iprof = Iprof;
DCD.A = A;
DCD.PVD = theta;
save(modified_fname, 'DCD','-append')

%apply synthetic diagnostic
X = SOLPS_SynDiag_DSS_Balmer(X,nan,modified_fname);

figure
plot(X.DSS.Model_Hydro.IntegrParam.FulcherEmiss_au_L,'g','LineWidth',2)
hold on
plot(X.DSS.Model_Hydro.IntegrParam.Ion/3e4,'r','LineWidth',2)

%detect training edge D2 Fulcher
p = polyfit(linspace(1,12,12),X.DSS.Model_Hydro.IntegrParam.FulcherEmiss_au_L,3);
xv = linspace(1,12,100);
Front = interp1(polyval(p,xv),xv,0.5*max(polyval(p,xv)));
xline(Front,'b--','LineWidth',3)
xlabel('LoS')
ylabel('Intensity')
legend('D2 Fulcher emission (a.u.)','Ionisation (a.u.)','Detachment front detection')

figure
pcolor(X.params.cr,X.params.cz,X.ADAS.Hydro.Reaction.IonMap)
shading interp
caxis([0,5e23])
colormap('turbo')
L=1.3;
hold on
for i=1:12
plot(DCD.RD(i) - ([0, L]*cos(DCD.PVD(i))), DCD.ZD(i) + [0,L].*sin(DCD.PVD(i)),'k')
end
i=round(Front);
plot(DCD.RD(i) - ([0, L]*cos(DCD.PVD(i))), DCD.ZD(i) + [0,L].*sin(DCD.PVD(i)),'b','LineWidth',3)
title('2D ionisation map with Detachment Front')

Data=X;

save([folder,'STEP_Fulcher_control_Data.mat'],'Data','DCD')