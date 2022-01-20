
function ste = STE(frames, n_f) 
    for i = 1 : n_f
        tmp = frames(i, :);
        ste(i) = sum(tmp.^2);
    end
end