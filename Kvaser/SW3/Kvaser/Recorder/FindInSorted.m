% function idx = FindInSorted(A, num)
% Finds the exact match to a member in a pre-sorted array. 
% A: Array to look in 
% num: Number to look for 
% Returns: 
% idx: Index in array if found 
%       [] if not found 
function idx = FindInSorted(A, num)
   l = 1;
   r = length(A);
   if num < A(1) || num > A(r) 
       idx = [] ; % out of range
       return ;
   end 

   while ~(r==l)
      idx = fix ((l + r)/ 2); % Assumption index 
      if A(idx) > num % Index too high , fold upper bound
          r = idx - 1; 
      elseif A(idx) < num % Index too low, fold lower bound
          l = idx + 1 ;
      else
          return ; % Yea, found it 
      end
   end
   % Not found 
   idx = [] ; 
end