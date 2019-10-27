% GPS from Low Earth Orbit LEO satellites such as Iridium system
% relies on Doppler shift of signal from fast moving satellite transmitter
% relative to GPS receiver station

% ASSUME: GPS station on surface of flat earth
% ASSUME: satellite track parallel to surface of flat earth
% https://en.wikipedia.org/wiki/Doppler_effect#Satellite_communication 

% NOTE: full solution will require doppler shift as function of 
% ground station altitude above curved earth and curved sat orbit

% NOTE: need intersections of two (GPS station on flat ground) or more 
% doppler shift surfaces to locate position of GPS station on/above earth

% KNOWN to ground station
% satellite lat and long and altitude transmitted from satellite 
% satellite track on ground 
% doppler shift of satellite signal

sa = 850; % km satellite altitude 

%% GET STARTED 

g1 = 500; % km, GPS station along normal to sat track projected to earth 
g2 = 600; % km, g1 intersect at sat track to sat loc projected to earth

ag1 = atand(g2/g1)
ag2 = 90-ag1
g3 = sqrt(g1^2+g2^2)
ah1 = atand(sa/g3); % angle phi in wikipedia 
h3 = sqrt(g3^2+sa^2)

phi = ah1
theta = 90 - ag1 

% observed freq = freq * shift factor, sf
% sf = wave veloc rel receiver / wave veloc rel source 
% sf = (1/h3)/(1/g2) but rearrange to avoid div by zero
% since g2 can be zero but h3 > 0
sf = g2/h3

% shift factor due to ground station moving is
% shift factor is cos(phi)*cos(theta) per wikipedia
% sf2 = cosd(phi)*cosd(theta)
% which is same factor as above for satellite 
% cosd(phi) = g3/h3
% cosd(theta) = g2/g3
% sf2 = g2/h3

% APPARENTLY THIS FACTOR IS APPLIED TO THE DOPPLER SHIFT FREQ
% WHICH IS ADDED/SUBTRACTED FROM THE SOURCE FREQUENCY

%% FIND LINES OF CONSTANT DOPPLER SHIFT

% GPS ground statinon, knowing Doppler shift from one satellite and 
% location and trajectory of that satellite can compute the 
% line of constant shift on which it lies.
% Then, from line of constant shift from one or more other satellites 
% can get intersection of lines and the location of the ground station 

% HERE specify g2 and compute g1
% ALTERNATIVELY can specify g1 and compute g2

for sf = 0.2:0.1:0.8

    % min g2 for h3 approaches sa is g2 approaches sf * sa
    g2min = 1.1 * sf * sa; 
    d = 1;
    g2max = 2000;
    g2 = g2min:d:g2max;

    h3 = g2 ./ sf;
    phi = asind(sa ./ h3);
    g3 = h3 .* cosd(phi);
    theta = asind(g2 ./ g3);
    g1 = g3 .* cosd(theta);

    plot(g1,g2)
    hold on

end
hold off
% NOTE: these curves may be hyperbolic?
axis([0 2000 0 3000])
title('lines of constant Doppler shift under LEO satellite')
ylabel('g2 = direction of satellite travel')
xlabel('g1 = direction normal to satellite travel')
