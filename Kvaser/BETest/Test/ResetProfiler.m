function pProf = ResetProfiler ( Profiler_in ,  pos ,  v , reset )

pProf = Profiler_in ; 

    pos  = max( min( pos ,pProf.PosMax ),pProf.PosMin ) ; 

    pProf.PosTarget = pos ;
    if ( reset )
    
        pProf.ProfilePos = pos ;
        pProf.ProfileSpeed = v ;
        pProf.BufCnt = 0 ;
        for cnt = 1:8 
        
            pProf.ProfilePosBuf(cnt) = pos ;
            pProf.ProfileSpeedBuf(cnt) = v ;
        end
        pProf.UnfilteredPos = pos ;
        pProf.Done = 1 ;
    else
    
        pProf.Done = 0 ;
    end
end
