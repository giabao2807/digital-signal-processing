function VUindex = isSL(frame,VUindex)
    for i = 2:length(VUindex)
        time =VUindex(i)-VUindex(i-1);
        if  time <= 0.3 && frame == 0
            for j =i-1:length(VUindex)-1
                VUindex(j)= VUindex(j+1);
            end
        end
    end
end
