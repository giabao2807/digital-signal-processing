function [F0mean,F0std]=FindF0mean_F0std(frame_F0)
    L=1:length(frame_F0);
    Dem=0;
    F0mean=0;
    for i=L
        if(frame_F0(i)>0)
            Dem=Dem+1;
            F0mean=F0mean+frame_F0(i);
        end
    end
    F0mean=F0mean/Dem;
    Sum=0;
    for j=L
        if(frame_F0(j)>0)
            Sum=Sum+(F0mean-frame_F0(j))^2; %tong cac binh phuong sai
        end 
    end
    F0std=sqrt(Sum/Dem);
end