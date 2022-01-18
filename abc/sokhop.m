function [check_result] = sokhop(name, data, origin)
    check_result = 1;
    result = zeros(1,5);    
    for i = 1 : 5
           result(i) =sqrt(sum((data-origin(i,:)).^2)); 
    end
    if(min(result) == result(1))
        check_result = 1;
    end
    if (min(result) == result(2))
         check_result = 2;
    end
    if (min(result) == result(3))
        check_result = 3;
    end
    if (min(result) == result(4))
         check_result = 4;
    end
    if (min(result) == result(5))
       check_result = 5;
    end
end