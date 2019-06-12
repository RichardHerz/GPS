function xyzView = fReturnSatInView(xyz,xyzRec) 
    % parses satellite xyz (# sat x 3 matrix) and returns only those
    % above horizon of receiver at xyzRec (row vector of 3 col) 
    
    % get equation of plane that is tangent to spherical earth at xyzRec
    % x*xyzRec(1) + y*xyzRec(2) + z*xyzRec(3) = p
    % at xyz = xyzRec, this is eqn for square of distance of xyz from 0,0,0
    p = sum(xyzRec.^2, 2); % sum option 2 to sum rows 
    
    % for each satellite xyz, determine z on tangent plane and compare to 
    % satellite z
    % at lat > 0 (North) sat z must be > tangent z
    % at equator (lat == 0) any z is good
    % at lat < 0 (South) sat z must be < tangent z 
    
    % compute satellite z on receiver's tangent plane for satellite x,y 
    % WARNING: lat of receiver == 0 gives z == 0 & division by zero
    % so add error of +1 meter to receiver z
    % this would mean a satellite on southern horizon would fall below...
    
    if (xyzRec(3) == 0)
        xyzRec(3) = 1; % local value only, not changed in main
    end
    zplane = (p - xyzRec(:,1) .* xyz(:,1) - xyzRec(:,2) .* xyz(:,2)) ./ xyzRec(3)
    
    % now want z > zplane for receivers in northern hemisphere
    % z < zplane for receivers in southern hemisphere 
    
    % xxx what about receiver at lat = 0 but corrected to z = 1
    % and satellite at lat = 0... 
    
    rn = []; % initialize in case none found
    rs = [];
    if xyzRec(3) > 0
        % receiver in Northern hemisphere
        % find satellites whose z > zplane
        [rn cn] = find(xyz(:,3) > zplane(:))
    else
        % receiver in Southern hemisphere
        % none at equator & z == 0 because of +1 meter offset above
        % find satellites whose z < zplane
        [rs cs] = find(xyz(:,3) < zplane(3))
    end
    
    % return only the satellites in view above receiver's horizon
    xyzView = [xyz(rn,:) ; xyz(rs,:)]
    
        
    