function [frame_F0,t]=frame_F0(x,fs)
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
    frame_F0= zeros(1,nFrame);
    t=(1:nFrame)*fs/nSampleLag;
    
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
        if xxN(j)/max(x)> 0.48 %thong ke tim nguong 
           frame_F0(frame_index)=fs/j;
        else
           frame_F0(frame_index)=0;
        end
    end
end