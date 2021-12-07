for looping =1:4
   % clear x frames;
   clearvars -except looping;
clc;
filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
files = {'01MDA', '02FVA', '03MAB', '06FTB'};
name = char(strcat(filePath, files(looping), '.wav'));

    [x,t1,fs]=normalizedAmplitude(name);

    N=32768;
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap
    
    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdlow=1/450; pdhigh=1/70; 
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap

    n_min = floor(pdlow*fs);
    n_max = floor(pdhigh*fs);

    lenX = length(x); %do dai tin hieu vao theo mau
    nSampleFrame = time_duration*fs;%do dai 1 frame tinh theo mau
     h=hamming(nSampleFrame); 
    nSampleLag = lag*fs; %do dai do dich cua frame theo mau

    
    nFrame= int32((lenX-nSampleLag)/(nSampleFrame-nSampleLag))+1;%so frame chia duoc
    t=(1:nFrame)*2*fs/nSampleLag; 
    
    F0_frame=zeros(1,nFrame);
    
    
    %chia frame
   for frame_index=1:nFrame
        a=(frame_index-1)*(nSampleFrame-nSampleLag)+1;
        if(frame_index ==1)
             b=(frame_index)*nSampleFrame+1;
        else
            b=(frame_index)*nSampleFrame - (frame_index-1)*nSampleLag +1;
        end
        if b < lenX
            frame= x(a:b); %xac dinh 1 frame
        else 
            frame= x(a:lenX);
            frame(lenX:b)=0;
        end
        
        
       
        
        dfty= abs(fft(frame,N));
        dfty1= dfty(1:length(dfty)/2 + 1);
        
        dftylog=10*log10(dfty);
        dftylog1 = 10*log10(dfty1);
        
        xxN=zeros(1,n_max-n_min+1);
        dem=1;
        for n=n_min:n_max
        xxN(dem)=dfty1(n);
        dem=dem+1;
        end
        
        framepeak=zeros(1,n_max-n_min+1);
        %xac dinh vi tri h?i trong frame thoa nam tu mau n_min->n_max
        j=1;
        for index=2:length(xxN)-1
            if xxN(index-1)<xxN(index) && xxN(index)>xxN(index+1)
                framepeak(j)=index;
                j=j+1;
            end
        end
        
      %khoachcach
%        F0frame = zeros(1:3);
%        for j=1:3
%            F0frame = xxN(framepeak(j+1))/framepeak(j+1)-xxN(framepeak(j))/framepeak(j);
%        end
       
       %T0 chu k?
      % F0_frame(frame_index) = sum(F0frame)/3;
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
    stem(F0_frame);
end

