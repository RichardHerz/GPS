% Examples of transformations of 3D graphic objects
% ReactorLab.net 2019 

% uses user-written function fMakePatch3D 

% also see https://www.cs.brandeis.edu/~cs155/Lecture_07.pdf 
% which is outline #7 at https://www.cs.brandeis.edu/~cs155/ 

clc
clear all

%% define original 3D object 

p = []; % initialize point matrix

% each point in the point matrix will be a column: x; y; z; 1

% NOTE this form allows the object to be transformed by matrix
%      multiplying a transformation matrix times the object 
%      point matrix, where transformations include translation, 
%      rotation, scaling, and shearing

% NOTE the last element "1" allows a constant to be added to any of
%      the xyz directions in order to translate a point when a
%      transformation matrix is multiplied times the point matrix 

% in this example, we will generate an object using only triangles 
% in our point matrix, each three columns defines a triangle
% we will enter 4 triangles to make a tetrahedron

% enter first triangle's vertex points 

% may be easier to first enter each xyz point in a row...
t = [0 0 0
    1 0.5 0
    0 1 0];
% then invert and augment with a row of 1's
t = [t'; 1 1 1];

% finally, augment previous point matrix with new triangle
p = [p t];

% enter 3 more triangles to complete 4 faces of our tetrahedron

t = [0 0.5 0; 0 0.5 1; 0 1 0; 1 1 1]; p = [p t];
t = [0 0.5 1; 1 0.5 0.5; 0 1 0; 1 1 1]; p = [p t];
t = [0 0.5 1; 0 0.5 0.5; 0 1 0; 1 1 1]; p = [p t];

% NOTE when making connected polygons, many points will be repeated,
%      so there is a more efficient way of generating objects: 
%         specify each vertex only once and display using
%         patch('Faces',F,'Vertices',V) 

%% display object 

% generate a vector to specify colors of the object's faces
% vector should have as many elements as our polyhedron has triangles
[row col] = size(p);
% should be 4 rows and integer multiple of 3 columns for triangles
np = col/3;
% here use values which are equally spaced across colormap
c = linspace(0,1,np);

colormap(jet)
fMakePatch3D(p,c) 
% see listing of user-written function fMakePatch3D below
n = 3;
axis([ -n n -n n -n n ])
xlabel('x axis'); ylabel('y axis'); zlabel('z axis')

% set angles of view of 3D axes
% view(az,el) inputs two angles in degrees: azimuth, elevation
% view(3) is default 3D view of az = ?37.5, el = 30
view(3)

%% translate object

% here, translate in one direction at a time
% but can do in multiple directions with same matrix
dir = 1; % direction, 1 = x, 2 = y, 3 = z
dist = 1.5; % distance

% generate translation transformation matrix
mTr = eye(4);
mTr(dir,4) = dist;

% make copy of object so we can see both original and translated 
pp = p;

% translate copy by multiplying transform matrix times object matrix
pp = mTr * pp;

% add translated copy to axes
fprintf('object on left is original \n')
fprintf('copy on right is original translated in x-direction \n')
fMakePatch3D(pp,c)

%% rotate original object

th = 180; % angle of rotation (here in degrees) 
mRot = eye(4);
mRot(2,2) = cosd(th); % use cosd, etc., when using degrees
mRot(2,3) = -sind(th);
mRot(3,2) = sind(th);
mRot(3,3) = cosd(th);

pp = p;
pp = mRot * pp;

fprintf('object on left is original \n')
fprintf('copy on right is original translated in x-direction \n')
fprintf('copy on bottom is original rotated %i° about x-axis \n\n',th)
fprintf('by using successive transformations, \n')
fprintf('we can move the object along any desired path\n')

fMakePatch3D(pp,c)

%% listing of user-written function fMakePatch3D 

type fMakePatch3D
