for looping =1:4
   % clear x frames;
   clearvars -except looping;
clc;
filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
files = {'01MDA', '02FVA', '03MAB', '06FTB'};
name = char(strcat(filePath, files(looping), '.wav'));
Tste= 0.21;
Tma= 0.185;

    [x,t1,fs]=normalizedAmplitude(name);

    N=32068;
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap
    
    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdhigh=450; pdlow=70; 
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap

     n_min = floor(fs/450);
     n_max = floor(fs/70);

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
    frame_F0=zeros(1,nFrame);
   
    
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
       
        %MA computing
        MAarr(frame_index)= sum(abs(frame));
        
        %STE computing
        STEarr(frame_index)=sum(frame.^2);   
    end
         
  
     %ZCRarr= (ZCRarr - min(ZCRarr))/(max(ZCRarr) - min(ZCRarr));
     MAarr= MAarr./max(MAarr);
     STEarr=STEarr./max(STEarr);
     
        
    %define Speech-Silence
    for frame_index=1:nFrame    
       if MAarr(frame_index) >Tma ||  STEarr(frame_index) >Tste
             a=(frame_index-1)*(nSampleFrame-nSampleLag)+1;
             if(frame_index ==1)
                b=(frame_index)*nSampleFrame;
             else
                 b=(frame_index)*nSampleFrame - (frame_index-1)*nSampleLag;
             end
             if b < lenX
                    frame= x(a:b); %xac dinh 1 frame
             else 
                    frame= x(a:lenX);
                    frame(lenX:b)=0;
            end
             frame=h.*frame;
             dfty= abs(fft(frame,N));
             dfty1= dfty(1:length(dfty)/2 + 1);
            
      
            
            tmp_k=1;
            harmonics=[];
            for index=100:1000
                 if dfty1(index-1)<dfty1(index) && dfty1(index)>dfty1(index+1)  
                        if index-tmp_k > 200 && index-tmp_k <450
                             tmp_k=index;
                             harmonics=[harmonics index];
                             if length(harmonics) ==5 
                                 break;
                             end
                        else
                            continue;
                        end
                end
            end
            
    
            
            % find F0[] and do something to find F0
            F0=[harmonics(1)];
            tmp_index=1;
            for i= 2:length(harmonics)
                F0new = harmonics(i)-harmonics(i-1);
                if F0new - F0(tmp_index) >20
                    continue;
                end
                F0 =[F0 F0new];
                tmp_index=tmp_index+1;
            end
             
            frame_F0(frame_index)=sum(F0)/length(F0);
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
    plot(dfty1);
    title('F0');
    xlabel('Time axis');
    ylabel('F0');
end

