function frames = DevideFrame(data, nframe, fsample)
    for i = 1 : nframe
        frames(i, :) = data(fsample * (i-1) + 1 : fsample * i);
    end
end