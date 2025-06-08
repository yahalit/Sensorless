function [opcodes,times, msgs] = TestMessageStatistics(kaka)

rxstr = struct('Payload',[],'Next',[],'TxCtr',[],'OpCode',[],'TimeTag',[],'Odd',0) ; 
opcodes=[] ; 
times = [] ; 
msgs = [];
while 1 
    rxstr = DecomposeMessage(rxstr,kaka);
    if isempty(rxstr.Payload) 
        break ; 
    end 
    kaka = [] ; 
     opcodes=[opcodes,rxstr.OpCode];  %#ok<*AGROW>
     times=[times,rxstr.TimeTag]; 
     if (rxstr.OpCode~=15)
         if (rxstr.OpCode == 35) %Travel information
             msg = [rxstr.Payload,zeros(1,14)];
         else
             msg = rxstr.Payload ;
         end 
         if (rxstr.OpCode == 33) %BIT msg
             BIT_err = TestBITmsg(msg);
             if (BIT_err ~= 0)
                 error('BIT msg doesnt match ICD');
             end
         end 
         if (isempty(msgs))
             msgs = [msg];
         else
         msgs = [msgs; msg];
         end
     end
end 

end

