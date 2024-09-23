function [RDI] = getRDI_plain(shot, camera)
%% data storage location
datastore='/Differ/Data/MAST-U/MWI/MWIdata/';
%% generate filename
filename=strcat(num2str(shot),'_rdi','_CAM',num2str(camera));
%% Load file from storage or UDA
if ~isfile(strcat(datastore,filename,'.mat'))
    disp('cameradata not found!');
else
    %load from storage
    disp(string(strcat('Loading',{[' ']},filename,{[' ']},'from storage')));
    load(strcat(datastore,filename,'.mat'));
    %put into structure
    RDI.frames=permute(frames,[3 2 1]);
    RDI.time=double(time);
%     RDI.time=time(1:end-1);
%     disp('temp time correction!')
    RDI.gain=double(gain);
    RDI.exposure=double(exposure);
    %extract offsets
    RDI.offsety=double(window_top);
    RDI.offsetx=double(window_left);
end
%% Get corrected image and intensity
RDI.intensity=zeros(size(RDI.time));
RDI.frames_corrected=zeros(size(RDI.frames));
for ii=1:length(RDI.time)
    RDI.frames_corrected(:,:,ii)=double(RDI.frames(:,:,ii))./(RDI.exposure(ii).*10.^(RDI.gain(ii)./20));


%     %%masking!
%     RDI.frames_corrected(:,:,ii)
%     createMask()
%


    RDI.intensity(ii)=sum(sum(RDI.frames_corrected(:,:,ii)));
end

end



