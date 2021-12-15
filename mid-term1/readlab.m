function [meanv,stdv]= readlab()
clear;
clc;
%[data,t, fs] = normalizedAmplitude('/Users/dinhgiabao/Desktop/XLTinHieu/mid-term1/Tinhieuhuanluyen/phone_F1.wav');
%[data,t, fs] = normalizedAmplitude('/Users/dinhgiabao/Desktop/XLTinHieu/mid-term1/Tinhieuhuanluyen/phone_M1.wav');
%[data,t, fs] = normalizedAmplitude('/Users/dinhgiabao/Desktop/XLTinHieu/mid-term1/Tinhieuhuanluyen/studio_F1.wav');
%[data,t, fs] = normalizedAmplitude('/Users/dinhgiabao/Desktop/XLTinHieu/mid-term1/Tinhieuhuanluyen/studio_M1.wav');


[data,t, fs] = normalizedAmplitude('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/06FTB');
%[data,t, fs] = normalizedAmplitude('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/02FVA');
%[data,t, fs] = normalizedAmplitude('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/03MAB');
%[data,t, fs] = normalizedAmplitude('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/01MDA');




%sM1 = [0.87, 0.94, 1.26, 1.33, 1.59, 1.66, 1.78, 1.82, 2.06, 2.73];
%sF1 = [0.68, 0.70, 1.10, 1.13, 1.22, 1.27, 1.65, 1.70, 1.76, 1.79, 1.86, 1.92, 2.15, 2.86];
%pM1 = [0.46, 1.39, 1.50, 1.69, 1.79, 2.78, 2.86, 2.93, 3.10, 3.29, 3.45, 3.52];
%pF1 = [0.53, 1.14, 1.21, 1.35, 1.45, 1.60, 1.83, 2.20, 2.28, 2.35, 2.40, 2.52, 2.66, 2.73, 2.75];


%MDA = [0,1.52,1.92,3.91,4.35,6.18,6.6,8.67,9.14,10.94,11.33,12.75];
pF1=[0.00,0.83,1.37,2.09,2.60,3.57,4.00,4.76,5.33,6.18,6.68,7.18];
%MDA = [0,0.45,0.81,1.53,1.85,2.69,2.86,3.78,4.15,4.84,5.14,5.58];
%MAB =[0,1.03,1.42,2.46,2.80,4.21,4.52,6.81,7.14,8.22,8.50,9.37];


tmp=2;
tk=[];
for i = 1 : floor(length(pF1)/2)
    if(tmp>=length(pF1)-1)
        break
    end
    t1 = floor(pF1(tmp)*fs); 
    t2 = floor(pF1(tmp+1)*fs);
    x=data(t1:t2);
    
    %trave day_F0 co ban qua moi khung
    
    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    
    pdlow=1/450; pdhigh=1/70; 
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap

    n_min = floor(pdlow*fs);
    n_max = floor(pdhigh*fs);
    
    lenX = length(x); %do dai tin hieu vao thei mau
    nSampleFrame = time_duration*fs; %do dai 1 frame tinh theo mau
    nSampleLag = lag*fs; %do dai do dich cua frame theo mau
    
    %so_frame chia duoc
    nFrame= int32(lenX-nSampleFrame)/nSampleLag+1;
     
    %chia frame
    for frame_index=1:nFrame
        a=(frame_index-1)*nSampleLag+1;
        b=(frame_index-1)*nSampleLag+nSampleFrame+1;
        if b <= lenX
            frame= x(a:b); %xac dinh 1 frame
        else 
            frame= x(a:lenX);
            frame(lenX:b)=0;
        end
        
        max_global= sum(frame.*frame);
        %Ham tu tuong quan
        xxN=ACF(frame);

        %xac dinh vi tri max trong frame thoa nam tu mau n_min->n_max
        j=1;
        for index=n_min+1:n_max-1
            if xxN(index-1)<xxN(index) && xxN(index)>xxN(index+1) && xxN(j)<xxN(index)
                j=index;
            end
        end
  
        %thong ke tim nguong 
        %frame_F0(frame_index)=xxN(j)/max(x);
        tk =[tk xxN(j)/max_global];
    end
    tmp=tmp+2;
end

    meanv= mean(tk);
    stdv=std(tk);
    
end

%p_f1
%meanv 0.7520 stdv 0.125 => 0.7520-0.125=0.6375 =====> ~0.5
%meanuv 0.2494 stduv 0.1406 => 0.2494+0.1406=0.39


%p_m1
%meanv 0.6046 stdv 0.1181 => 0.6046-0.1181=0.4865 =====> ~0.46
%meanuv 0.3016 stduv 0.1394 => 0.3016+0.1394=0.441 

%s_f1
%meanv 0.2268 stdv 0.1079 => 0.3347 =====> ~0.5009
%meanuv 0.7607 stduv 0.0936 => 0.6671

%s_m1
%meanv  0.2507 stdv  0.1508  =>0.4015  =====> ~0.4237 
%meanuv 0.5715 stduv 0.1256  => 0.4459


%==================> nguong: 0.48




%01MDA
%meanv 0.625 stdv 0.1485 =>  ~0.4865
%meanuv 0.1406 stduv 0.1004 => ~0.241     ====> 0.35


%03MAB
%meanv 0.6046 stdv 0.1181 =====> ~0.5375        ===> 0.4
%meanuv 0.255 stduv 0.135 =>0.39

%02FVA
%meanv 0.2268 stdv 0.1079 =>~0.4015 ====> 0.4237
%meanuv 0.3607 stduv 0.0348 => 0.3359

%06FTB
%meanv  0.1839 stdv  0.2508  =>0.4347  =====> ~0.4009 
%meanuv 0.6715 stduv 0.1044  => 0.5671


%======> 0.35








