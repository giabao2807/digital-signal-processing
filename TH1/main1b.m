close all;
for looping =1:2
   clearvars -except looping;
   clc;
 %filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
 %files = { '01MDA','02FVA', '03MAB', '06FTB'};

filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/TH1/NguyenAmHuanLuyen/01MDA/';
files = { 'a','e', 'i', 'o','u'};


N=32068;
name = char(strcat(filePath, files(looping), '.wav'));
[x,t1,fs]=normalizedAmplitude(name);
Tste= 0.21;
Tma= 0.185;
Tau = 0.37;

%gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap
Fslow=70;
Fshigh=450;

    time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdlow=1/450; pdhigh=1/70; 
    

    n_min = floor(pdlow*fs);
    n_max = floor(pdhigh*fs);

    lenX = length(x); %do dai tin hieu vao theo mau
    nSampleFrame = time_duration*fs;%do dai 1 frame tinh theo mau
    nSampleLag = lag*fs; %do dai do dich cua frame theo mau
    h = hamming(nSampleFrame);
    
    nFrame= int32((lenX-nSampleLag)/(nSampleFrame-nSampleLag))+1;%so frame chia duoc
    t=(1:nFrame)*2*fs/nSampleLag; 
    
    
    STEarr=zeros(1,nFrame);
    MAarr= zeros(1,nFrame);
    VUframe = zeros(1,nFrame);
    VUindex =[0 ];
    frame_F0=zeros(1,nFrame);
    AUarr =zeros(1,nFrame);
    
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
        AUarr(frame_index)= xxN(j)/max(x);
       
        %MA computing
        MAarr(frame_index)= sum(abs(frame));
        
        %STE computing
        STEarr(frame_index)=sum(frame.^2);   
    end
   
     MAarr= MAarr./max(MAarr);
     STEarr=STEarr./max(STEarr);
     
         %define Speech-Silence 01
    for frame_index=1:nFrame
       if MAarr(frame_index) >Tma || STEarr(frame_index) >Tste  || AUarr(frame_index)>Tau
           VUframe(frame_index)=1;
           
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
             dfty= real(fft(frame,1024));
             dfty1= dfty(1:length(dfty)/2 + 1);
             logdf = log(abs(dfty1));
             iffty = real(ifft(logdf));
            
%       
%             
%             tmp_k=1;
%             harmonics=[];
%             for index=2:2000
%                  if dfty1(index-1)<dfty1(index) && dfty1(index)>dfty1(index+1)  
%                         if (index-tmp_k)*fs/N > Fslow && (index-tmp_k)*fs/N <Fshigh
%                              tmp_k=index;
%                              harmonics=[harmonics index];
%                               if length(harmonics) ==5 
%                                   break;
%                               end
%                         else
%                             continue;
%                         end
%                 end
%             end
            
    
            
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
        VUindex= [VUindex t1(length(t1))];
        
%         %find F1,F2,F3
%         a=VUindex(2)*fs;
%         b=VUindex(3)*fs;
%         tt=t1(a:b);
%         h=hamming(length(tt));
%         frame = x(a:b);
%         frame = h.*frame;
%         
%         dfty= abs(fft(frame,N));
%         dfty1= dfty(1:length(dfty)/2 + 1);
%         logdf = log(dfty1);
%         ifft = 1/fft(log(dfty));
        
        

     
    figure('Name',char(files(looping)));
    subplot(2,1,1); plot(t1,x);
    hold on;
     for i=1:length(VUindex)
            plot([1 1]*double(VUindex(i)), ylim, 'r','LineWidth', 2.3);
     end
    title('signal');
    xlabel('Time axis');
    ylabel('normailized Amplitude');

    subplot(2,1,2);
    spectrogram(x,3*10^(-3)*fs,1*10^(-3)*fs,N,fs,'yaxis');
    hold on;
    title('Spectrogram signal');
    xlabel('Time axis');
    ylabel('Frequency(Hz)');
    
    
    
    if (looping==1)
       figure('Name','Ket qua trung gian');
       subplot(4,1,1); plot(frame);
       hold on;
       subplot(4,1,2); plot(dfty);
       hold on;
       subplot(4,1,3); plot(logdf);
       hold on;
       subplot(4,1,4); plot(iffty);
    end

end
    
    
