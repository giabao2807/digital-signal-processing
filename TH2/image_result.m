function image_result()
close all;
path = '/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/01MDA/e.wav';
[data,fs]= audioread(path);
numfilter =26;
    
    
    
framelength = 0.02;
fsample = round(framelength * fs); nframe = floor(length(data) / fsample);
frames = DevideFrame(data, nframe, fsample);

ste = STE(frames, nframe);
ma = MA(frames, nframe);

%chuan hoa
ste = ste./max(ste);
ma = ma./max(ma);
data = data./max(abs(data));


%nguong
zSte = 0.1;
zMa = 0.4;

%b1
% tim phan vung voice silence
vu01 = zeros(1,nframe);
for i = 1 : nframe
    if (ste(i) > zSte || ma(i) > zMa)
        vu01(i) = 1;
    end
end
count = 1;
vu = [];
for j = 2 : nframe - 1
    if (vu01(j) ~= vu01(j-1) && vu01(j) == vu01(j+1))
        if (vu01(j) == 0 && isSL(vu01, j) == 0)
            continue;
        end
        vu(count) = j * 0.02; 
        count = count + 1;
    end
end

%ve do thi cau 1
 figure('name', 'Speech and Silence');
 t = 0 : 1/fs : (length(data)-1)/fs; 
 t1 = (0 : (nframe - 1)) * 0.02;
 
 subplot(2,1,1);title('STE & MA');
 plot(t,data); hold on;
 plot(t1,ste,'r-','LineWidth',2); hold on;
 plot(t1,ma,'g-','LineWidth',2);
 ylabel('Bien do'); xlabel('Thoi gian(s)');
 legend('STE', 'MA');
 
 subplot(2, 1, 2);title('Voiced && Silence');
 plot(t, data);hold on;
 ylabel('Bien do'); xlabel('Thoi gian(s)');
for i = 1 : length(vu)
    plot([1, 1] * vu(i), ylim, 'r--','LineWidth', 2);
   vu(i);
end

legend('Input', 'Output');


% ======================== Cau2 ==========================
% 2a khung tin hieu co do on dinh
a = vu(1)*fs;
b = vu(2)*fs;
range = floor((b-a)/3);
newdata = data(a+range:b-range);


%2b,c trich xuat dac trung mfcc va tbc
v = my_mfcc(newdata,fs,numfilter,'image');

end