clear;
clc;
close all;
path='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/';
files = dir('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/abc/NguyenAmHuanLuyen/');
for i=3:23   
    p=strcat(path,files(i).name);
    p=strcat(p,'/');
    p1=strcat(p, '/*.wav');
    files1 = dir(p1);
    for j=1:length(files1)
        x = files(i).name + "/" + files1(j).name
        p2=strcat(p,files1(j).name);
        [data,fs]= audioread(p2);
        index = i*j + j;
        program(data, fs, index, x);
    end
end