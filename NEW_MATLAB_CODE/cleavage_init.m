function handles = cleavage_init(handles, mega, MVP1, MVP2)

    %%% READ ME %%%
    %{
        fill 30mL syringe with cleavage solution.
    %}
    
    %{
        workflow:
            MVP2 switches to valve position 2. (waste, empty dead volume)
            MVP1 switches to valve position 2. (30mL syringe)
            Syringe goes to bottom.
            MVP2 switches to valve 6. (cleavage buffer)
            Syringe goes to top.
    %}
    
    disp('Filling syringe with cleavage buffer');
    
    fprintf(MVP2, 'aLP02R');
    fprintf(MVP1, 'aLP02R');
    writeMega(mega, 30, 0, 0, 0, 0, 1);
    fprintf(MVP2, 'aLP06R');
    writeMega(mega, 30, 0, 1, 0, 0, 1);
    % stop program from looping
    pause(1);
    writeMega(mega, 30, 1, 1, 1, 1, 1);
    writeMega(mega, 30, 1, 1, 1, 1, 0);
    
    disp('Syringe is now filled with cleavage buffer');
end