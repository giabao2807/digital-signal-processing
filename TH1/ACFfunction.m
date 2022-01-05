function xxN= ACFfunction(frame)
    nSampleFrame= length(frame);
    xxN=zeros(1,nSampleFrame);
    for n=1:nSampleFrame
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
    end