function c = fCcoef(xyz,r,re)
    % inputs r are distances from receiver at xyz(1,:) to satellites at xyz(n,:)
    % input re is radius of spherical earth
    % returns vector of coefficients for matrix solution 
    % option 2 for sum( ,2) sums each row
    
    c = ( (re^2 + sum(xyz.^2, 2) - r.^2) / 2 );
    
