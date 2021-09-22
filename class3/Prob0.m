% Prob 0
n = -10:10;                                     % sinh vecto thoi gian roi rac
u = [zeros(1,10), 1, ones(1,10)];       % sinh u[n] co cung do dai voi n
up1 = [u(2:length(u)), 1];                 % sinh u[n+1] la phien ban som (dich trai) 1 mau so voi u[n]
um5 = [zeros(1,5), u(1:length(u)-5)]; % sinh u[n-5] la phien ban tre (dich phai) 5 mau so voi u[n]
x1 = up1 - um5;
% ve do thi u, up1, um5 va x1 tren cung 01 figure
figure(1);
subplot(4,2,1); stem(n, u, 'fill'); xlabel('Sample index n'); ylabel('u[n]');
subplot(4,2,2); stem(n, up1, 'fill'); xlabel('Sample index n'); ylabel('u[n+1]');
subplot(4,2,3); stem(n, um5, 'fill'); xlabel('Sample index n'); ylabel('u[n-5]');
subplot(4,2,4); stem(n, x1, 'fill'); xlabel('Sample index n'); ylabel('x1[n]');

u0m = flip(u); % sinh u[-n] la phien ban dao thoi gian cua u[n]
u2m = [ones(1,2) u0m(1:length(u0m)-2)]; % sinh u[2-n] la phien ban tre (dich phai) 2 mau so voi u[-n]
x2 = n .* u2m;
x = x1 .* x2; % nhan 2 vecto x1 va x2 point-by-point
% ve do thi u0m, u2m, x2, x tren cung 01 figure
subplot(4,2,5); stem(n, u0m, 'fill'); xlabel('Sample index n'); ylabel('u[-n]');
subplot(4,2,6); stem(n, u2m, 'fill'); xlabel('Sample index n'); ylabel('u[2-n]=u[-(n-2)]');
subplot(4,2,7); stem(n, x2, 'fill'); xlabel('Sample index n'); ylabel('x2[n]');
subplot(4,2,8); stem(n, x, 'fill'); xlabel('Sample index n'); ylabel('x[n]');