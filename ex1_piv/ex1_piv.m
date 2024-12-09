
% requires installing image processing toolbox
% "Signal Processing Toolbox
% Statistics and Machine Learning Toolbox 
addpath(genpath('/usr/local/MATLAB/R2024b/bin/HydrolabPIV/src'));
addpath('/usr/local/MATLAB/R2024b/bin/HydrolabPIV/images');
javaaddpath('/usr/local/MATLAB/R2024b/bin/HydrolabPIV/src/measures');
javaaddpath('/usr/local/MATLAB/R2024b/bin/HydrolabPIV/src/interp');

% matlab -softwareopengl
% ver

im1 = imread('/home/anna/annaCode/MEK4600/Ex1_PIVlab/images/mpim1b.bmp');
im2 = imread('/home/anna/annaCode/MEK4600/Ex1_PIVlab/images/mpim1c.bmp');
coord_img = imread('/home/anna/annaCode/MEK4600/Ex1_PIVlab/images/mpwoco.bmp');


%-------------------- masking part

%{
figure;
imagesc(im1);
set(gca, 'YDir', 'normal')
h = impoly();
mask = h.createMask();
writematrix(mask, 'mask.txt', 'Delimiter', '\t');
%}
mask = readmatrix('mask.txt');

%-------------------- coordinate system mapping - pixel coordinates of reference system part

%{
figure;
imagesc(coord_img);
h=impoly;
pixel = h.getPosition;
writematrix(pixel, 'coord_points_pixels.txt', 'Delimiter', '\t');

%}
pixel = readmatrix('coord_points_pixels.txt');

% needed for transofrmation  
% from down row till right, row by row
world = [20 -10; 15 -10; 10 -10;5 -10;0 -10;
         20 -5;   15 -5; 10 -5; 5 -5; 0 -5]/100;


%64x64 subwindows
%0.5 50% overlap
% search range should be less than half of subwindow 
%opt = setpivopt('range',[-32 32 -32 32],'subwindow',64,64,.50);
%opt = setpivopt('range',[-16 16 -16 16],'subwindow',32,32,.50);
%opt = setpivopt('range',[-8 8 -8 8],'subwindow',16,16,.50);
%opt = setpivopt('range',[-20 20 -20 20],'subwindow',64,64,.50);
opt = setpivopt('range',[-20 20 -20 20],'subwindow',64,64,.50);

% normal pass - single pass piv
piv = normalpass([],im1,[],im2,[],opt);
[U,V,x,y] = replaceoutliers(piv,mask);

%piv = normalpass([],im1,mask,im2,mask,opt);
%idm = interp2(double(mask), piv.x, piv.y) == 1;

figure(1);
scale  = 5; % scale of vector in the quiver plot
%0 set to avoid scaling
quiver(x,y,scale*U,scale*V)


% transform to world coordinates
dt = 0.012; %[s] given
[tform,err,errinv] = createcoordsystem(pixel,world,'linear')
[Uw,Vw,xw,yw] = pixel2world(tform,U,V,x,y,dt);

%{
% plotting manual mask polygon - over the quiver plot
[idx1,eta] = max(mask);
[etax,etay] = tformfwd(tform,1:1280,eta);
figure;
quiver(xw,yw,Uw,Vw);
hold on;
plot(etax,etay,'r');
hold off;
xlabel('x coord [m]');
ylabel('y coord [m ]');
%}


% Stokes 2nd order wave model - all paremeters given as exercise
k = 7.95; % wave number 
amplitude = 0.0205; 
omega = 8.95;
ao = amplitude * omega
x_crest = 21;
depth = 0.6 % h

figure(2);
subplot(1,2,1)    
plot( ao*exp(k*yw(:,x_crest)), yw(:,x_crest), 'Color', [0 0 0.5])
hold on
scatter(Uw(:,x_crest),yw(:,x_crest), 10, 'red', 'filled')
title('Horizontal velocity profile taken at  x below the crest');
xlabel('u - horizontal velocity component [m/s] ');
ylabel('y - distance from surface [m]');

legend("Stokes wave model 2nd order", "PIV results")
grid on

subplot(1,2, 2)    
plot(exp(k*yw(:,x_crest)), yw(:,x_crest)/depth, 'Color', [0 0 0.5])
hold on
scatter(Uw(:,x_crest)/ao,yw(:,x_crest)/depth, 10, 'red', 'filled')
title('Horizontal velocity profile for x below the crest');
xlabel('u/(a * \omega) - non dimensionalized horizontal velocity component');
ylabel('y/h - non dimentional distance from surface');
legend("Stokes wave model 2nd order", "PIV results")
grid on
