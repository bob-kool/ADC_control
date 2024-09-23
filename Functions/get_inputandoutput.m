function [u,y]=get_inputandoutput(Input,Output,shot,settings)
%Add default settings if settings are not specified?
% settings_ = struct; get_default_settings('IO');

% for jj = 1:length(fields(settings_))
%     try
%     settings_.(fields{jj}) = settings.(fields{jj})
%     catch
%       please do not make the input settings struct leading
%     end
% end

% Parse <shot>, as it may contain subshot specifications (e.g. "48468a")
[shot, ~] = parse_shot_specification(shot);

% Transfer settings to keyword arguments that should be passed to the data
% getters for each diagnostic
diagnostic_kwargs = {};
diagnostic_keys = ["filter_elms", "correct_time", "artifact_spikes", "clip"];
for key = diagnostic_keys
    if isfield(settings, key)
        diagnostic_kwargs = [diagnostic_kwargs, {key, settings.(key)}]; %#ok<AGROW>
    end
end

%% Loop over input and input
for ii=1:2
    %are we looking for input or output?
    if ii==1
        InputorOutput=Input;
    else
        InputorOutput=Output;
    end
    %% Load data
    switch InputorOutput
        case 'valve'
            [GV] = getGas(shot,settings.valve,'valve_spec',settings.valvespec,'valve_pressure',settings.valveplenumpressure,'take_requested_from_measured',settings.take_requested_from_measured, 'calculate_flowrate',settings.calculate_flowrate,diagnostic_kwargs{:});
            data=GV.(settings.valve).u;
            time=GV.(settings.valve).time;
        case 'DA'
            [DA] = getDalpha(shot,settings.scope, diagnostic_kwargs{:});
            data=DA.(settings.scope).u;
            time=DA.(settings.scope).time;
        case 'IF'
            IF = getIF(shot, diagnostic_kwargs{:});
            data=IF.ne;
            time=IF.time;
        case 'IF_norm'
            IF_norm = getIF(shot, diagnostic_kwargs{:});
            data=IF_norm.ne/1e21;
            time=IF_norm.time;
        case 'IF_LA'
            IF_LA = getIF_LA(shot, diagnostic_kwargs{:});
            data=IF_LA.ne;
            time=IF_LA.time;
        case 'FIG'
            FIG = getFIG(shot,settings.FIGlocation,'raw', diagnostic_kwargs{:});
            data=FIG.(settings.FIGlocation).pressure;
            time=FIG.(settings.FIGlocation).time;
        case 'BOLO'
            channels={settings.BOLOchannel};
            BOLO = getBOLO(shot,channels, diagnostic_kwargs{:});

            if settings.BOLOchannel>=17
                channelname=strcat('wall',num2str(settings.BOLOchannel));
            else
                channelname=strcat('baffle',num2str(settings.BOLOchannel));
            end
            data=BOLO.(channelname).power;
            time=BOLO.(channelname).time;
        case {'fd','fd_INV'}
            if settings.referenceshot==0
                fdname=strcat('fd_',num2str(shot),'_',settings.fdspec);
            else
                fdname=strcat('fd_',num2str(shot),'',settings.fdspec,'_ref',num2str(settings.referenceshot));
            end


            if strcmp(InputorOutput,'fd_INV')
                if ~isfield(settings,'XPI')
                    settings.XPI=0;
                end
                if ~isfield(settings,'dual')
                    settings.dual=0;
                end
                if settings.dual==1
                    fdname=insertAfter(fdname,"fd","_dual");
                elseif settings.XPI==1
                    fdname=insertAfter(fdname,"fd","_XPI");
                else
                    fdname=insertAfter(fdname,"fd","_MWI");
                end
                fd=getLpol_inv(fdname, diagnostic_kwargs{:});
            else
                fd=getLpol(fdname, diagnostic_kwargs{:});
            end

