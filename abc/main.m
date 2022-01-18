clear;
clc;
close all;
path='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/';
files = dir('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/');
numfilter=26;

%trainnings
a=zeros(21,numfilter-1);
u=zeros(21,numfilter-1);
e=zeros(21,numfilter-1);
ii=zeros(21,numfilter-1);
o=zeros(21,numfilter-1);


for i=4:24
    p=strcat(path,files(i).name);
    p=strcat(p,'/');
    p1=strcat(p, '/*.wav');
    files1 = dir(p1);
    for j=1:length(files1)
        x = files(i).name + "/" + files1(j).name;
        p2=strcat(p,files1(j).name);
        [data,fs]= audioread(p2);
        index = (i-4)*j + j;
        
        %Trich xuat vecto theo tung nguyen am
        if (j==1)
            a(i-3,:)=program(data, fs, index, x,numfilter);
        elseif (j==2)
            e(i-3,:)=program(data, fs, index, x,numfilter);
        elseif (j==3)
            ii(i-3,:)=program(data, fs, index, x,numfilter);
        elseif (j==4)
            o(i-3,:)=program(data, fs, index, x,numfilter);
        elseif (j==5)
            u(i-3,:)=program(data, fs, index, x,numfilter);
        end 
    end
end

%TBC cac vecto
a=mean(a);
e=mean(e);
o=mean(o);
ii= mean(ii);
u= mean(u);


%testing
%Cau 3 so khop va xuat ket qua
mang = zeros(5,numfilter-1);
mang(1, :) = a;
mang(2, :) = e;
mang(3, :) = ii;
mang(4, :) = o;
mang(5, :) = u;

path_kt='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmKiemThu/';
files_kt = dir('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmKiemThu/');

result= zeros(5,5);
wrong_result = 0;
for i=4:24
    p=strcat(path,files(i).name);
    p=strcat(p,'/');
    p1=strcat(p, '/*.wav');
    files1 = dir(p1);
    for j=1:length(files1)
        x = files(i).name + "/" + files1(j).name;
        p2=strcat(p,files1(j).name);
        [data,fs]= audioread(p2);
        vecto =program(data, fs, index, x,numfilter);
        index= sokhop(files1(j).name ,vecto,mang);
        result(j, index) = result(j, index) + 1;
        if(j ~= index) wrong_result = wrong_result + 1;
        end
    end
end

nhan = {'a';'e';'i';'o';'u'};
a = result(:,1);
e =  result(:,2);
i =  result(:,3);
o =  result(:,4);
u =  result(:,5);
T = table(nhan,a,e,i,o,u)
Dochinhxac = (105 - wrong_result) * 100 / 105