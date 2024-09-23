function [DC] = getPCSdetachmentcontrol(shot,varargin)
%loads PCSdata related to detachment control
%shot can be specified as datastorage location as well to load simulated
%PCS output, similar to UDA implementation

%also get MWI out
adress="/xdc/ai/cpu1/mwi_out";
[signal,time] = get_data(adress,shot);
DC.mwi_out.u=signal;
DC.mwi_out.us = smooth(signal,5);
DC.mwi_out.time=time;
DC.mwi_out.units='[V]';
DC.mwi_out.label{1}='mwi_out [V]';
DC.mwi_out.label{2}='Time [s]';


try
    tracelist={'e/error','e/error_lowpass','e/u_fb','e/u_offset_tswitch','e/u_raw','e/u_sum','s/dterm','s/dummy_run','s/fb_takeover','s/idterm','s/iterm','s/iterm_lowpass','s/lp_enable','s/lpol','s/lpol_ok','s/u_offset_taken','s/u_offset_tswitch','t/det1_ff','t/det1_limit','t/det1_maxflow','t/det2_ff','t/det2_limit','t/det2_maxflow','t/det_ctr_d','t/det_ctr_enable','t/det_ctr_i','t/det_ctr_n_d','t/det_ctr_p','t/det_lp_cf','t/det_lpol_ref','t/dummy_lpol','t/dummy_u_ne_fb','t/u_limit','t/l_limit'};
    labellist={'error','error\_lowpas','u\_fb','u\_offset\_tswitch','u\_raw','u\_sum','dterm','dummy\_run','fb\_takeover','idterm','iterm','iterm\_lowpass','iterm\_lp\_enable','lpol','lpol\_ok','u\_offset\_taken','u\_offset\_tswitch','det1\_ff','det1\_limit','det1\_maxflow','det2\_ff','det2\_limit','det2\_maxflow','det\_ctr\_d','det\_ctr\_enable','det_ctr_i','det_ctr_n_d','det\_ctr\_p','det\_lp\_cf','det\_lpol\_ref','dummy\_lpol','dummy\_u\_ne\_fb','u_limit','t_limit'};
    unitlist={'[m]','[m]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[-]','[-]','[-]','[-]','[-]','[-]','[-]','[m]','[-]','[-]','[m]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[-]','[-]','[-]','[-]','[-]','[Hz]','[m]','[m]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]','[$\mathrm{10^{21}s^{-1}}$]'};
    for ii=1:length(tracelist)
        trace=strcat('/xdc/detachment/',tracelist{ii});
        [signal,time] = get_data(trace,shot);
        name=extractAfter(tracelist{ii},'/');
        DC.(name).u=signal;
        DC.(name).us = smooth(signal,30);
        DC.(name).time=time;
        DC.(name).units=unitlist{ii};
        DC.(name).label{1}=strcat(labellist{ii},{' '},unitlist{ii});
        DC.(name).label{2}='Time [s]';
    end
catch
    warning('Cannot find detachment controller signals')
    figure
    plot(DC.mwi_out.time,DC.mwi_out.u)
    title('Raw MWI out')
    xlabel('time [s]')
end



end


