% simplified GPS in MATLAB
% 3D system with 4 or more satellites
%
% receiver may be at positive altitude above Earth surface
%
% assumes earth is spherical with center at xyz = 0,0,0
% but altitude could later be corrected for nonspherical Earth
% in functions fLatLongToXYZ, fXYZtoLatLong
%
% assumes receiver clock *NOT* synchronized but *OFFSET*
% from satellite clocks so minimum of 4 satellites needed 
% uses functions
%  fLatLongToXYZ, fXYZtoLatLong, fReturnSatViewRows, fDistance, fGPS5_sse
%  
% uses data file sat.txt, which contains satellite locations 

% BEGIN SETUP OF PROBLEM

clc
clear all

re = 6370; % (km), radius of our spherical earth
% use actual average radius = 6,370 kilometres (3,960 mi)
% per wikipedia https://en.wikipedia.org/wiki/Earth_radius

% SPECIFY GPS receiver lat (deg), long (deg) & altitude (km)
% San Diego, CA, USA on ground is rec = [32.7,-117,0]; % deg, deg, km
% altitude of receiver here may be >= 0
rec = [32.7,-117,0];
[x,y,z] = fLatLongToXYZ(rec, re);
xyzRec = [x,y,z];

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
[x, y, z] = fLatLongToXYZ(sat,re);
xyz = [x, y, z];

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

% do nonlinear multi-variable fitting

% set initial guess g of results
% 0's did not work, 10's may work
[x,y,z] = fLatLongToXYZ([10,10,10],re);
g = [ [x,y,z], 10 ];

xyzCalc = fminsearch('fGPS5_sse', g, [], xyz, rMEAS);

% fminsearch is a standard MATLAB function
% fGPS5_sse is user-written function in file fGPS5_sse.m
% input [] selects default options, and is needed to also supply
% additional inputs to fGPS5_sse, which are xyz, rMEAS

% WITH CLOCK OFFSET, xyzCalc is now a 1x4 matrix = [x y z offSET]

% NOTE: xyzCalc in gps4 was 4x1 matrix

fprintf('rec loc xyz, %4.3e, %4.3e, %4.3e,\n',xyzRec)
fprintf('rec cal xyz, %4.3e, %4.3e, %4.3e,\n\n', xyzCalc(1:3))

fprintf('clock offset distance = %6.1f km \n\n',xyzCalc(4));

% NOW COMPUTE receiver lat and long
% note input argument xyzCalc' since xyzCalc is col vec and need row vec

[latCalc, longCalc, altCalc] = fXYZtoLatLong(xyzCalc(1:3), re);

fprintf('location:   lat, long, alt, %6.3f, %6.3f, %4.3e \n', rec)
fprintf('calculated: lat, long, alt, %6.3f, %6.3f, %4.3e \n', ...
    latCalc, longCalc, altCalc)

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