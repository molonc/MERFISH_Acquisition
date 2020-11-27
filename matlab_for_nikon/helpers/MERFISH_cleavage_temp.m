function [] = MERFISH_cleavage_temp(miniplus,MVP1,MVP2,MVP3,ID)
fprintf(MVP2,'aLP06R');
fprintf(MVP3,'aLP07R');
fprintf(MVP1,['aLP1',num2str(1),'R']);
gsioc(miniplus, ID, 'B','R4800');
disp('Cleavaging');
gsioc(miniplus,ID,'B','K<');
pause(120);
gsioc(miniplus, ID, 'B','R640');
pause(300);
gsioc(miniplus, ID, 'B','KH');
disp('Complete Cleavage');
gsioc(miniplus,ID,'B','R4800');


end