%             disp('front interpolation enabled!')
%             fd.L(fd.L==-1)=NaN;
%              fd.L= fillmissing(fd.L,'linear');

            % shift by half exposure time moved to getLpol_inv!

            if isfield(settings,'fdcut')
                if settings.fdcut & isfield(settings,"fdmin")
                    if ~(isfield(settings,"assume_confirm_fdcut") & settings.assume_confirm_fdcut)
                        disp('Limits applied to fd, replacing detected points through interpolation, are you sure?')
                        pause
                    end
                    fd.L(fd.L<settings.fdmin) = NaN;
                    fd.L = fillmissing(fd.L,'linear');
                    fd.L(fd.L>settings.fdmax) = NaN;
                    fd.L = fillmissing(fd.L,'linear');
                end
                if settings.fdcut & isfield(settings,"fdmin_Lx")
                    if ~(isfield(settings,"assume_confirm_fdcut") & settings.assume_confirm_fdcut)
                        disp('Limits applied to fd, replacing detected points through interpolation, are you sure?')
                        pause
                    end
                    fd.Lx(fd.Lx<settings.fdmin_Lx) = NaN;
                    fd.Lx = fillmissing(fd.Lx,'linear');
                    fd.Lx(fd.Lx>settings.fdmax_Lx) = NaN;
                    fd.Lx = fillmissing(fd.Lx,'linear');
                end
            end

            if isfield(settings,'wrt_Xpoint')
                if settings.wrt_Xpoint
                    data=fd.Lx;
                else
                    data=fd.L;
                end
            else
                data=fd.L;
            end
            time=fd.tout;
        case 'fdDMS'
            fdname=['fdDMS_',num2str(shot),'_',settings.DMSfilter,'_',settings.DMSsystem,'_',num2str(100*(1-settings.DMSthresh))];
            fd=getLpolDMS(fdname, diagnostic_kwargs{:});
            data=fd.L;
            time=fd.tout;
        case 'RDIintensity'
            RDI = getRDI(shot, "inverted", settings.intensitylocation, diagnostic_kwargs{:});
            data=RDI.data;
            time=RDI.time;
        case 'DMSintensity'
            [DMS] = getDMS(shot,settings.DMSsystem,settings.DMSfilter, diagnostic_kwargs{:});
            data=sum(DMS.R_EPS);
            time=DMS.time;
        case 'UFDS'
            [UFDS] = getUFDS(shot, diagnostic_kwargs{:});
            re = regexp(settings.UFDSspec,"^(fulcher|dalpha|dbeta)_(1|2|3|4|5|all)$",'tokens');
            band = re{1}{1};
            if re{1}{2} == "all"
                data = UFDS.(band){1}.data + UFDS.(band){2}.data + UFDS.(band){3}.data + UFDS.(band){4}.data + UFDS.(band){5}.data;
                time = UFDS.(band){1}.time;
            else
                channel = str2num(re{1}{2});
                switch band
                    case 'fulcher'
                        data=UFDS.fulcher{channel}.data;
                        time=UFDS.fulcher{channel}.time;
                    case 'dalpha'
                        data=UFDS.dalpha{channel}.data;
                        time=UFDS.dalpha{channel}.time;
                    case 'dbeta'
                        data=UFDS.dbeta{channel}.data;
                        time=UFDS.dbeta{channel}.time;
                end
            end
        case 'Z'
            VC.Z=getVC(shot,"Z", diagnostic_kwargs{:});
            data=VC.Z.signal;
            time=VC.Z.time;
        case 'Zref'
            Zref = getVC(shot, "Zref", diagnostic_kwargs{:});
            data = Zref.signal;
            time = Zref.time;
        case 'drsep'
            drsep = getDrsep(shot, settings.drsep_mode, settings.perturbation_window, diagnostic_kwargs{:});
            data = drsep.outer;
            time = drsep.time;
        case {'rit', 'rir','riv','riu','ris','ris_lower','ris_upper','rba','rba_lower','rba_upper'}
            [intensity] = get_ROI_intens(shot,InputorOutput, diagnostic_kwargs{:});
            data=intensity.data;
            time=intensity.time;
        case {'ait', 'air', 'aiv', 'aiu', 'aus'}
            ir = getAnalysedIR(shot, InputorOutput, diagnostic_kwargs{:}, do_integrate=true);
            data = ir.integrated_heat_flux;
            time = ir.t;
        case 'LP'
            try
                [mode, operation, divertor, sector, tiles] = parse_lp_specification(settings.LPspec);
                if mode == "jsat"

                    LP = getLP(shot,"jsat",divertor,diagnostic_kwargs{:},operation=operation,sector=sector,tiles=tiles);
                    data=LP.jsat; % hard coding this here implies that we can only use one of these variables (jsat, vfloat and Te) at the same time
                    time=LP.time;

                elseif mode == "vf"
                    LP = getLP(shot, "vf", divertor, diagnostic_kwargs{:}, sector=sector, do_integrate=true);
                    switch tiles
                        case "T4T5" % SXD outer target
                            data = LP.integrated.T4 + LP.integrated.T5;
                        case "T2" % conventional outer target
                            data = LP.integrated.T2;
                        case "C5C6" % inner target
                            data = LP.integrated.C6;
                            % this is a small error in how the probes are
                            % classified. C5 probes are considered to be on C6.
                    end
                    time = LP.time;
                end
            catch e
                if e.identifier == "MATLAB:badsubscript"
                    error("Langmuir probe specification ("+settings.LPspec+") must match "+...
                        "^(vf|jsat_max|jsat_int)_(upper|lower)_(4|10|all|available)_(T2|T4T5|C5C6)$");
                else
                    rethrow(e)
                end
            end
        case {"brunner_il","brunner_iu","brunner_ol","brunner_ou"}
            spec = extractAfter(InputorOutput,"_");
            brunner = getBrunner(shot, diagnostic_kwargs{:});
            time = brunner.time;
            data = brunner.(spec);
        case "null"
            time = [];
            data = [];
    end

    %are we looking for input or output?
    if ii==1
        u.data=double(data);
        u.time=double(time);
    else
        y.data=double(data);
        y.time=double(time);
    end
end