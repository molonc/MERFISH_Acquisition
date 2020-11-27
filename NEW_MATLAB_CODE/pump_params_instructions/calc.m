function flowrate = calc(delayTime)
    timePerRev = delayTime * 2 * 32 * 200 / 1000000;
    speed = 8 / timePerRev;
    PI = 3.14159265359;
    area = (14.4/2)^2 * PI;
    flowrate = (speed * area) * 60 / 1000;
end