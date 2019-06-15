% simplified GPS in MATLAB - receiver clock sync'd with satellites
re = 6370; % (km), earth radius

% specify GPS receiver latitude, longitude and altitude (altitude == 0)
rec = [32.7,-117,0]; % San Diego, CA, USA is [32.7,-117,0]
[x,y,z] = fLatLongToXYZ(rec, re);
xyzRec = [x,y,z]; % xyz coordinates of receiver, earth center is origin
 
% specify >= 3 satellite latitude (deg), longitude (deg), altitude (km)
% 31 listed in file sat.txt taken 1:30 pm, June 12, 2019 from data at
% https://in-the-sky.org/satmap_worldmap.php 
load sat.txt 
 
% get xyz coordinates of satellites
[x, y, z] = fLatLongToXYZ(sat,re);
xyz = [x, y, z];
 
% get satellites above horizon and in view of receiver
degdel = 10; % min degree above horizon for sat in view
rView = fReturnSatViewRows(sat,xyz,xyzRec,re,degdel);
xyz = xyz(rView,:);
r = fDistance(xyz,xyzRec); % sats to receiver
 
% END SETUP
 
% GIVEN:
% radius of spherical earth, re
% lat, long and altitude of >= 3 satellites
% distance of each satellite from receiver
 
% FIND:
% lat and long of receiver on earth's surface

% matrix eqn for sphere intersections is A * xyz = c
A = xyz;
c = fCcoef(xyz,r,re);
 
% xyzCalc = inv(A) * c; % OK only for A and c rows == 3
xyzCalc = A \ c; % OK for A and c rows >= 3
 
% compute receiver lat and long
[latCalc, longCalc, altCalc] = fXYZtoLatLong(xyzCalc', re);
 
fprintf('rec loc: lat, long, alt, %6.3f, %6.3f, %4.3e \n', rec)
fprintf('rec cal: lat, long, alt, %6.3f, %6.3f, %4.3e \n', ...
    latCalc, longCalc, altCalc)
