[data1, fs1] = audioread('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/TH1/NguyenAmHuanLuyen/01MDA/a.wav');
%[data2, fs2] = audioread('E:\Year3\Semester1\TH XL tin hieu\NguyenAmHuanLuyen-16k\01MDA\e.wav');
%[data3, fs3] = audioread('E:\Year3\Semester1\TH XL tin hieu\NguyenAmHuanLuyen-16k\01MDA\i.wav');
%[data4, fs4] = audioread('E:\Year3\Semester1\TH XL tin hieu\NguyenAmHuanLuyen-16k\01MDA\o.wav');
%[data5, fs5] = audioread('E:\Year3\Semester1\TH XL tin hieu\NguyenAmHuanLuyen-16k\01MDA\u.wav');

t = 0 : 1/fs1 : length(data1)/ fs1 - 1/fs1 ;
figure(1);
subplot(2, 1, 1);  plot(t, data1); xlabel('Time (s)');
subplot(2, 1, 2);
spectrogram(data1, 0.005 * fs1, 0.002 * fs1, 1024, fs1, 'yaxis');

% ==================================================%
s1 = data1(8000 : 8479); t1 = (0:length(s1) - 1) / fs1;
figure(2);
subplot(2, 1, 1); plot(t1, s1); 
u = filter([1, -.99], 1, s1);
wlen = length(u);
cepstL = 15;
wlen2 = wlen/2;
freq = (0:wlen2-1) * fs1 / wlen;
u2 = u.*hamming(wlen);
subplot(2,1,2);
plot(t1, u2);

% =======================================================% 
fft1 = fft(u2, 1024);
fft2 = fft1(1 : length(fft1) / 2);
figure(3);
C = 0.03 / 1024;
t2 = (1: 1024) * C; 
subplot(3, 1, 1); plot(t2, fft1);

% =========================================================%
lft1 = log(fft2);
D = fs1 /  1024;
t3 = (1 : 512) * D;
subplot(3, 1, 2); plot(t3, lft1);

% =========================================================%
ifft1 = ifft(lft1);
E =  480 / 1024;
t4 = (1: 512) * E;
subplot(3, 1, 3); plot(t4, ifft1);