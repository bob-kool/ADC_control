function [EFIT] = getEFIT(shot,varargin)
%time   = time  [s]
%ne     = line integrated density [V]

if nargin == 1
    args = [""];
else
    args = [varargin{:}];
end

%% Extract data 
[EFIT.time,~]  = get_data('/epm/time',shot);
[EFIT.psi,~] = get_data('/epm/output/profiles2D/poloidalFlux',shot);
[EFIT.psi_bound,~] = get_data('/epm/output/globalParameters/psiBoundary',shot);
[EFIT.R,~] = get_data('/epm/output/profiles2D/r',shot);
[EFIT.Z,~] = get_data('/epm/output/profiles2D/z',shot);
[EFIT.qual,~] = get_data('/epm/equilibriumStatusInteger',shot);

if contains(args, "volume")
    [EFIT.volume,~] = get_data('/epm/output/globalParameters/plasmaVolume',shot);
end
if contains(args, "drsep")
    [EFIT.drsepOut,~] = get_data('/epm/output/separatrixGeometry/drsepOut',shot);
    [EFIT.drsepIn,~] = get_data('/epm/output/separatrixGeometry/drsepIn',shot);
end

%% remove unconverged time slices from EFIT data
EFIT.qual(EFIT.qual==-1)=0;
EFIT.qual=logical(EFIT.qual);
EFIT.time=EFIT.time(EFIT.qual);
EFIT.psi=EFIT.psi(EFIT.qual,:,:);
EFIT.psi_bound=EFIT.psi_bound(EFIT.qual);

if contains(args, "volume")
    EFIT.volume=EFIT.volume(EFIT.qual);
end
if contains(args, "drsep")
    EFIT.drsepOut=EFIT.drsepOut(EFIT.qual);
    EFIT.drsepIn=EFIT.drsepIn(EFIT.qual);
end

%% get xpoint position if available
try
    dndxpoint1r= get_data('/epm/output/separatrixgeometry/dndxpoint1r',shot);
    dndxpoint1z= get_data('/epm/output/separatrixgeometry/dndxpoint1z',shot);
    dndxpoint2r= get_data('/epm/output/separatrixgeometry/dndxpoint2r',shot);
    dndxpoint2z= get_data('/epm/output/separatrixgeometry/dndxpoint2z',shot);
    dndxpoint1r=dndxpoint1r(EFIT.qual);
    dndxpoint1z=dndxpoint1z(EFIT.qual);
    dndxpoint2r=dndxpoint2r(EFIT.qual);
    dndxpoint2z=dndxpoint2z(EFIT.qual);
    %preallocatte
    EFIT.xpoint_lower_r=NaN(size(EFIT.time));
    EFIT.xpoint_lower_z=NaN(size(EFIT.time));
    EFIT.xpoint_upper_r=NaN(size(EFIT.time));
    EFIT.xpoint_upper_z=NaN(size(EFIT.time));
    %make sure that upper/lower definition matches
    for ii=1:length(EFIT.time)
        Rval=[dndxpoint1r(ii),dndxpoint2r(ii)];
        Zval=[dndxpoint1z(ii),dndxpoint2z(ii)];
        [~,lower_idx]=min(Zval);
        [~,upper_idx]=max(Zval);
        EFIT.xpoint_lower_r(ii)=-Rval(lower_idx);
        EFIT.xpoint_lower_z(ii)=Zval(lower_idx);
        EFIT.xpoint_upper_r(ii)=-Rval(upper_idx);
        EFIT.xpoint_upper_z(ii)=Zval(upper_idx);
    end
catch
    warning('Could not compute xpoint positions')
end
