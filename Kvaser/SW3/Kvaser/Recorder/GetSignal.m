function [val,index,datatype] = GetSignal( name , cpu  , recstruct )
%function [val,index,datatype] = GetSignal( name , cpu  )
% Get a signal from the recorder list or its characteristics
% val = GetSignal(...) , the signal itself is brought using communications 
% [~,index,datatype] = GetSignal(...) brings the signal's recorder index and type from the database
%   Example: [~,ind] = GetSignal('TRefOut'); 
% name : Name of signal as in the recorder list 
% cpu (default: 1) , else may be 1 or 2 for cpu1 or cpu2 (LP only) 

global TargetCanId 
global TargetCanId2 
global RecStruct ; %#ok<*GVMIS> 
targetID = TargetCanId ;
val   = [] ; 
DataType = GetDataType() ;
if nargin < 3 || isempty(recstruct) 
    recstruct = RecStruct ; 
end
if nargin >= 2 && isa(1,'numeric')
    cpu = num2str(cpu) ; 
end

if nargin < 2 
    cpu = [] ; 
end
if isempty(cpu) 
    if TargetCanId == 124
        cpu = '1' ; 
    else
        targetID = recstruct.TargetCanId ;
        signames = recstruct.SigNames ; 
        
    end
else
if isa(cpu,'char')
    if ( contains(cpu,'1') || contains(cpu,'2') || contains(lower(cpu),'cpu') )
        cpu = str2num(cpu) ; %#ok<ST2NM> 
        if cpu == 1 
            signames = recstruct.SigNames ; 
        else
            signames = recstruct.SigNames2 ; 
            if ~isa(name,'double')
                name     = ['C2_',name] ; 
            end
            targetID = TargetCanId2 ;
        end
    else
        strin = cpu ; 
        str = GetProjectAttributesByName(strin) ;
        EntName = [str.ShortHand,'Entity'] ;
        if isfield (RecStruct, EntName) 
            Ent = RecStruct.(EntName) ; 
        else
            Ent = str.Card ;
        end

        [~,recstruct] = SetCanComTarget(Ent,str.Side,strin,str.Proj,recstruct);
        if isfield(recstruct,'SigList2') 
            recstruct = rmfield(recstruct,'SigList2') ;
        end
        targetID = recstruct.TargetCanId  ; 
        signames = recstruct.SigNames ; 

    end
end

end



if ~isa(name,'double')
    junk = find( strcmp(name, signames ) ,1 ) ;
    if isempty( junk ) 
        junk = find( strcmpi(name, signames ) ,1 ) ;
        if isempty( junk) 
            error ( ['Recorder object [',name,'] not found']) ; 
        else
            error ( ['Recorder object [',name,'] not found, maybe you mean [',recstruct.SigNames{junk},']']) ; 
        end 
    end 
    index = junk ; 
    if nargout > 1 
        rec  = recstruct.SigList{junk} ; 
        rtype = rec{1} ;
        if ( rtype.IsFloat)
            datatype = DataType.float ; 
        else
            if ( rtype.IsShort )
                datatype = DataType.short ; 
            else
                datatype = DataType.long ; 
            end
        end
        return ; 
    end
else
    index = name ; 
    junk = name ; 
end

    if ( junk > 254 )
        error('GetSignal only supports first 254 signals in the table ') ; 
    end 

    if isequal( cpu , 2)
        rec  = recstruct.SigList2{junk} ; 
        junk = junk - 1 ; 
    else
        rec  = recstruct.SigList{junk} ; 
    end

    rtype = rec{1} ; 
    if ( rtype.IsFloat ) 
        val = FetchObj( [hex2dec('2002'),junk,targetID] , DataType.float ,'Get float') ;
        return ;
    end 
    if ( rtype.IsShort ) 
        val = FetchObj( [hex2dec('2002'),junk,targetID] , DataType.short ,'Get short') ;
        if ( rtype.IsUnsigned ) 
            if ( val < 0 ) 
                val = val + 65536 ; 
            end 
        end 
        return ;
    end 
    val = FetchObj( [hex2dec('2002'),junk,targetID] , DataType.long ,'Get long') ;
    if ( rtype.IsUnsigned ) 
        if ( val < 0 ) 
            val = val + 2^32 ; 
        end 
    end 
end

