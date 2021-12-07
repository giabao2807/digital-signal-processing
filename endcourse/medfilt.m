function y = medfilt(x,N)
 %tra ve y sau khi qua ham loc trung vi
 %1 10 15 3 2 => 1 3 3 2 3 
 y = x; %khoi tao gia tri tin hieu y
 frame = 1:N; % tao truc thoi gian tin hieu cua so co chieu dai N
    for k = 1:length(x) % k chay tu 1 den chieu dai cua tin hieu x
        for i = 1:N %i chay tu 1 den N
            if(k < ceil(N/2))
            %xet gia tri tin hieu cua so temp ben trai tin hieu x
                if(i < ceil(N/2)-k+1) % i < phan tu giua cua frame
                    frame(i) = 0;
                else
                    frame(i) = x(k+i-ceil(N/2)); % i > phan tu giua cua frame
                end
            else
            %xet gia tri tin hieu cua so ben phai tin hieu frame
                if(k > length(x) - ceil(N/2) + 1)
                %i < phan tu giua cua frame
                    if(i < length(x) + ceil(N/2) - k + 1)
                        frame(i) = x(k-ceil(N/2) + i);
                    else
                        frame(i) = 0; %i > phan tu giua cua frame
                    end
                else
                %xet tin hieu frame chay o giua x.
                    frame(i) = x(k-ceil(N/2)+i);
                end
            end
        end
     y(k) = median(frame);
     end
end