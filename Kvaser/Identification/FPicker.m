function [fout,Ncyc,Ntake,f1] = FPicker( f1_in , f2_in , N, maxDiv , Ts )
% function [fout,Ncyc,Ntake,f1] = FPicker( f1 , f2 , N , maxDiv , Ts )
% build a frequency vector of approximately N points between f1 and f2
% so that an integer number of cycles will divide exactly by the sampling time Ts 
% f1: Frequency to start 
% f2: Frequency to end 
% N : Approximate number of points 
% maxDiv: The maximum number of cycles to get an integer Ts count 
% Ts : The sampling time
% Returns 
% fout: Output frequencies 
% Ncyc: The number of cycles to get an integer sampling count for the frequencies 
% nTake: The number of samples for a full take; Ncyc periods of the desired frequency 
% f1  : Ideal logspaced frequencies vector
if ( N == 1 )
    f1 = sqrt(abs(f1_in*f2_in)) ; 
else
    f1 = logspace( log10(abs(f1_in)), log10(abs(f2_in)) , N ) ; 
end
t1 = 1 ./ f1 / Ts ; 
t1 = transpose( t1(:)) ; 

fget = zeros( maxDiv, N ) ; 
ntake = fget ; 
fget(1,:) = 1./ ( round( t1) * Ts ) ; 
ntake(1,:) = round( t1 ) ; 
for cnt = 2:maxDiv 
    % t1 = period, ideal, normalized to sampling time
    fget(cnt,:)  = cnt ./ ( round( t1 * cnt ) * Ts ) ; 
    ntake(cnt,:) = round( t1 * cnt ) ; 
end 

% Set of all the unique frequencies
% fall = unique( fget(:)) ; 
% Target frequencies
fall = fget(:) ; 
ntakeall = ntake(:) ; 
fout = f1 ; 

% For each of the divider
Ntake = f1 * 0 ; 
Ncyc  = f1 * 0 ; 
fcnt = 0 ; 
old = -1 ; 
for cnt = 1:N 
    % Find the index that best approximates 
    [~,n] = min(abs(f1(cnt)-fall)) ; 
    next = fall(n);
    nexttake = ntakeall(n) ; 
    if ~(old==next) 
        fcnt = fcnt + 1 ; 
        Ntake(fcnt) = nexttake ; 
        Ncyc( fcnt) = round( next * (nexttake * Ts) )  ;  
        fout(fcnt) = next ; 
        old = next ; 
    end
end 
fout = fout(1:fcnt); 
Ncyc = Ncyc(1:fcnt); 
Ntake = Ntake(1:fcnt); 

end
% 
% fout = unique(fout); 
% Ncyc = fout * 0  ; 
% for cnt = maxDiv:-1:1
%     Nf   = cnt ./ fout / Ts ; 
%     nf1  =  abs(Nf-round(Nf)) < 1e-7 ; 
%     Ncyc(nf1) = cnt  ; 
% end
% 
% if any( Ncyc ==0 )
%     error('A frequency without multiplier') ; 
% end







