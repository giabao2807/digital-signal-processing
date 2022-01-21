clear;
clc;
close all;
path='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/';
files = dir('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/');
numfilter=13;
k=8;

%trainnings
a=zeros(21,numfilter-1);
u=zeros(21,numfilter-1);
e=zeros(21,numfilter-1);
ii=zeros(21,numfilter-1);
o=zeros(21,numfilter-1);


for i=4:4
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
%         if (j==1)
%             a(i-3,:)=program(data, fs, index, x,numfilter);
%         elseif (j==2)
%             e(i-3,:)=program(data, fs, vindex, x,numfilter);
%         elseif (j==3)
%             ii(i-3,:)=program(data, fs, index, x,numfilter);
%         elseif (j==4)
%             o(i-3,:)=program(data, fs, index, x,numfilter);
%         elseif (j==5)
%             u(i-3,:)=program(data, fs, index, x,numfilter);
%         end 

        [v,v1]= program(data, fs, index, x,numfilter);
 
    end
end
