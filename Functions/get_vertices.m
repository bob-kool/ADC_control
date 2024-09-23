function [rrout,zzout] = get_vertices(centreR,centreZ,dR,dZ,a1,a2)

% converted from python script, original by Lucy Kogan, CCFE

%     Work out the vertices of the rectangle / parallelogram
%     :param centreR: R centre of the parallelogram
%     :param centreZ: Z centre of the parallelogram
%     :param dR: "width" of the parallelogram
%     :param dZ: "height" of the parallelogram
%     :param a1: Angle from the horizontal for a parallelogram with straight
%       vertical sides. 0 for a rectangle/other type parallelogram
%     :param a2: Angle from the horizontal for a parallelogram with straight
%     horizontal sides. 0 for a rectangle/other type parallelogram
%     :return:

% initialize 

rr = zeros(length(centreR),4);
zz = zeros(length(centreZ),4);

tol = 1e-7;
dR = dR / 2.0;
dZ = dZ / 2.0;


%% Rectangle
indrec = ((a1<tol) & (a2<tol));
rr(indrec,1) = centreR(indrec) - dR(indrec);
rr(indrec,2) = centreR(indrec) - dR(indrec); 
rr(indrec,3) = centreR(indrec) + dR(indrec); 
rr(indrec,4) = centreR(indrec) + dR(indrec);


zz(indrec,1) = centreZ(indrec,1) - dZ(indrec,1);
zz(indrec,2) = centreZ(indrec,1) + dZ(indrec,1);
zz(indrec,3) = centreZ(indrec,1) + dZ(indrec,1);
zz(indrec,4) = centreZ(indrec,1) - dZ(indrec,1);
    


%% Parallelogram
indpar = ((a1>=tol) & (a2>=tol));

a1_tan = zeros(length(centreR),1);
a2_tan = zeros(length(centreR),1);


a1_tan(a1>0) = tan(a1(a1 > 0).*pi./180);
a2_tan(a2>0) = 1./tan(a2(a2>0).*pi/ 180);

rr(indpar,1) = centreR(indpar) - dR(indpar) - dZ(indpar).*a2_tan(indpar);
rr(indpar,2) = centreR(indpar) + dR(indpar) - dZ(indpar).*a2_tan(indpar);
rr(indpar,3) = centreR(indpar) + dR(indpar) + dZ(indpar).*a2_tan(indpar);
rr(indpar,4) = centreR(indpar) - dR(indpar) + dZ(indpar).*a2_tan(indpar);

%% output for use in patch()

rrout = transpose(rr);
zzout = transpose(zz);


zz(indpar,1) = centreZ(indpar) - dZ(indpar) - dR(indpar).*a1_tan(indpar);
zz(indpar,2) = centreZ(indpar) - dZ(indpar) + dR(indpar).*a1_tan(indpar);
zz(indpar,3) = centreZ(indpar) + dZ(indpar) + dR(indpar).*a1_tan(indpar); 
zz(indpar,4) = centreZ(indpar) + dZ(indpar) - dR(indpar).*a1_tan(indpar);



