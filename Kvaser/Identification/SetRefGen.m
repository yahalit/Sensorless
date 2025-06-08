function SetRefGen( str , Tphase) 
% function SetRefGen( str , Tphase) 
% str: a struct with the fields
% 'Gen' : 'G' or 'T' 
% Fields to set are 'Type' which may be amy of RecStruct.Enums.SigRefTypes
% 'On' (0  or 1) 
% Wave parameters: 'Dc',0,'Amp',0,'F',1,'Duty
% The G generator my also specify bAngleSpeed (0: normal, 1: integrating the waveform, so DC becomes speed) 
%
% Tphase: Phase in [0:1] to add the T generator on start of identification 
global RecStruct ; %#ok<GVMIS> 
% global DataType %#ok<GVMIS> 

DataType = GetDataType() ;

CfgTable = RecStruct.CfgTable  ;

    TestStructFields(str,{'Gen','Type','On'},'RefGen struct') ; 
    if isequal( str.Type , RecStruct.Enums.SigRefTypes.E_S_Nothing) || isequal( str.On ,0 ) 
        str = DefaultStr( str , struct('Dc',0,'Amp',0,'F',1,'Duty',0.5,'bAngleSpeed',0,'AnglePeriod',1));  
    end 

    TestStructFields(str,{'Dc','Amp','F','Duty'},'RefGen struct') ; 
    str.Gen = upper(str.Gen) ; 
    switch  str.Gen
        case 'T'
            if ~str.On 
                SendObj([hex2dec('2220'),203],str.On,DataType.long,'On Ref Gen parameter') ;                 
            end

            SendObj([hex2dec('220d'),CfgTable.TRef_Dc.Ind],str.Dc,DataType.float,'Dc Ref Gen parameter') ; 
            SendObj([hex2dec('220d'),CfgTable.TRef_Amp.Ind],str.Amp,DataType.float,'Amp Ref Gen parameter') ; 
            SendObj([hex2dec('220d'),CfgTable.TRef_F.Ind],str.F,DataType.float,'F Ref Gen parameter') ; 
            SendObj([hex2dec('220d'),CfgTable.TRef_Duty.Ind],str.Duty,DataType.float,'Duty Ref Gen parameter') ; 
            
            SendObj([hex2dec('2220'),201],str.Type,DataType.long,'Type Ref Gen parameter') ; 

            if nargin > 1
                SendObj([hex2dec('2220'),16],0,DataType.long,'Dont align generator times ') ; 
                SendObj([hex2dec('2221'),10],Tphase,DataType.float,'Phase for T ref gen ') ; 
            end 
            if str.On 
                SendObj([hex2dec('2220'),203],str.On,DataType.long,'On Ref Gen parameter') ;                 
            end

        case 'G'
            if ~str.On 
                SendObj([hex2dec('2220'),202],str.On,DataType.long,'On Ref Gen parameter') ;                 
            end

            SendObj([hex2dec('220d'),CfgTable.GRef_Dc.Ind],str.Dc,DataType.float,'Dc Ref Gen parameter') ; 
            SendObj([hex2dec('220d'),CfgTable.GRef_Amp.Ind],str.Amp,DataType.float,'Amp Ref Gen parameter') ; 
            SendObj([hex2dec('220d'),CfgTable.GRef_F.Ind],str.F,DataType.float,'F Ref Gen parameter') ; 
            SendObj([hex2dec('220d'),CfgTable.GRef_Duty.Ind],str.Duty,DataType.float,'Duty Ref Gen parameter') ; 
            if isfield(str,'bAngleSpeed') 
                TestStructFields(str,{'Gen','AnglePeriod'},'G RefGen struct, angular motion') ; 
                SendObj([hex2dec('220d'),CfgTable.GRef_AnglePeriod.Ind],str.AnglePeriod,DataType.float,'AnglePeriod G Ref Gen parameter') ; 
            else
                str.bAngleSpeed = 0 ; 
            end
                SendObj([hex2dec('220d'),CfgTable.GRef_bAngleSpeed.Ind],str.bAngleSpeed,DataType.long,'bAngleSpeed G Ref Gen parameter') ; 
            SendObj([hex2dec('2220'),200],str.Type,DataType.long,'Type Ref Gen parameter') ; 
            
            if  str.On 
                SendObj([hex2dec('2220'),202],str.On,DataType.long,'On Ref Gen parameter') ;                 
            end
        otherwise
            error('Unindentified reference generator') ; 
    end 

