clear all 

% make orig fig, x's in row 1, y's in row 2
g = [0 0 1 0
    0 1 0 0
    1 1 1 1];

plot(g(1,:),g(2,:),'k');
axis([0 2 0 2])

hold on

% rotate
th = 20; % degree 
r = [cosd(th)   -sind(th)   0
    sind(th)    cosd(th)    0
    0   0   1];

gp = r * g;
plot(gp(1,:),gp(2,:),'b');

% translate to new origin
t = [1 0 0.5
    0 1 0.5
    0 0 1];

gp = t * gp;
plot(gp(1,:),gp(2,:),'g');

hold off

plot(gp(1,:),gp(2,:),'g');
axis([0 2 0 2])

hold on

% now go back to original position

% translate
t = [1 0 -0.5
    0 1 -0.5
    0 0 1];

gp = t * gp;
plot(gp(1,:),gp(2,:),'b');

% rotate
th = -20; % degree 
r = [cosd(th)   -sind(th)   0
    sind(th)    cosd(th)    0
    0   0   1];

gp = r * gp;
plot(gp(1,:),gp(2,:),'k');

hold off
