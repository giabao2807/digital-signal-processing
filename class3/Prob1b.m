% tim x[2n] cho truoc x[n] co dang xung tam giac 
% (x[2n] la phien ban giam 1/2 tan so lay mau cua x[n])
clear; close all;
nL = -20; nR = 10;     % chi so bien trai & phai cua n
minA = 0; maxA = 5;  % bien do min & max amplitue
x = [linspace(minA, maxA, abs(nL)), maxA, linspace(maxA, minA, nR)]; % sinh vecto bien do tin hieu

x2 = zeros(1, fix(length(x)/2)); % khoi tao x[2n] co do dai bang 1/2 cua x[n]
for i = 1:length(x2)
    x2(i) = x(2*i - 1); % x2[i] = x[2*i] 
end

subplot(2,1,1);
stem(x, 'fill'); xlabel('Sample index n'); ylabel('x[n]');
subplot(2,1,2);
stem(x2, 'fill'); xlabel('Sample index n'); ylabel('x[2n]');
