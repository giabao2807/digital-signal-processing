function rs = bai2(n)
    mau = -2:1:4;
    biendo = [0 -2 4 -2 2 -1 0];
        rs=zeros(1,length(n));
    for i=1:length(n)
        for j=1:length(mau)
            if n(i)==mau(j)
                rs(i)=biendo(j)
            end
        end
    end
end