for looping =1:4
   % clear x frames;
   clearvars -except looping;
clc;
filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
files = {'01MDA', '02FVA', '03MAB', '06FTB'};
name = char(strcat(filePath, files(looping), '.wav'));

    [x,t1,fs]=normalizedAmplitude(name);

    N=2000;
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap
    
    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdhigh=450; pdlow=70; 
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap

     n_min = floor(fs/450);
     n_max = floor(fs/70);

    lenX = length(x); %do dai tin hieu vao theo mau
    nSampleFrame = round(time_duration*fs);%do dai 1 frame tinh theo mau
    h=hamming(nSampleFrame) ;
    nSampleLag = round(lag*fs); %do dai do dich cua frame theo mau

     
    %so_frame chia duoc
    nFrame= int32(lenX-nSampleFrame)/nSampleLag+1;
    t=(1:nFrame)*fs/nSampleLag;
    frame_F0=zeros(1,nFrame);
    
     %chia frame
    for frame_index=1:nFrame
        a=(frame_index-1)*nSampleLag+1;
        b=(frame_index-1)*nSampleLag+nSampleFrame;
        if b <= lenX
            frame= x(a:b); %xac dinh 1 frame
        else 
            frame= x(a:lenX);
            frame(lenX:b)=0;
        end
        %Ham tu tuong quan voi do tre n_min->n_max
        xxN=zeros(1,n_max-n_min+1);
        for n=n_min:n_max
        s =0; 
            for j=1:nSampleFrame
            B=0; %vitri khong xac dinh se cho bang 0
            if 1<=j+n && j+n<=nSampleFrame
                B= frame(j+n);
            end
            s=s+frame(j)*B;
            end
        xxN(n+1)=s;
        end
        
        
        %xac dinh vi tri max trong frame thoa nam tu mau n_min->n_max
        j=1;
        for index=2:length(xxN)-1
            if xxN(index-1)<xxN(index) && xxN(index)>xxN(index+1) && xxN(j)<xxN(index)
                j=index;
            end
        end
        
        %xac dinh huu thanh vo thanh v? F0
        if xxN(j)/max(x)> 0.35 %thong ke tim nguong 
              frame=h.*frame;
              dfty= abs(fft(frame,N));
              dfty1= dfty(1:length(dfty)/2 + 1);
 
              [value,peak] = findpeaks(dfty1); 
              frame_F0(frame_index)= (peak(1)+peak(2))/2;
            %frame_F0(frame_index)=fs/j;
        else
           frame_F0(frame_index)=0;
        end
    end
    frame_F0=medfilt(frame_F0,5); 
    [F0mean,F0std]=FindF0mean_F0std(frame_F0);
    figure;
    subplot(3,1,1);

    plot(t1,x);
    title('Speech Signal');
    xlabel('Time axis');
    ylabel('normalizedAmplitude');

    subplot(3,1,2);
    stem(t,frame_F0,'filled');
    title(['F0mean:', num2str(F0mean), ' F0std:', num2str(F0std)]);
    xlabel('Time axis');
    ylabel('F0');
    
     subplot(3,1,3);
    plot(x);
    title('F0');
    xlabel('Time axis');
    ylabel('F0');
end

