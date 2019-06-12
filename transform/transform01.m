% make like from 0.25,0.25 to 0.25,0.75
g = [0.25 0.25
    0.25 0.75
    1 1];

% rotate about 0.25, 0.25 by 45 degree

% first, translate center of rotation to coord center
t = [1 0 -0.25
    0 1 -0.25
    0 0 1];

gp = t * g;

% rotate
th = -45; % degree 
r = [cosd(th)   -sind(th)   0
    sind(th)    cosd(th)    0
    0   0   1];

gp = r * gp;

% translate center of rotation back to orig coord
t = [1 0 0.25
    0 1 0.25
    0 0 1];

gp = t * gp;

% plot 
plot(g(1,:),g(2,:),'k');
axis([0 2 0 2])
hold on
plot(gp(1,:),gp(2,:),'b');

% translate origin of transformed fig to 0.5, 0.5
t = [1 0 0.5
    0 1 0.5
    0 0 1];

gp = t * gp;
plot(gp(1,:),gp(2,:),'g');

hold off



