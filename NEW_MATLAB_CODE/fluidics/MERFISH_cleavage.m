function handles = MERFISH_cleavage(handles, mega, MVP1, MVP2, cleavage_t, cleavage_fr)

        %%% README %%%

        %{
        mega:           arduino mega handle created upon program
                        initialization
        MVP1:           first MVP handle
        MVP2:           second MVP handle
        cleavage_t:     total time of cleavage (s)
        cleavage_fr:    flow rate of cleavage (index, 0-3. for index mapping, see instructions.m)
        %}

        %{
        workflow:
            refer to schematic diagram for syringe pump setup.
            
            MVP1 controls which syringe pump to use.
            MVP2 controls wash/imaging/cleavage liquids, as well as
                 injecting liquid in and disgarding liquid from chamber.
            MVP3 controls which hybridization fluid to use.

            30mL syringe is only used for cleavage buffer.
            30mL syringe will intake all of cleavage buffer at once in the
            beginning, and will withdraw the set amount in every run.

            ---cleavage---
            (30mL Syringe should have been filled with cleavage solution
            prior to this step. See cleavage_init.m for workflow)
            MVP1 switches to valve position 2. (30mL Syringe)
            MVP2 switches to valve position 1. (chamber inlet)
            Syringe goes down with specified speed and duration.
            (injecting)
            After the duration has passed, stop the pump.
        %}
        
        disp('Starting cleavaging');
        
        fprintf(MVP1, 'aLP02R');
        fprintf(MVP2, 'aLP01R');
        startTime = clock;
        switch cleavage_fr
            case 0
                writeMega(mega, 30, 1, 0, 0, 0, 1);
            case 1
                writeMega(mega, 30, 1, 0, 0, 1, 1);
            case 2
                writeMega(mega, 30, 1, 0, 1, 0, 1);
            case 3
                writeMega(mega, 30, 1, 0, 1, 1, 1);
        end

        while etime(clock, startTime) < cleavage_t
        end
        writeMega(mega, 30, 1, 1, 1, 1, 1);
        % stop program from looping
        pause(1);
        writeMega(mega, 10, 1, 1, 1, 1, 0);
        
        disp('Completed cleavaging');
end
