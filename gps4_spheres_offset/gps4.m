% simplified GPS in MATLAB
% 3D system with 4 or more satellites
% assumes earth is spherical with center at xyz = 0,0,0
% assumes receiver is on surface of spherical earth
% assumes receiver clock *NOT* synchronized but *OFFSET*
% from satellite clocks so minimum of 4 satellites needed 
% uses functions
%  fLatLongToXYZ, fXYZtoLatLong, fReturnSatViewRows, fDistance, fCcoeff
% uses data file sat.txt, which contains satellite locations 
%
% NOTE: receiver on surface of spherical earth allows unique linear
% algebra solution with 4 satellites and receiver clock NOT sync'd to sats

% BEGIN SETUP OF PROBLEM

clc
clear all

re = 6370; % (km), radius of our spherical earth
% use actual average radius = 6,370 kilometres (3,960 mi)
% per wikipedia https://en.wikipedia.org/wiki/Earth_radius

% SPECIFY GPS receiver lat (deg), long (deg) and altitude (km, alt must == 0)
% San Diego, CA, USA is rec = [32.7,-117,0];
rec = [32.7,-117,0];
xyzRec = fLatLongToXYZ(rec,re);

% SPECIFY >= 4 satellite latitude (deg), longitude (deg), altitude (km)
% satellites move and are not geosynchronous 
% 31 listed in file sat.txt taken 1:30 pm, June 12, 2019 from data at
% https://in-the-sky.org/satmap_worldmap.php 
% listed in numbered order at site except no GPS 4 present on map
load sat.txt 

% SPECIFY CLOCK OFFSET DISTANCE = offset time * speed of light
% 1 nanosecond (ns) offset = approx. 1 foot = approx. 0.0003 km
% 3280 ns = approx. 1 km = 3.28 microsecond 
offSET = 100; % (km)

[r c] = size(sat);
fprintf('%i satellites TOTAL lat, long, alt: \n' , r)
% fprintf('%4.0f, %4.0f, %4.0f \n',sat')
fprintf('\n')

% get x,y,z coordinates of satellites
xyz = fLatLongToXYZ(sat,re);

[r c] = size(xyz);
% fprintf('%i satellites TOTAL xyz: \n', r)
% fprintf('%4.3e, %4.3e, %4.3e \n',xyz')
% fprintf('\n')

% get only satellites above horizon and in view of receiver
% degdel = minimum degree above horizon required for sat to be in view
degdel = 10; 
rView = fReturnSatViewRows(sat,xyz,xyzRec,re,degdel);

xyz = xyz(rView,:);

[r c] = size(xyz);

% fprintf('%i satellites IN VIEW xyz: \n', r)
% fprintf('%4.3e, %4.3e, %4.3e \n',xyz')
% fprintf('\n')
% 
fprintf('%i satellites IN VIEW lat, long, alt: \n', r)
fprintf('%4.0f, %4.0f, %4.0f \n',sat(rView,:)')
fprintf('\n')

% r's are distances from satellites in view in xyz to receiver at xyzRec
r = fDistance(xyz,xyzRec);

% OFFSET distances by constant offset between receiver clock and sats
% to obtain measured, apparent distances
rMEAS = r - offSET; 

% fprintf('satellite distances from receiver: \n')
% fprintf('%4.3e \n',r)
% fprintf('\n')

% END SETUP

% GIVEN:
% radius of spherical earth, re
% lat, long and altitude of >= 3 satellites
% distance of each satellite from receiver

% FIND:
% lat and long of receiver on earth's surface

% matrix equation for sphere intersections is A * xyzCalc = c
A = [xyz rMEAS]; % xyz of satellites
c = fCcoef(xyz,rMEAS,re);
% assume offset << sat distance to receiver (drop offSET^2 term) & 
% use same func fCcoef but now input rMEAS not r

% solve for xyzCalc = calculated xyz location of GPS receiver
% xyz location of GPS receiver was specified above in setup of problem
% if A and c have 4 rows for 4 satellites, then xyzCalc = inv(A)*c works
% if A and c have > 4 rows, then must use xyzCalc = A \ c

% xyzCalc = inv(A) * c; % OK only for A and c rows == 4
xyzCalc = A \ c; % OK for A and c rows >= 4

% WITH CLOCK OFFSET, xyzCalc is now a 4x1 matrix = [x; y; z; offSET]

fprintf('rec loc xyz, %4.3e, %4.3e, %4.3e,\n',xyzRec)
fprintf('rec cal xyz, %4.3e, %4.3e, %4.3e,\n\n', xyzCalc(1:3))

fprintf('clock offset distance = %6.1f km \n\n',xyzCalc(4));

% NOW COMPUTE receiver lat and long
latLongAltCalc = fXYZtoLatLong(xyzCalc, re);

fprintf('location:   lat, long, alt, %6.3f, %6.3f, %4.3e \n', rec)
fprintf('calculated: lat, long, alt, %6.3f, %6.3f, %4.3e \n', ...
    latLongAltCalc)

% now plot earth and at least one satellite 

[x,y,z] = sphere; % earth 
rep = 1; % re is radius of earth (m), rep is for plot 
rp = (r/re)*rep; % satellite distances from receiver for plot
C = 1.5*ones(size(z)); % use to generate alternative colormaps

% yellow 
C1 = C;
C1(1,1) = 0;
C1(21,21) = 1;

% blue 
C2 = C;
C2(1,1) = 0;
C2(21,21) = 10;

% red 
C3 = C;
C3(1,1) = -10;
C3(21,21) = 10;

% IF YOU SPECIFY 4th COLORMAP PARAM in surf & mesh FOR ANY OBJECTS THEN
% ALL OBJECTS IN SAME PLOT WITH 4th PARAM WILL GET SAME COLOR SCHEME 
% AS THE LAST ONE PLACED
% with no 4th param specified, that object will get default colormap
%
% info on how to get different color schemes on same 3D plot 
% https://www.mathworks.com/matlabcentral/answers/101346-how-do-i-use-multiple-colormaps-in-a-single-figure
% 

surf(rep*x,rep*y,rep*z, C2)
n = 4.2;
axis([ -n n -n n -n n ])
axis off
% colorbar

xyzp = xyz * (rep/re); % scale satellite xyz for sphere offsets
sp = 0.02; % scale factor for small sphere to represent satellite
[r c] = size(xyz);

% view(xyzp(1,:)) % along direction of one satellite xyzp(n,:)
view(-130,30) % azimuth angle (deg) from -y axis, elevation angle (deg)
view(160,30) % azimuth angle (deg) from -y axis, elevation angle (deg)

hold on 

% small sphere to represent GPS receiver on earth surface
spp = 6*sp;
mesh(spp*x+xyzRec(1)/re, spp*y+xyzRec(2)/re, spp*z+xyzRec(3)/re, C3)

for n = 1:r; % selected row numbers of satellites in view to plot
    
    % large sphere of radius of satellite to receiver
    if (n == 4) % ((n == 9) || (n == 8))
     mesh(rp(n)*x+xyzp(n,1),rp(n)*y+xyzp(n,2),rp(n)*z+xyzp(n,3)) 
    end
    
    % small sphere to represent satellites themselves
%     if (n == 4)
    mesh(sp*rp(n)*x+xyzp(n,1),sp*rp(n)*y+xyzp(n,2),sp*rp(n)*z+xyzp(n,3), C3)
    hidden off
%     end
    % from adding line to plot by hand and generating code:
    % but probably the xy are for xy projection for the view() specified
    % QUESTION - is there an option to use xyz?
    
%     annotation(figure(1), 'line', [0.511 0.303], [0.673 0.518]);

end

hold off
