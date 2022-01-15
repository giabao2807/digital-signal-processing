close all;
for looping =1:2
   clearvars -except looping;
   clc;

filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/TH2/NguyenAmHuanLuyen/';

filenames = { '01MDA','02FVA','03MAB','04MHB','05MVB','06FTB', '07FTC', '08MLD','09MPD','10MSD','11MVD','12FTD','14FHH','15MMH','16FTH','17MTH','18MNK','19MXK','20MVK','21MTL','22MHL'};
files ={'e','u','o','a','i'};
    for looping1 = 1:5

N=32068;
name = char(strcat(filePath, filenames(looping),'/',files(looping1), '.wav'))
Tste= 0.21;
Tma= 0.185;
Tau = 0.37;

%gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap
Fslow=70;
Fshigh=450;


    gender = 'error!!';


    [x,t1,fs]=normalized(name);

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
    VUindex =[];
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
     
    
  
    
    %find index to draw line
        for frame_index=2:nFrame-1
          if VUframe(frame_index) ~= VUframe(frame_index-1) && VUframe(frame_index) == VUframe(frame_index+1)
              index = double(double(frame_index-1)*0.03-double((frame_index-2))*0.01);
 
              if(index < t1(length(t1)))
                    VUindex=[VUindex index];
              end
          end
        end
         if(length(VUindex)==1)
             VUindex=[0 VUindex];
         end
       
         a=VUindex(1)*fs
         b=VUindex(2)*fs
         range = floor((b-a)/3);
         xx=x(a+range:b-range);
         
        coeffs = mfcc(xx,fs); 
        [L,M,N] = size(coeffs);
        coeffs = mean(coeffs,1);
        
   
      
    figure('Name',char(strcat(filenames(looping),files(looping1), '.wav')));
    subplot(2,1,1);plot(t1,x);
    hold on;
     for i=1:length(VUindex)
            plot([1 1]*double(VUindex(i)), ylim, 'r','LineWidth', 2.3);
     end
    title('Speech Signal');
    xlabel('Time axis');
    ylabel('normalizedAmplitude');
 
    
    subplot(2,1,2);plot(xx);
    end
end

    
    
