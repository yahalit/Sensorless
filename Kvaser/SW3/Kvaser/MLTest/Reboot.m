global DataType 


% 24V reboot 
SendObj( [hex2dec('2103'),120] , 1 , DataType.long , 'Reboot24' ) ;

% 12V reboot
SendObj( [hex2dec('2103'),121] , 0 , DataType.long , 'Reboot12' ) ;
