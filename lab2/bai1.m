function rs = bai1(n)
    mang = -1:1:2;
    biendo = [-1 0 1 2];
    rs=zeros(1,length(n));
    for i=1:length(n)
        for j=1:length(mang)
            if n(i)==mang(j)
                rs(i)=biendo(j)
            end
        end
    end
end