function x = str2tex(str)
    x = char(str); 
    place = sort([find(x=='\'),find(x=='_')]); 
    if ~isempty(place)
        for cnt = length(place):-1:1
            if cnt
                x =  [x(1:place(cnt)-1),'\',x(place(cnt):end)];
            else
                x =  ['\',x]; %#ok<*AGROW> 
            end
        end
    end
end