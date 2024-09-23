function settings = get_frf_settings(shot, varargin)
% Returns a default settings struct that can be used for get_inputandoutput or
% get_frfpars_mastu. Override defaults by specifying them als name,value pairs.

settings.shot = shot;
settings.scope = get_kwarg("scope", "HL0SXDT", varargin);
settings.LPspec = get_kwarg("LPspec", "lower_4_T4T5_int", varargin);
settings.drsep_mode = get_kwarg("drsep_mode","VC_CORRECTED", varargin);
settings.filter_elms = get_kwarg("filter_elms", false, varargin);
settings.correct_time = get_kwarg("correct_time", false, varargin);
settings.artifact_spikes = get_kwarg("artifact_spikes", "nothing", varargin);
settings.valve = get_kwarg("valve", "LFSV_BOT_L09", varargin);
settings.valvespec = get_kwarg("valvespec", "measured", varargin);
settings.take_requested_from_measured = get_kwarg("scope", false, varargin);
settings.fdspec = get_kwarg("fd_spec", "FB_50", varargin);
settings.referenceshot = get_kwarg("referenceshot", 0, varargin);
settings.inversion = get_kwarg("inversion", 0, varargin);
settings.fixequil = get_kwarg("fixequil", 0, varargin);
settings.BOLOchannel = get_kwarg("BOLOchannel", 13, varargin);
settings.FIGlocation = get_kwarg("FIGlocation", "HM12", varargin);
settings.camera = get_kwarg("camera", 7, varargin);
settings.intensitylocation = get_kwarg("intensitylocation", "ISP", varargin);
settings.DMSsystem = get_kwarg("DMSsystem", "3btm", varargin);
settings.DMSfilter = get_kwarg("DMSfilter", "FB", varargin);
settings.DMSthresh = get_kwarg("DMSthresh", 0.5, varargin);
settings.UFDSfilter = get_kwarg("UFDSfilter", "FB", varargin);
settings.UFDSspec = get_kwarg("UFDSspec", "fulcher_1", varargin);
settings.wrt_Xpoint = get_kwarg("wrt_Xpoint", false, varargin);
settings.assume_confirm_fdcut = get_kwarg("assume_confirm_cut", false, varargin);

settings.specline = settings.fdspec;

end