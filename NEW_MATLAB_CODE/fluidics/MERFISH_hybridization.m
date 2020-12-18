function handles = MERFISH_hybridization(handles, mega, MVP1, MVP2, MVP3, fluid_num, wash_t, wash_fr, hybrid_t, hybrid_fr, imaging_t, imaging_fr)
        
        %%% README %%%

        %{
        mega:           arduino mega handle created upon program
                        initialization
        MVP1:           first MVP handle
        MVP2:           second MVP handle
        MVP3:           third MVP handle
        fluid_num:      hybridization fluid number (1-8)
        wash_t:         total time of wash (s)
        wash_fr:        flow rate of wash (index)
        hybrid_t:       total hybridization time (s)
        hybrid_fr:      flow rate of hybridization (index)
        imaging_t:      total imaging time (s)
        imaging_fr:     flow rate of imaging buffer (index)
        %}

        %{
        workflow:
            refer to schematic diagram for syringe pump setup.
            
            MVP1 controls which syringe pump to use.
            MVP2 controls wash/imaging/cleavage liquids, as well as
                 injecting liquid in and disgarding liquid from chamber.
            MVP3 controls which hybridization fluid to use.

            10mL syringe is used for every fluid except cleavage buffer.
            10mL syringe will intake and withdraw fluids every run.
        
            When activating syringe pump, MATLAB will send signals to Mega
            which will tell Nano to drive the pump. Mega will receive a
            HIGH signal, meaning that the syringe has reached its limit.
        
            For instructions on what parameters the pump takes, please see
            pump_params_instructions/instructions.m, or run
            pump_params_instructions/speedConversion.m and
            pump_params_instructions/calc.m for speed/flowrate conversion.
        
            When hybridization is run:
            wash buffer
            empty waste
            hybridize
            empty waste
            imaging buffer
            empty waste 
        
        %}
        disp('Starting hybridization round');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Starting hybridization round');
            
        disp('Injecting wash buffer');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Injecting wash buffer');
        wash(handles, mega, MVP1, MVP2, wash_t, wash_fr);
        
        disp('Wash buffer succesfully injected. Emptying waste.');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Wash buffer succesfully injected. Emptying waste.');
        emptyWaste(mega, MVP2);
        
        disp(['Finished emptying. Injecting hybridization buffer ', num2str(fluid_num)]);
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), ['Finished emptying. Injecting hybridization buffer ', num2str(fluid_num)]);
        hybrid_buffer(handles, mega, MVP2, MVP3, fluid_num, hybrid_t, hybrid_fr);
        
        disp('Hybrid buffer succesfully injected. Emptying waste.');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Hybrid buffer succesfully injected. Emptying waste.');
        emptyWaste(mega, MVP2);
        
        disp('Finished emptying. Injecting imaging buffer.');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Finished emptying. Injecting imaging buffer.');
        imaging(handles, mega, MVP2, imaging_t, imaging_fr);
        
        disp('Imaging buffer succesfully injected. Emptying waste.');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Imaging buffer succesfully injected. Emptying waste.');
        emptyWaste(mega, MVP2);
        
        disp('Completed hybridization round');
        fprintf(handles.logfile, '%s: %s\r\n', datestr(now, 0), 'Completed hybridization round');
  
    end