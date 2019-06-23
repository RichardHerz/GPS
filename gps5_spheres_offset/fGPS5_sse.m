function sse = fGPS5_sse(xyzRecCalc, xyz, rMEAS)
    % returns sum of squared errors for equations for intersection
    % of sat-to-rec distance spheres with unknown constant distance
    % offset in measurements, where
    % (rMEAS + offSETcalc) == distances corrected for offset
    
    xyzCalc = xyzRecCalc(1:3);
    offSETcalc = xyzRecCalc(4);

    error = sum([xyz - xyzCalc].^2, 2) - (rMEAS + offSETcalc).^2;

    sse = sum(error .^ 2);
