% % hyperbola parametric
% a = 1;
% b = 1;
% t = -0:0.001:0.1;
% x = a*cosh(t);
% y = b*sinh(t);
% xn = a*cosh(t);
% plot(x,y,xn,y)
% % axis([1.00 1.005 -0.1 0.1])

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

% specify satellite latitude, longitude, altitude
% for hyperbola development, use 2 satellites at 0 latitude
sat = [0,20,20000
	0,-20,22000];

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

fprintf('distance between two satellites')
sd = fDistance(xyz(1,:),xyz(2,:))
fprintf('difference in distance between receiver & two satellites')
dd = r(1) - r(2)

plot(xyz(1,1),xyz(1,2),'bx',xyz(2,1),xyz(2,2),'kx',xyzRec(1,1),xyzRec(1,2),'ko')
axis([0,30000,-30000,30000])

hold on
% plot earth circle
t = -pi:0.01:pi;
x = re * cos(t);
y = re * sin(t);
plot(x,y)

hold off

% get hyperbola from affine transformation of unit hyperbola
% https://en.wikipedia.org/wiki/Hyperbola#Hyperbola_as_an_affine_image_of_the_unit_hyperbola_x%C2%B2_%E2%80%93_y%C2%B2_=_1
% 
% need xyz coordinates of midpoint between the 2 satellites 
xyzMid = xyz(1,:) + 0.5*(xyz(2,:) - xyz(1,:))

% f0 is vector from earth center to midpoint
f0 = xyzMid;

% f0 vector + f1 vector is a point on the hyperbola, i.e. the receiver 
% p = f0 + f1
% f1 = p - f0

f1 = xyzRec - f0;

% f2 is a vector tangent to the hyperbola at the receiver 

% ??? may have to do affine transform to move the two foci and receiver
% to coord system with hyperbola origin at earth origin, 
% then use formulas to get a, b, c for hyperbola... 




