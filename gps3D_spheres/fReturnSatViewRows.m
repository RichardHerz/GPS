function rowView = fReturnSatViewRows(xyz,xyzRec) 
    % parses satellite xyz (# sat row x 3 col matrix) and returns only those
    % above horizon of receiver at xyzRec (row vector of 3 col) 
    
    % get equation of plane that is tangent to spherical earth at xyzRec
    % xyzRec(1) * x + xyzRec(2) * y + xyzRec(3) * z = p
    % at xyz = xyzRec, this is eqn for square of distance of xyz from 0,0,0
    p = sum(xyzRec.^2, 2); % sum option 2 to sum rows 
    
    % for each satellite xy, determine z of tangent plane and compare to 
    % satellite z
    % for receiver at lat > 0 (North), sat z must be > tangent z
    % for receiver at equator (lat == 0), any z is good
    % for receiver at lat < 0 (South) sat z must be < tangent z 
    
    % compute satellite z on receiver's tangent plane for satellite x,y 
    % WARNING: lat of receiver == 0 gives z == 0 & division by zero
    % so add error of +1 cm to receiver z
    % this would mean a satellite on southern horizon would fall out of
    % view BUT, in reality, also need to account for nonplanar horizon
    
    if (xyzRec(3) == 0)
        xyzRec(3) = 0.01; % local value only, not changed in main
    end
    zplane = (p - xyzRec(:,1) .* xyz(:,1) - xyzRec(:,2) .* xyz(:,2)) ./ xyzRec(3);
    
    % now want z > zplane for receivers in northern hemisphere
    % z < zplane for receivers in southern hemisphere 
    
    rn = []; % initialize in case none found
    rs = [];
    if xyzRec(3) > 0
        % receiver in Northern hemisphere
        % find satellites whose z > zplane
        [rn cn] = find(xyz(:,3) > zplane(:));
    else
        % receiver in Southern hemisphere
        % none at equator at z == 0 because of +1 cm offset added above
        % find satellites whose z < zplane
        [rs cs] = find(xyz(:,3) < zplane(3));
    end
    
    % return the row numbers of satellites in view above receiver's horizon
    rowView = [rn; rs];
    
  