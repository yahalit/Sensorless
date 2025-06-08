function out = SimpleValue(issimple,in) 
	if issimple && in >= 10000
		out = inf ; 
	else
		out = min( in , 10000 ) ; 
	end
end