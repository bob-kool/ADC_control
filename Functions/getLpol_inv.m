function [fd_inv] = getLpol_inv(name,varargin)
%specify as 'fd_47118_FB_50'
%loads Lpol from specified folder

disp(string(strcat('Loading ',{[' ']},name,{[' ']},' INV from database')));
invertedlpolfolder='/Differ/Data/MAST-U/MWI/fronttracking/inversions/';

if contains(name,'_dual')
    invertedlpolfolder='/Differ/Data/MAST-U/MWI/fronttracking/inversions/Dual/';
    name=erase(name,'_dual');
    system='dual';
end
if contains(name,'_XPI')
    invertedlpolfolder='/Differ/Data/MAST-U/MWI/fronttracking/inversions/XPI/';
    name=erase(name,'_XPI');
    system='XPI';
end

if contains(name,'_MWI')
    invertedlpolfolder='/Differ/Data/MAST-U/MWI/fronttracking/inversions/MWI/';
%     invertedlpolfolder='/Differ/Data/MAST-U/MWI/fronttracking/inversions/';
    name=erase(name,'_MWI');
    system='MWI';
end

shot=extractBefore(extractAfter(name,'fd_'),'_');
line=extractBefore(extractAfter(name,strcat(shot,'_')),'_');
spec=extractAfter(name,'FB_');
invertedlpolfolder=strcat(invertedlpolfolder,shot,'/',line,'/');


name_times=strcat('times_vec_',spec,'percent_max_fixed');
name_Lpol=strcat('Lpol_vec_',spec,'percent_max_fixed');
name_RZ=strcat('RZ_sep_front_',spec,'percent_max_fixed');
if ~exist(strcat(invertedlpolfolder,name_times,'.npy'))
    name_times=strcat('times_vec_',spec,'percent');
    name_Lpol=strcat('Lpol_vec_',spec,'percent');
    name_RZ=strcat('RZ_sep_front_',spec,'percent');
    disp('Taking variable maximum front position')
else
    disp('Taking fixed maximum front position')
end


% try
    fd_inv.tout=double(readNPY(strcat(invertedlpolfolder,name_times,'.npy'))');
% catch
    % error(strcat('Specified inverted fd not found!'))
% end
fd_inv.L=double(readNPY(strcat(invertedlpolfolder,name_Lpol,'.npy'))');
fd_inv.RZ=double(readNPY(strcat(invertedlpolfolder,name_RZ,'.npy'))');

try fd_inv.Lx=double(readNPY(strcat(invertedlpolfolder,name_Lpol,'_Xpoint','.npy'))');
catch
    warning(strcat('No inverted fd distance to X-point found!'))
end

% shift by half exposure time
fd_inv.tout=fd_inv.tout+mean(diff(fd_inv.tout))/2;

try fd_inv.exposure=double(readNPY(strcat(invertedlpolfolder,'exposure','.npy'))');
catch
    warning(strcat('No exposure data found!'))
end
% for ELM filtering

filter_kwargs = get_filter_kwargs(shot, varargin{:}, elm_dt_start=0.001, elm_dt_end=0.0035);
try
    fd_inv.L = apply_filter(fd_inv.tout, fd_inv.L, filter_kwargs{:}, to="data");
catch
    % this fails sometimes for unknown reason. Didn't bother fixing it because
    % only Lx data was used for the double null paper...
    warning("ELM filtering failed for Lpol w.r.t. target...")
end
fd_inv.Lx = apply_filter(fd_inv.tout, fd_inv.Lx, filter_kwargs{:}, to="data");

fd_inv.label{3} = '$\mathrm{L}_{\mathrm{x}}\mathrm{ inv.}$ [m]';
fd_inv.label{1} = '$\mathrm{L}_{\mathrm{pol}}\mathrm{ inv.}$ [m]';
fd_inv.label{2} = 'Time [s]';