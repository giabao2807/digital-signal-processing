function [check_result] = sokhop(name, data, origin,k)
    check_result = 1;
    result = zeros(1,5*k);    
    for i = 1 : 5*k
           result(i) =sqrt(sum((data-origin(i,:)).^2)); 
    end
    for j =1:k
        if(min(result) == result(j))
            check_result = 1;
        end
        if (min(result) == result(k+j))
            check_result = 2;
        end
        if (min(result) == result(2*k+j))
            check_result = 3;
        end
        if (min(result) == result(3*k+j))
             check_result = 4;
        end
        if (min(result) == result(4*k+j))
            check_result = 5;
        end
    end
end