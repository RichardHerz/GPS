% simplified GPS 
% 3D system with 3 or more satellites
% assumes earth is spherical with center at xyz = 0,0,0
% assumes receiver is on surface of earth
% assumes receiver clock synchronized
% with satellite clocks so minimum of 3 satellites needed 
% uses functions
%  fLatLongToXYZ, fXYZtoLatLong, fReturnSatViewRows, fDistance, fCcoeff

% BEGIN SETUP OF PROBLEM

clc
clear all

re = 6370; % (km), radius of our circular earth
% use actual average radius = 6,370 kilometres (3,960 mi)
% per wikipedia https://en.wikipedia.org/wiki/Earth_radius

% specify lat and long of receiver (altitude = 0)
% and 3 satellites (altitude > 0 & on order of 20,000 km)
% these move and are not geosynchronous 

% specify receiver latitude, longitude and altitude (altitude must == 0)
rec = [0,0,0];
[x,y,z] = fLatLongToXYZ(rec, re);
xyzRec = [x,y,z];

% specify >= 3 satellite latitude, longitude, altitude
sat = [0,0,20000
    20,35,22000
    -15,-10,19000
    -35,20,23000
    0,180,20000];

[r c] = size(sat);
fprintf('%i satellites TOTAL lat, long, alt: \n' , r)
fprintf('%4.0f, %4.0f, %4.0f \n',sat')
fprintf('\n')

% get x,y,z coordinates of satellites
[x, y, z] = fLatLongToXYZ(sat,re);
xyz = [x, y, z];

% [r c] = size(xyz);
% fprintf('%i satellites TOTAL xyz: \n', r)
% fprintf('%4.3e, %4.3e, %4.3e \n',xyz')
% fprintf('\n')

% get only satellites above horizon and in view of receiver
rView = fReturnSatViewRows(xyz,xyzRec);
xyz = xyz(rView,:);
sat = sat(rView,:);

[r c] = size(xyz);

% fprintf('%i satellites IN VIEW xyz: \n', r)
% fprintf('%4.3e, %4.3e, %4.3e \n',xyz')
% fprintf('\n')

fprintf('%i satellites IN VIEW lat, long, alt: \n', r)
fprintf('%4.0f, %4.0f, %4.0f \n',sat')
fprintf('\n')

% r's are distances from receiver at xyz(1,:) to satellites at xyz(n,:)
r = fDistance(xyz,xyzRec);

fprintf('satellite distances from receiver: \n')
fprintf('%4.3e \n',r)
fprintf('\n')

% END SETUP

% GIVEN:
% radius of spherical earth, re
% lat, long and altitude of >= 3 satellites
% distance of each satellite from receiver

% FIND:
%  lat and long of receiver on earth's surface
% matrix equation is A * xyz = c
A = xyz;
c = fCcoef(xyz,r,re);

% solve for xyzCalc = x,y,z location of GPS receiver
% this was specified above in setup of problem so check
% if A and c have 3 rows for 3 satellites, then xyzCalc = inv(A)*c may work
% if A and c have > 3 rows, then must use xyzCalc = A\c

% xyzCalc = inv(A) * c; % OK only for A and c rows == 3
xyzCalc = A \ c; % OK for A and c rows >= 3

fprintf('rec loc xyz, %4.3e, %4.3e, %4.3e,\n',xyzRec)
fprintf('rec cal xyz, %4.3e, %4.3e, %4.3e,\n\n', xyzCalc)

% NOW COMPUTE receiver lat and long
% note input argument xyzCalc' since xyzCalc is col vec and need row vec
[latCalc, longCalc, altCalc] = fXYZtoLatLong(xyzCalc', re);

fprintf('rec loc: lat, long, alt, %6.3f, %6.3f, %4.3e \n', rec)
fprintf('rec cal: lat, long, alt, %6.3f, %6.3f, %4.3e \n', latCalc, longCalc, altCalc)
