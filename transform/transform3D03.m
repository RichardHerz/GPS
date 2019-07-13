% get started

% close

cla % clear objects off current axes

clc
p = []; % initialize point matrix

% assume all polygon faces are triangles defined by three points

% define points for one triangle
% each point is a column: x; y; z; 1
pp = [0 1 0
    0 0.5 1
    0 0 0
    1 1 1];
% concatenate to previous point matrix
p = [p pp];

pp = [0 0.5 0
    0 0.5 1
    0 1 0
    1 1 1];
p = [p pp];

pp = [0 0.5 1
    1 0.5 0.5
    0 1 0
    1 1 1];
p = [p pp];

pp = [0 0.5 1
    0 0.5 0.5
    0 1 0
    1 1 1];
p = [p pp];

% this cs should have as many rows as triangles
[row col] = size(p);
% should be 4 rows and integer multiple of 3 columns for triangles
np = col/3;
c = linspace(0,1,np);

colormap(jet)
fMakePatch3D03(p,c)
n = 3;
axis([ -n n -n n -n n ])

view(3) % or 2 angles

% colorbar

ps = 1; % pause seconds

% translate

d = 1; % direction, 1 = x, 2 = y, 3 = z
mTr = eye(4);
mTr(d,4) = 1.5;

p = mTr * p;
pause(ps)
% cla
fMakePatch3D03(p,c)

% rotate about x axis

th = 180;
mRotX = eye(4);
mRotX(2,2) = cosd(th);
mRotX(2,3) = -sind(th);
mRotX(3,2) = sind(th);
mRotX(3,3) = cosd(th);

p = mRotX * p;
pause(ps)
% cla
fMakePatch3D03(p,c)

% rotate about y axis

th = -120;
mRotY = eye(4);
mRotY(1,1) = cosd(th);
mRotY(1,3) = -sind(th);
mRotY(3,1) = sind(th);
mRotY(3,3) = cosd(th);

p = mRotY * p;
pause(ps)
% cla
fMakePatch3D03(p,c)

% rotate about z axis

th = 90;
mRotZ = eye(4);
mRotZ(1,1) = cosd(th);
mRotZ(1,2) = -sind(th);
mRotZ(2,1) = sind(th);
mRotZ(2,2) = cosd(th);

p = mRotZ * p;
pause(ps)
% cla
fMakePatch3D03(p,c)

hold off