function [signal,time] = get_data(cmd,shot)
% Simple function that loads requested data from storage. If this was not
% available, data is pulled from UDA and saved in storage
%
% Inputs:
% cmd   =   data location/command   [string]
% shot  =   integer with shot nmber [integer] or location of PCS test file

%% data storage location
datastore='/Differ/Data/MAST-U/UDADataStorage/';

%% check if shot is actual shot or PCS testfile location, if so, remove any backslashes
if isstring(shot) || ischar(shot)
    shot=char(strrep(shot,'/','_'));
end
%% convert cmd to filename in storage
filename=char(strrep(cmd,'/','_'));
if filename(1)~='_' %make sure that we always have a _ at the start
    filename=strcat('_',filename);
end
filename=strcat(num2str(shot),filename);
%% Load file from storage or UDA
disp(string(strcat('Trying to get:',{[' ']},filename,{[' ']})));
if ~isfile(strcat(datastore,filename,'.mat'))
    %load from UDA
    [signal,time] = get_from_UDA(cmd,shot);
    % save data
    save(strcat(datastore,filename,'.mat'),'signal','time')
else
    %load from storage
    disp(string(strcat('Loading',{[' ']},cmd,{[' ']},'from storage')));
    load(strcat(datastore,filename,'.mat'),'signal','time')
end
end
