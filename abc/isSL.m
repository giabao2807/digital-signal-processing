function rs = isSL(frames, index)
    rs = 1;
    for i = 0 : 11
        if (i + index > length(frames) )
            break;
        end
        if (frames(i + index) == 1)
            rs = 0;
            break;
        end
    end