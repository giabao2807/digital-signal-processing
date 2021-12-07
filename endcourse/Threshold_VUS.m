clear;
clc;

filePath='/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/';
files = { '02FVA', '03MAB', '06FTB','01MDA'};
name = char(strcat(filePath, files(3), '.wav'));
%[data, fs] = audioread('/Users/dinhgiabao/Desktop/HK1-nam3/XLTinHieu/endcourse/TinHieuHuanLuyen/06FTB');
MDA = [0,1.52,1.92,3.91,4.35,6.18,6.6,8.67,9.14,10.94,11.33,12.75];
FVA=[0.00,0.83,1.37,2.09,2.60,3.57,4.00,4.76,5.33,6.18,6.68,7.18];
%MDA = [0,0.45,0.81,1.53,1.85,2.69,2.86,3.78,4.15,4.84,5.14,5.58];
MAB =[0,1.03,1.42,2.46,2.80,4.21,4.52,6.81,7.14,8.22,8.50,9.37];

[data,t1,fs]=normalizedAmplitude(name);


STEtk=[];
MAtk=[];
tmp=2;
 for i = 1 : floor(length(MDA)/2)  
     if(tmp>=(length(MDA)-1))
        break;
     end
    
     t1 = floor(MDA(tmp)*fs); 
     t2 = floor(MDA(tmp+1)*fs);
     
     x=data(t1:t2);
     
     time_duration=0.03; %do dai moi khung 
    lag = 0.01; %do tre moi khung
    pdlow=1/450; pdhigh=1/70; 
    %gioi han tan so F0 trong khoang 70hz->450hz->giam do phuc tap

    n_min = floor(pdlow*fs);
    n_max = floor(pdhigh*fs);

    lenX = length(x) ;%do dai tin hieu vao theo mau
    nSampleFrame = time_duration*fs;%do dai 1 frame tinh theo mau
    nSampleLag = lag*fs; %do dai do dich cua frame theo mau

    
    nFrame= int32((lenX-nSampleLag)/(nSampleFrame-nSampleLag))+1;
     
    %ZCRarr=zeros(1,nFrame);
    STEarr=zeros(1,nFrame);
    MAarr= zeros(1,nFrame);
    
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
        
%         %ZCR computing
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
    
         
    MAarr= MAarr./max(MAarr);
    STEarr=STEarr./max(STEarr);
    
    STEtk = [STEtk STEarr];
    MAtk = [MAtk MAarr];
    tmp=tmp+2;
 end

meanSTE = mean(STEtk)
stdSTE = std(STEtk)
meanMA= mean(MAtk)
stdMA= std(MAtk)

%MDA 
%v       ste                                     MA
%        mean:0.3399                    mean:0.4310
%        std:0.3784                       std:0.3699

%uv    mean:0.1762                    mean:0.3564
%       std:0.2                               std:0.2214
%=>  ste ~=0.207                      MA= 0.3   
  

%MBA 
%uv       ste                                     MA
%        mean:0.2303                   mean:0.4733
%        std:0.2034                          std:0.2096

%v    mean:0.3048                   mean:0.4889
%       std:0.23171                         std:0.2951 
%=> ste~=0.215                     MA=0.43


%FTB
%uv       ste                                     MA
%        mean:0.2591                    mean:0.4526
%        std:0.1824                         std:0.1730

%v    mean:0.3179                     mean:0.5275
%       std:0.3537                         std:0.3465      
%=>  ste ~=0.238                 MA= 0.3628


%FVA
%v       ste                                     MA
%        mean:0.4116                mean:0.5179
%        std:0.3696                         std:0.3709

%uv    mean:0.3705                    mean:0.5730
%       std:0.2100                        std:0.2679    
%=>  ste ~=0.211                  MA= 0.534

%====>ste=0.2175           MA=0.37


