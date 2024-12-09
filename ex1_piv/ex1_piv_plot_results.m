
k = 7.95; % wave number 
amplitude = 0.0205; 
omega = 8.95;
ao = amplitude * omega
x_crest = 26;
depth = 0.6 % h

figure(2);
x_crest = 20
subplot(1,2,1)    
plot( ao*exp(k*yw(:,x_crest)) *sin(k *xw(1, x_crest)), yw(:,x_crest), 'Color', [0 0 0.5])
hold on
plot( ao*exp(k*yw(:,x_crest)) *sin(k *x_crest), yw(:,x_crest), 'Color', [0.5 0.5 0.5])
hold on
scatter(Vw(:,x_crest),yw(:,x_crest), 10, 'red', 'filled')
title('Vertical velocity profile for x below the crest');
xlabel('v - horizontal velocity component [m/s] ');
ylabel('y - distance from surface [m]');
legend("Stokes wave model 2nd order", "PIV results")
grid on
subplot(1,2,2)    
plot( exp(k*yw(:,x_crest)) *sin(k *xw(1,x_crest)), yw(:,x_crest)/depth, 'Color', [0 0 0.5])
hold on
scatter(Vw(:,x_crest)/ao,yw(:,x_crest)/depth, 10, 'red', 'filled')

%scatter(abs(Vw(:,x_crest))/ao,yw(:,x_crest)/h, 10, 'red', 'filled')
title('Vertical velocity profile for x below the crest');
xlabel('u/(a * \omega) - non dimensionalized vertical velocity component');
ylabel('y/h - non dimentional distance from surface');
legend("Stokes wave model 2nd order", "PIV results")
grid on

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
