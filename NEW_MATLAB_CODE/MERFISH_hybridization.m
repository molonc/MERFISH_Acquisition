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
            ---Wash---
            MVP1 switches to valve position 1. (10mL syringe)
            MVP2 switches to valve position 2. (waste, empty dead volume)
            Syringe pump goes to bottom. (ready to withdraw)
            MVP2 switches to valve position 8. (wash buffer)
            Syringe pump goes to top, with set speed. (withdrawing)
            MVP2 switches to valve position 1. (chamber inlet)
            Syringe pump goes down, with specified flowrate and duration.
            (washing)
        
            ---Rinse---
            MVP2 switches to valve position 2. (waste, empty dead volume)
            Syringe pump goes to bottom.
            MVP2 switches to valve position 5. (distilled water)
            *Syringe pump goes to top, with set speed. (withdrawing)
            *MVP2 switches to valve position 2. (waste)
            *Syringe pump goes to bottom, with set speed. (rinsing)
            *Repeat * for x amount of times.
        
            ---Hybridization---
            (Syringe pump already at very bottom)
            MVP2 switches to valve position 3. (MVP3)
            MVP3 switches to valve position with the fluid number.
            Syringe pump goes to top. (withdrawing)
            MVP2 switches to valve position 1. (chamber inlet)
            Syringe pump goes down, with specified flowrate and duration.
            (hybridizing)
            After duration has passed, stop the pump.
        
            ---Rinse---
            MVP2 switches to valve position 2. (waste, empty dead volume)
            Syringe pump goes to bottom.
            MVP2 switches to valve position 5. (distilled water)
            *Syringe pump goes to top, with set speed. (withdrawing)
            *MVP2 switches to valve position 2. (waste)
            *Syringe pump goes to bottom, with set speed. (rinsing)
            *Repeat * for x amount of times.
        
            ---Imaging---
            (Syringe pump already at very bottom)
            MVP2 switches to valve position 7. (imaging buffer)
            Syringe pump goes to top. (withdrawing)
            MVP2 switches to valve position 1. (chamber inlet)
            Syringe pump goes down, with specified flowrate and duration.
            (imaging)
            After duration has passed, stop the pump.
        
            ---Rinse---
            MVP2 switches to valve position 2. (waste, empty dead volume)
            Syringe pump goes to bottom.
            MVP2 switches to valve position 5. (distilled water)
            *Syringe pump goes to top, with set speed. (withdrawing)
            *MVP2 switches to valve position 2. (waste)
            *Syringe pump goes to bottom, with set speed. (rinsing)
            *Repeat * for x amount of times.
        %}
        disp('Starting hybridization round');
            
        disp('Injecting wash buffer');
        wash(mega, MVP1, MVP2, wash_t, wash_fr);
        disp('Wash buffer succesfully injected. Rinsing syringe');
        rinse(mega, MVP2, 5);
        disp(['Finished rinsing. Injecting hybridization buffer ', num2str(fluid_num)]);
        hybrid_buffer(mega, MVP2, MVP3, fluid_num, hybrid_t, hybrid_fr);
        disp('Hybrid buffer succesfully injected. Rinsing syringe');
        rinse(mega, MVP2, 5);
        disp('Finished rinsing. Injecting imaging buffer.');
        imaging(mega, MVP2, imaging_t, imaging_fr);
        disp('Imaging buffer succesfully injected. Rinsing syringe');
        rinse(mega, MVP2, 5);
        
        disp('Completed hybridization round');
  
    end