% tim x[2n] cho truoc x[n] co dang xung tam giac 
% (x[2n] la phien ban giam 1/2 tan so lay mau cua x[n])
clear; close all;
nL = -20; nR = 10;     % chi so bien trai & phai cua n
n = nL:nR;                  % sinh vecto chi so mau
minA = 0; maxA = 5;  % bien do min & max amplitue
x = [linspace(minA, maxA, abs(nL)), maxA, linspace(maxA, minA, nR)]; % sinh vecto bien do tin hieu

% dung vong lap for
x2 = zeros(1, length(x)); % khoi tao x[2n]

% i = 5:   x2[5]=x[10]   <-> x2(26)=x(31)
% ....
% i =   1: x2[1] =x[2]    <-> x2(22)=x(23)
% i =   0: x2[0] =x[0]    <-> x2(21)=x(21)
% i = -1: x2[-1]=x[-2] <-> x2(20)=x(19)
% ....
% i = -10: x2[-10]=x[-20] <-> x2(11)=x(1)
for i = nL/2:nR/2
    x2(abs(nL) + 1 + i) = x(abs(nL) + 1 + 2*i);   % x2[i] = x[2*i]                                        
end
subplot(2,1,1);
stem(n, x, 'fill'); xlabel('Sample index n'); ylabel('x[n]');
subplot(2,1,2);
stem(n, x2, 'fill'); xlabel('Sample index n'); ylabel('x[2n]');
