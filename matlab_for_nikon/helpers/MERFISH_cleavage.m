function [] = MERFISH_cleavage(miniplus,MVP1,cleavage,ID,clevage_t)

fprintf(MVP1,['aLP0',num2str(cleavage),'R']);
pause(5)
gsioc(miniplus, ID, 'B','R4800');
disp('Cleavaging');
startTime = clock;
while etime(clock, startTime)<100
    gsioc(miniplus,ID,'B','K>');
end
gsioc(miniplus, ID, 'B','R640');
startTimeCle = clock;
while etime(clock, startTimeCle) < clevage_t
end
gsioc(miniplus, ID, 'B','KH');
disp('Complete Cleavage');
gsioc(miniplus,ID,'B','R4800');

end
