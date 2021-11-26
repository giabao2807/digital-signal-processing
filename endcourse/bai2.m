for looping =1:4
   % clear x frames;
   clearvars -except looping;
clc;
filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
files = {'01MDA', '02FVA', '03MAB', '06FTB'};
name = char(strcat(filePath, files(looping), '.wav'));


    [x,fs]=audioread(name);

    N=32768;
    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdlow=1/450; pdhigh=1/70; 
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap

    n_min = floor(pdlow*fs);
    n_max = floor(pdhigh*fs);

    lenX = length(x); %do dai tin hieu vao theo mau
    nSampleFrame = time_duration*fs; %do dai 1 frame tinh theo mau
    h=hamming(nSampleFrame); 
    nSampleLag = lag*fs; %do dai do dich cua frame theo mau
    sec=length(x)/fs;
    
    nFrame= int32(lenX-nSampleFrame)/nSampleLag+1; %so frame chia duoc
    t=(1:nFrame)*fs/nSampleLag; %truc thgian
    
    F0_frame=zeros(1,nFrame);
    
    %normalized
    max_value = max(abs(x)); %tim bien do lon nhat cua tin hieu duoc doc
    x= x/max_value; %dua bien do cua tin hieu ve vecto co tin hieu cao nhat 
    
    
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
        
       
        
        dfty= abs(fft(frame,N));
        dfty1= dfty(1:length(dfty)/2 + 1);
        
        dftylog=10*log10(dfty);
        dftylog1 = 10*log10(dfty1);
        
        
    end
     
    figure;
    subplot(3,1,1);

    plot(dftylog);
    title('Zero-crossing rate (ZCR)');
    xlabel('Time axis');
    ylabel('ZCR');

    subplot(3,1,2);
    plot(dftylog1);
    title('Short-time energy (STE)');
    xlabel('Time axis');
    ylabel('STE');
    
    subplot(3,1,3);
    plot(x);
end

