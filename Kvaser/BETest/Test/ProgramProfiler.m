function pProf = ProgramProfiler( pProf_in ,  vmax ,  amax ,  dmax ,  tau ,  mode )

pProf = pProf_in ; 


    if ( vmax > 0 )
    
        pProf.vmax = vmax ;
    end

    if ( amax > 0 )
    
        pProf.accel = amax ;
    end
    if ( dmax > 0 )
    
        pProf.dec = dmax ;
    end

    if ( tau >= 0 )
    
        pProf.tau = tau ;
    end
    pProf.ProfilerMode = mode ;
end
