function IdentSetup(str) 
% function IdentSetup(str) 
% Send identification setup do drive
% str : Struct with members: 
%      nCyclesInTake: Number of sine cycles in a take 
%      nSamplesForFullTake: Total number of sampling time in a take of nCyclesInTake 
%      nWaitTakes         : Number of takes in wait for stabilization before actual take starts
%      nSumTakes          : Number of takes ummarized for actual identification 
    SendObj([hex2dec('2221'),0],str.nCyclesInTake,GetDataType('long'),'nCyclesInTake') ;
    SendObj([hex2dec('2221'),1],str.nSamplesForFullTake,GetDataType('long'),'nSamplesForFullTake') ;
    SendObj([hex2dec('2221'),2],str.nWaitTakes,GetDataType('long'),'nWaitTakes') ;
    SendObj([hex2dec('2221'),3],str.nSumTakes,GetDataType('long'),'nSumTakes') ;
end 