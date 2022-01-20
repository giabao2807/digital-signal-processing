function v= program (data, fs, index, name,numfilter,k) 

%cau1

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


% ======================== Cau2 ==========================
% 2a khung tin hieu co do on dinh
a = vu(1)*fs;
b = vu(2)*fs;
range = floor((b-a)/8);
newdata = data(a+range:b-range);


%2b,c trich xuat dac trung mfcc va tbc
v = my_mfcc(newdata,fs,numfilter,'',k);
