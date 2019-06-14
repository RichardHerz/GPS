function rowView = fReturnSatViewRows(sat,xyz,xyzRec,re,degdel) 
    % returns row numbers of satellites > degdel degrees above horizon 
    % input sat is latitude, longitude and altitude of satellites
    %   with each satellite data in a row of these matrices
    % input xyz is matrix of satellite xyz locations (each sat in a row)
    % input xyzRec is row vector of xyz location of GPS receiver
    % input re is radius of spherical earth in meters
    % input degdel is angle (deg) above horizon that satellite must be in
    %   order to be in view 
    % output are row numbers of satellites in view of receiver
    %
    % uses trigonometric law of cosines
    % we know the lengths of all 3 sides of triangle defined by receiver, 
    % satellite, and earth center (coordinate origin), so we can solve for 
    % any angle - see reference on triangle solutions, e.g., 
    % https://www.ajdesigner.com/phptriangle/scalene_triangle_median_ma.php 
    
    % dRec contains distances from satellites to receiver at xyzRec
    dRec = fDistance(xyz,xyzRec);
    
    % dOrig contains distances from satellites to earth center (coord origin)
    dOrig = re + sat(:,3); 
    
    num = re^2 + dRec.^2 - dOrig.^2;
    denom = 2 * re * dRec;
    gamma = -90 + acosd(num ./ denom);
    
    % find and return satellite row numbers where gamma >= degdel
    rowView = find(gamma >= degdel)
    
  