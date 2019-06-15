function rowView = fReturnSatViewRows(sat,xyz,xyzRec,re,degdel) 
    % returns row numbers of satellites > degdel above horizon 
    
    dRec = fDistance(xyz,xyzRec); % distances from sats to receiver
    dOrig = re + sat(:,3); % distances from sats to earth center
    
    % we know 3 sides of triangle between sat, rec, earth center
    % use law of cosines
    num = re^2 + dRec.^2 - dOrig.^2;
    denom = 2 * re * dRec;
    gamma = -90 + acosd(num ./ denom);
    
    % find and return satellite row numbers where gamma >= degdel
    rowView = find(gamma >= degdel);
