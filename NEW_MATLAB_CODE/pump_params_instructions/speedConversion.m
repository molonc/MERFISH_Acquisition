%% Syringe Pump Speed Conversion %%

function delayTime = speedConversion(flowrate, stepSize)    % (mL/min, N/A)
    diam = 14.4;              % (mm)

    rad = diam / 2;         % (mm)
    PI = 3.14159265359;
    area = (rad)^2 * pi;    % (mm)^2
    % flowrate (mL/min) = (area * speed) * 60 / (1000)              
    % (mm^2 * mm/s) * (60s/min) / (1000mm^3/mL)
    stepPerRev = 200;
    pitch = 2;              % (mm)
    lead = 4;
    speed = (flowrate * 1000 / 60) / area;      % (mm/s)
    % speed (mm/s) = (pitch / timePerRev)
    % timePerRev (s) = (delayTime * 2) * 32 * 200
    % timePerRev (us) = timePerRev * 1000000
    timePerRev = (pitch * lead / speed);
    delayTime = timePerRev * 1000000 / (2 * stepSize * stepPerRev);
end