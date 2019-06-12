% simple GPS
% 1D flat earth - a line
% 2 satellites in view
% know position (x,y) of each satellite, which are at different positions
% know distance of GPS receiver from each satellite
% FIND x coordinate of GPS receiver 
%
% assume student does not know how to use arrays yet
%
% TEST with x's on left of both satellites, in middle, on right of both 

clc 

x1 = 3.0;
y1 = 6.0; 
x2 = 10.0;
y2 = 8.0; 
xg = 6 % GPS receiver
yg = 0.0;

r1 = sqrt((xg-x1)^2 + y1^2);
r2 = sqrt((xg-x2)^2 + y2^2);

% now assume xg is not known and must be found 
% given x1,y1,r1,x2,y2,r2

% r1^2 = (xg-x1)^2 + y1^2, since yg = 0, (yg-y1)^2 = y1^2
% r2^2 = (xg-x2)^2 + y2^2
%
% xg^2 - 2*xg*x1 = c1 = r1^2 - (x1^2 + y1^2)
% xg^2 - 2*xg*x2 = c2 = r2^2 - (x2^2 + y2^2)
%
% subtract
% 0 - 2*xg*x1 + 2*xg*x2 = c1 - c2
% 
% xg = (c1 - c2) / (2*(x2-x1))

c1 = r1^2 - (x1^2 + y1^2);
c2 = r2^2 - (x2^2 + y2^2);
xg = (c1 - c2) / (2*(x2-x1))



