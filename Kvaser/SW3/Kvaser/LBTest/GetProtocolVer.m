% function [RcProt] = GetProtocolVer(  ) 
% Get Protocol version  

function RcProt = GetProtocolVer(    ) 

global DataType 

RcProt = FetchObj( [hex2dec('2220'),89] , DataType.long , 'Get Rc protocol version' ,[]) ;
