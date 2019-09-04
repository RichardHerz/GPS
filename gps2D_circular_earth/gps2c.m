% simplified GPS 
% 2D system with circular earth, 2 satellites
% center of earth is at xe=ye=0 origin
%
% assume student does not know how to use arrays yet
%

clc

% BEGIN SETUP OF PROBLEM

re = 6370; % (km), radius of our circular earth
% use actual average radius = 6,370 kilometres (3,960 mi)
% per wikipedia https://en.wikipedia.org/wiki/Earth_radius

% pick angle on earth at which GPS receiver is located 
% this becomes an unknown (can compute from xi,yi) after setup
ai = 50 % degrees, equivalent to "longitude" looking down on earth

% get coordinates of GPS receiver
% these are what becomes the unknowns below after setting up problem
xi = re * cosd(ai)
yi = re * sind(ai)

% specify coordinates of two satellites
% must be outside earth circle
% and must be viewable by GPS receiver
x1 = re + 2550
y1 = 0
x2 = re + 2040
y2 = re + 2040

% or give angle and altitude of the two satellites
% instead of x,y locations
a1 = atand( y1 / x1 )
a2 = atand( y2 / x2 )

h1 = sqrt(x1^2 + y1^2) - re % altitude of satellite above earth circle
h2 = sqrt(x2^2 + y2^2) - re

% make sure can find x1,y1 and x2,y2 given a1, h1, a2, h2 
% (h1 + re)^2 = x1^2 + y1^2
% tand(a1) = x1/y1
% x1^2 = y1^2*tand(a1)^2
% (h1 + re)^2 = y1^2*tand(a1)^2 + y1^2 = y1^2 * (tand(a1)^2 + 1)
% y1^2 = (h1 + re)^2 / (tand(a1)^2 + 1) 
y1p = sqrt((h1 + re)^2 / (tand(a1)^2 + 1))
x1p = y1p * tand(a1)
y2p = sqrt((h2 + re)^2 / (tand(a2)^2 + 1))
x2p = y2p * tand(a2)

% compute radii of intersection of satellite circles and GPS receiver
r1sq = (xi - x1)^2 + (yi - y1)^2;
r2sq = (xi - x2)^2 + (yi - y2)^2;

r1 = sqrt(r1sq)
r2 = sqrt(r2sq)

% END SETUP

% GIVEN: xe=ye=0, re, x1, y1, x2, y2, r1, r2
% *OR* GIVEN: xe=ye=0, re, a1 (angle), h1 (altitude), a2, h2
% FIND: xi, yi >> then find angle of GPS receiver on earth circle

% r1^2 = (xi - x1)^2 + (yi - y1)^2
% r1^2 = (xi^2 + yi^2) + (x1^2 + y1^2) - 2*(x1*xi + y1*yi)
% note (xi^2 + yi^2) = re^2
% r1^2 = (re^2 + x1^2 + y1^2) - 2*(x1*xi + y1*yi)
%
% note r1^2 is NOT (x1^2 + y1^2) BUT (xi - x1)^2 + (yi - y1)^2
%
% (x1*xi + y1*yi) = c1 = ((re^2 + x1^2 + y1^2) - r1^2) / 2
% similar for satellite 2
% (x2*xi + y2*yi) = c2 = ((re^2 + x2^2 + y2^2) - r2^2) / 2

c1 = ((re^2 + x1^2 + y1^2) - r1^2)/2;
c2 = ((re^2 + x2^2 + y2^2) - r2^2)/2;

% matrix equation is A * xy = c
% solve for xy = [xi; yi] >> x,y location of GPS receiver
% this was specified above in setup of problem so check
A = [x1 y1; x2 y2];
c = [c1; c2];
xy = A \ c

% NOTE if student not at matrix solutions yet
% should be able to solve 2 equations in 2 unknowns by subsitution... 

% now compute angle of GPS receiver on earth's circle 
% and compare to setup angle
% tand(theta) = yi / xi 
ai = atand( yi / xi )

