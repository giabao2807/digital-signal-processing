function vu = VU(nf,ste, ma, Zste, Zma)
    index = zeros(1, nf);
    for i = 1 : nf 
        if (ma(i) > Zma || ste(i) > Zste) 
            index(i) = 1;
        end
    end
    count = 2;
    for i = 2 : nf - 1
        if (index(i) ~= index(i-1) && index(i) == index(i+1))
            if (index(i) == 0 && isUV(index, i) == 0)
                continue;
            end
            vu(count) = (i-1) * 0.01;
            count = count + 1;
        end
    end
    vu(1) = 0;
    vu(nf) = (nf-1) * 0.01;