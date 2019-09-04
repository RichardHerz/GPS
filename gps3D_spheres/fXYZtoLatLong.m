function latLongAlt = fXYZtoLatLong(xyz,r) 
    % rows of input COLUMN VECTOR xyz are x, y, z coordinates of a location
    % input r is radius of spherical earth centered at 0,0,0
    % a is altitude of location above surface of earth 
    % North latitude 0 to +90 degrees 
    % South latitude 0 to -90
    % West longitude is 0 to -180
    % East longitude is 0 to +180 
    % conversion between latitude-longitude, spherical, and cartesian coordinates
    %   https://neutrium.net/mathematics/converting-between-spherical-and-cartesian-co-ordinate-systems/ 
    % longitude
    %   https://en.wikipedia.org/wiki/Longitude
    
    ra = sqrt(sum(xyz.^2, 1)); % distance from earth center
    % sum(  ,1) option 1 sums each column
    a = ra - r; % altitude above earth surface
    
    x = xyz(1);
    y = xyz(2);
    z = xyz(3);
      
    psi = asind(z ./ ra); % 90 - psi here == phi in fLatLongToXYZ 
    lat = psi;
    
    theta = atan2d(y, x);
    
    % NOTE that use of these FINDs eliminates need for a FOR repeat here 
    % although Matlab find function will use repeats 
     
    i = find(theta > 0);
    j = find(theta <= 0);
    
    long = zeros(size(theta)); % initialize
    long(i) = -theta(i);
    long(j) = 360 - theta(j);
    
    i = find(long >= 360);
    long(i) = long(i) - 360;
    
    latLongAlt = [lat, long, a]; % return as one matrix
        