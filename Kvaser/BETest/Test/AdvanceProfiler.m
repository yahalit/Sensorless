function [done,pProf] = AdvanceProfiler(pProf_in , dt )

pProf = pProf_in ;
    pProf.UnfilteredPos  = pProf.ProfilePosBuf(pProf.BufCnt+1) ;
    err = pProf.PosTarget - pProf.UnfilteredPos ;

    pProf.PosDiff = err ;
    v = pProf.ProfileSpeedBuf(pProf.BufCnt+1) ;
    p = pProf.ProfilePosBuf(pProf.BufCnt+1) ;
    vold = v ;

    if ( err >= 0 )
    
        dir = 1 ;
    else
    
        v   = -v;
        err = -err ;
        dir = -1;
    end

    % Find the done condition
    if ( ( abs(v) < 1.6 * pProf.dec * dt)  && (err < 5 * pProf.dec * dt * dt  ) )
    
        done = 1 ;
    else
    
        done = 0 ;


       d = pProf.dec * 0.93 ;
       vm = sqrtf(2.0 * d * err ) ;
        if ( v < 0 || v < vm  )
        
            s2  = 1.414213562373095 ;
            %tau = 0.05 ;
            b = (s2*d*dt-2*s2*d*pProf.tau);
            c = 2*d*dt*v-4*d*err ;
            delta = b * b - 4 * c ;
            if ( delta < 0 )
            
                a = (2*d*err+v*v-2*dt*d*v)/(dt*dt*d) ;
            else
            
                sol = (-b+sqrtf(delta))* 0.5 ;
                a =  0.5*(s2*sol-2*v)/dt ;
                if ( a < -pProf.dec )
                
                    a = -pProf.dec ;
                end
            end
            if ( a > pProf.accel)
            
                a = pProf.accel ;
            end


            v = v + dt * a ;

            if ( v > pProf.vmax )
            
                v = pProf.vmax ;
            end
        else
        
            vk  = v ;
            v   = v - dt * pProf.dec ;
            err = err - 0.5 *( v + vk ) * dt ;

            if ( ( fabsf(v) < 1.1 * pProf.dec * dt)  && ( fabsf(err) < 1.7 * pProf.dec * dt * dt  ) )
            
                done = 1 ;
            end
        end
    end

    pProf.BufCnt = bitand( pProf.BufCnt + 1,  7 ) ;
    if ( done )
    
        pProf.ProfilePosBuf(pProf.BufCnt+1)   = pProf.PosTarget ;
        pProf.ProfileSpeedBuf(pProf.BufCnt+1) = 0 ;
        fPtr = pProf.ProfileSpeedBuf ;
        if ( fPtr(0+1) || fPtr(1+1) || fPtr(2+1) || fPtr(3+1) || fPtr(4+1) || fPtr(5+1) || fPtr(6+1) || fPtr(7+1) )
         % Done only if FIR converged
            done = 0 ;
        end
    else
    
        v = v * dir ;
        pProf.ProfilePosBuf(pProf.BufCnt+1) = p + ( ( v + vold) * 0.5 * dt)  ;
        pProf.ProfileSpeedBuf(pProf.BufCnt+1) = v ;
    end

    % Output by jerk limiting filter
    fPtr = pProf.ProfilePosBuf ;
    pProf.ProfilePos = 0.125 * ( fPtr(0+1) + fPtr(1+1) + fPtr(2+1) + fPtr(3+1) + fPtr(4+1) + fPtr(5+1) + fPtr(6+1) + fPtr(7+1) ) ;
    fPtr = pProf.ProfileSpeedBuf ;
    pProf.ProfileSpeed = 0.125 * ( fPtr(0+1) + fPtr(1+1) + fPtr(2+1) + fPtr(3+1) + fPtr(4+1) + fPtr(5+1) + fPtr(6+1) + fPtr(7+1) ) ;

    pProf.Done = done  ;
end



