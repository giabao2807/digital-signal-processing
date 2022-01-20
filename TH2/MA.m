function ma = MA(frames, nf)
    for i = 1 : nf
        ma(i) = sum(abs(frames(i,:)));
    end