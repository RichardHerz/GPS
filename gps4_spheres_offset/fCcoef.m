function c = fCcoef(xyz,r,re)
    % input xyz are locations of satellites (each row is one satellite) 
    % input r are distances from satellites to receiver
    % input re is radius of spherical earth
    % returns vector of coefficients for matrix solution 
    % option 2 for sum( ,2) sums each row
    
    c = ( (re^2 + sum(xyz.^2, 2) - r.^2) / 2 );
    
