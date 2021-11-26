for looping =1:4
   % clear x frames;
   clearvars -except looping;
clc;
filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
files = {'01MDA', '02FVA', '03MAB', '06FTB'};
name = char(strcat(filePath, files(looping), '.wav'));


    [x,t1,fs]=normalizedAmplitude(name);
    

    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdlow=1/450; pdhigh=1/70; 
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap

    n_min = floor(pdlow*fs);
    n_max = floor(pdhigh*fs);

    lenX = length(x); %do dai tin hieu vao theo mau
    nSampleFrame = time_duration*fs; %do dai 1 frame tinh theo mau
    nSampleLag = lag*fs; %do dai do dich cua frame theo mau
    sec=length(x)/fs;
    
    nFrame= int32(lenX-nSampleFrame)/nSampleLag+1; %so frame chia duoc
    t=(1:nFrame)*fs/nSampleLag; %truc thgian
    
    ZCRarr=zeros(1,nFrame);
    STEarr=zeros(1,nFrame);
    VUframe = zeros(1,nFrame);
   
    
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
        
        %ZCR computing
        zcr=0;
        for  i = 2:nSampleFrame
            zcr = sum(abs(frame(i)-(frame(i-1))));
        end
        ZCRarr(frame_index)=zcr;

        
        %STE computing
        steButDividedBySams=sum(abs(frame.*frame))/nSampleFrame;
        STEarr(frame_index)=steButDividedBySams;   
    end
    
    
    %define VU
    for frame_index=1:nFrame
        a=(frame_index-1)*nSampleLag+1;
        b=(frame_index-1)*nSampleLag+nSampleFrame+1;
        if b <= lenX
            frame= x(a:b); %xac dinh 1 frame
        else 
            frame= x(a:lenX);
            frame(lenX:b)=0;
        end
        
       if STEarr(frame_index)>0.0283 && ZCRarr(frame_index) >0.37* max(ZCRarr)
           VUframe(frame_index)=1;
       end
       
    end
     
     ZCRarr= ZCRarr./max(ZCRarr);
     STEarr=STEarr./max(STEarr);
     x=x./max(x);
    
     
     
    figure;
    subplot(2,1,1); plot(t,STEarr,'g','LineWidth',2);
    hold on;
    plot(t,ZCRarr,'r','LineWidth',2);
    hold on;
    title('Zero-crossing rate (ZCR)');
    xlabel('Time axis');
    legend('Short-time energy', 'Zero-Crossing Rate');

    subplot(2,1,2);plot(t1,x);
    hold on;
    title('Short-time energy (STE)');
    xlabel('Time axis');
    ylabel('STE');
end

