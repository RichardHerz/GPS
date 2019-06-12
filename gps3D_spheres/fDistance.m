function d = fDistance(xyz1, xyz2)
    % returns distance between two points
    % xyz1 is array [x,y,z] of 1st point
    % xyz2 is array [x,y,z] of 2nd point
    % e.g., d = fDistance([1,0,0],[0,1,0])
    
    d = sqrt( sum( (xyz2 - xyz1).^2, 2 ) ); % option 2 sums each row 
    