close all;
for looping =1:8
   clearvars -except looping;
   clc;
% filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
% files = { '01MDA','02FVA', '03MAB', '06FTB'};

filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/TH1/TinHieuHuanLuyen/';
files = { '01MDA','02FVA', '03MAB', '06FTB','45MDV','42FQT','44MTT','30FTN'};


N=32068;
name = char(strcat(filePath, files(looping), '.wav'));
Tste= 0.21;
Tma= 0.185;
Tau = 0.37;

%gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap
Fslow=70;
Fshigh=450;

%0 si 1 speech


% do something for draw line in result matlab

% if (looping==1)
%     standardVals=MDA;
% elseif (looping==2)
%     standardVals=FVA;
% elseif (looping==3)
%     standardVals=MAB;
% elseif (looping==4)
%     standardVals=FTB;
% end;

% do something for draw line in result matlab

    gender = 'error!!';


    [x,t1,fs]=normalizedAmplitude(name);

    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdlow=1/450; pdhigh=1/70; 
    

    n_min = floor(pdlow*fs);
    n_max = floor(pdhigh*fs);

    lenX = length(x); %do dai tin hieu vao theo mau
    nSampleFrame = time_duration*fs;%do dai 1 frame tinh theo mau
    nSampleLag = lag*fs; %do dai do dich cua frame theo mau
    h=hamming(nSampleFrame) ;
    
    nFrame= int32((lenX-nSampleLag)/(nSampleFrame-nSampleLag))+1;%so frame chia duoc
    t=(1:nFrame)*2*fs/nSampleLag; 
   
    
%     ZCRarr=zeros(1,nFrame);
    STEarr=zeros(1,nFrame);
    MAarr= zeros(1,nFrame);
    VUframe = zeros(1,nFrame);
    VUindex =[0 ];
    frame_F0=zeros(1,nFrame);
    AUarr =zeros(1,nFrame);
    indexAu = zeros(1,nFrame);
    
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
        
%         ZCR computing
%         zcr=0;
%         for  i = 2:nSampleFrame
%             if frame(i)*frame(i-1) <0
%                 zcr=zcr+1;
%             end
%         end
%         ZCRarr(frame_index)=zcr;

        %Autocorrect computing
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
        indexAu(frame_index) = j;
        AUarr(frame_index)= xxN(j)/max(x);
       
        %MA computing
        MAarr(frame_index)= sum(abs(frame));
        
        %STE computing
        STEarr(frame_index)=sum(frame.^2);   
    end
        
  
     %ZCRarr= (ZCRarr - min(ZCRarr))/(max(ZCRarr) - min(ZCRarr));
     MAarr= MAarr./max(MAarr);
     STEarr=STEarr./max(STEarr);
     
     
    %define Speech-Silence 01
    for frame_index=1:nFrame
       if MAarr(frame_index) >Tma || STEarr(frame_index) >Tste  || AUarr(frame_index)>Tau
           VUframe(frame_index)=1; 
            frame_F0(frame_index)=fs/indexAu(frame_index);
       else
            frame_F0(frame_index)=0;
       end
    end
    
    frame_F0=medfilt(frame_F0,5); 
    [F0mean,F0std]=FindF0mean_F0std(frame_F0);
    
    
    %gender of signal
    if (F0mean >70 && F0mean <160)
        gender='male';
    elseif (F0mean> 160 && F0mean <250)
        gender ='female';
    else
        gender = 'no gender';
    end
    
    
    %find index to draw line
        for frame_index=2:nFrame-1
          if VUframe(frame_index) ~= VUframe(frame_index-1) && VUframe(frame_index) == VUframe(frame_index+1)
               index = double(double(frame_index-1)*0.03-double((frame_index-2))*0.01);
               if(index < t1(length(t1)))
                    VUindex=[VUindex index];
               end
          end
        end
        VUindex= [VUindex t1(length(t1))];
       
        
   
      
    figure('Name',char(files(looping)));
    subplot(3,1,1); plot(t,STEarr,'g','LineWidth',2);
    hold on;
    plot(t,MAarr,'r','LineWidth',2);
    hold on;
    title('Short-time energy(STE) vs MA');
    xlabel('Time axis')
    ylabel('normailized STE vs MA')
    legend('Short-time energy', 'MA');

    subplot(3,1,2);plot(t1,x);
    hold on;
     for i=1:length(VUindex)
            plot([1 1]*double(VUindex(i)), ylim, 'r','LineWidth', 2.3);
     end
     hold on;
    title('Speech Signal');
    xlabel('Time axis');
    ylabel('normalizedAmplitude');
    
    
    subplot(3,1,3);
    stem(t,frame_F0,'filled');
    title(['F0mean:', num2str(F0mean), ' F0std:', num2str(F0std), ' Gender:' ,gender]);
    xlabel('Time axis');
    ylabel('F0');
end
    
    
