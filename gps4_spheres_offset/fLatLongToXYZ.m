function [x,y,z] = fLatLongToXYZ(latLongAlt, r) 
    % rows of input latLongAlt are latitude, longitude, altitude above
    %   earth surface
    % input r is radius of spherical earth centered at 0,0,0 
    % North latitude 0 to +90 degrees 
    % South latitude 0 to -90
    % West longitude is 0 to -180
    % East longitude is 0 to +180 
    % conversion between latitude-longitude, spherical, and cartesian coordinates
    %   https://neutrium.net/mathematics/converting-between-spherical-and-cartesian-co-ordinate-systems/ 
    % longitude
    %   https://en.wikipedia.org/wiki/Longitude
    
    lat = latLongAlt(:,1);
    long = latLongAlt(:,2);
    a = latLongAlt(:,3);
    
    ra = r + a; % ra = distance of point from center of earth
    phi = 90 - lat;
    
    % NOTE that use of these FINDs eliminates need for a FOR repeat here 
    % although Matlab find function will use repeats
    
    i = find(long < 0);
    j = find(long >= 0);
    
    theta = zeros(size(long)); % initialize
    theta(i) = -long(i);
    theta(j) = 360 - long(j);
    
    x = ra .* sind(phi) .* cosd(theta);
    y = ra .* sind(phi) .* sind(theta);
    z = ra .* cosd(phi);
    
