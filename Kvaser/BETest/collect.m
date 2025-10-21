% Collect: Collect measurement of runtime via serial port
s = serialport('COM9', 2e6);
flush(s) ; 
pause(0.05) ; 
d = read( s , s.NumBytesAvailable, 'uint8') ; 
clear s  ; 
ind = find( d >= 128 ); 
ndata = length(ind) - 1 ; 
data = zeros(8,ndata) ; 
vec  = zeros(8,1) ; 

save  aaaa2.mat vec
for cnt = 1:ndata 
    start = ind(cnt) ; 
    % These are signed. first byte is 7 lower bits + (1) marker of start of
    % message that must be removed in the message leader and makes no difference
    % The second byte (start+1) is has MSB in 7 leaders. If it is signed, the leader bit  is inversion
    vec(1) = bitand( d(start), 127)  + bitand(d(start+11),63) * 128 - bitand( d(start+1), 64) * 128 ;
    start = start + 2 ; 
    vec(2) = bitand( d(start), 127) + bitand(d(start+11),63) * 128 - bitand( d(start+1), 64) * 128 ;
    start = start + 2 ; 
    vec(3) = bitand( d(start), 127) + bitand(d(start+1),63)* 128  - bitand( d(start+1), 64) * 128 ;
    % Voltages are unsigned 
    start = start + 2 ; 
    vec(4) = bitand( d(start), 127) + d(start+1)  * 128 ;
    start = start + 2 ; 
    vec(5) = bitand( d(start), 127) + d(start+1)  * 128 ;
    start = start + 2 ; 
    vec(6) = bitand( d(start), 127)  + d(start+1) * 128 ;
    start = start + 2 ; 
    vec(7) = bitand( d(start), 127) + d(start+1)  * 128 ; % VDC
    start = start + 2 ; 
    % Last is the electrical angle PU 
    vec(7) = bitand( d(start), 127) + d(start+1)  * 128 ; % VDC
    %vec(8) = bitand( d(start), 127)  + bitand(d(start1),63) * 128 - bitand( d(start1), 64) * 128 ; % Bus current 
    data(:,cnt) = vec ; 
end 
% Scale data to actual units 
data(1:3,:) = data(1:3,:) / 256 ;
data(4:7,:) = data(4:7,:) / 32  ;
data(8,:) = data(8,:) / 256 ;
figure(1) ; clf
t = 100e-6 * (0:ndata-1); 
subplot(4,1,1) ; plot( t , data(1:3 ,:));
subplot(4,1,2) ; plot( t , data(4:6 ,:));
subplot(4,1,3) ; plot( t , data(7 ,:));
subplot(4,1,4) ; plot( t , data(8 ,:));
