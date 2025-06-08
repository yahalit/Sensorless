function [v,errmsg,str] = AtpAnalyze(arg, nomAmp ) 
errmsg = [] ; 
v = [] ; 
str = [] ; 
switch arg
    case 'CurrentLoop'
        r = load('AtpCurrentLoop') ; 
        r = r.r ; 
        t = r.t ; 
        subplot(2,1,1) ; 
        plot( t , r.CurrentCommandFiltered , t, r.Iq , t , r.Id); 
        xlabel('Time[Sec]');
        ylabel('Amps') ;
        legend('Command','Q current','D current') ;
        grid on 
        subplot(2,1,2) ; 
        plot( t , r.vqd , t , r.vdd )
        xlabel('Time[Sec]');
        ylabel('Volts') ;
        legend('VQ command','VD Command') ;
        grid on 
    case 'CurrentScales'
        r = load('AtpCurrentGains.mat') ; 
        r = r.r ; 
        %Ts = mean( diff(r.t )) ; 
        [~,ind] = sort(r.ThetaElect) ; 
        ThetaPu = r.ThetaElect(ind) ;

        Ia    = r.PhaseCurUncalibA(ind) ;  Ia = Ia(:); 
        Ib    = r.PhaseCurUncalibB(ind) ;  Ib = Ib(:) ;
        Ic    = r.PhaseCurUncalibC(ind) ;  Ic = Ic(:)  ;
        H = [Ia , Ib , Ic , Ic*0+1 ] ; 
        [~,s,v] = svd(H) ;
        s = diag(s) ; 
        if s(end) > min(s(1:end-1)) * 0.1 
            errmsg = 'Distorted current waveforms' ; 
            if nargout < 2
                error(errmsg) ; 
            end 
        end
        v = v(:,end) ; 
        if all(v(1:3)<0)
            v = -v ; 
        end 
        if any(v(1:3)< 0.1 ) 
            errmsg = 'Critically distorted current gains' ; 
            if nargout < 2 
                error(errmsg)
            end
        end
        %v = sqrt(v) ; 

        tht = ThetaPu(:) * 2 * pi ; 
%         Iq = (Ia .* v(1) .* cos(tht) + Ib .* v(2) .* cos(tht+2*pi/3) + Ic .* v(2) .* cos(tht+4*pi/3))/sqrt(2)  ;
%         Iref = mean(r.Iq);
%         v  = v * Iref / Iref  ; 

%         hold on ; 
%         plot( ThetaPu , ThetaPu*0-Iref ,ThetaPu , ThetaPu*0+Iref) ;

        thdvec = [thd(Ia,tht),thd(Ib,tht),thd(Ic,tht)]; 
        if ( max( thdvec(3,:) ) > 0.035)
            errmsg = ['Too big sine distortion : ',num2str(thdvec(3,:))];
            if nargout < 2 
                error( errmsg ) ; 
            end
            return ; 
        end 
        PhaseErr = (thdvec(2,:) - [0 , -2*pi/3 , 2 * pi/3]) * 180 / pi ;
        if any( abs(PhaseErr) > 8 )
            errmsg = ['Too big phase error : ',num2str(PhaseErr)];
            if nargout < 2 
                error( errmsg ) ; 
            end
            return ; 
        end

        if ( (max(thdvec(1,:))-min(thdvec(1,:)))/mean(thdvec(1,:)) > 0.05)
            errmsg = 'Bad current requlation by controller';
            if nargout < 2 
                error( errmsg ) ; 
            end
            return ; 
        end

        GainError = mean(thdvec(1,:))/nomAmp-1 ; 
        if  (abs(GainError) > 0.05)
            errmsg = ['Too big calibration required , error = ',num2str(GainError * 100 ),'%'];
            if nargout < 2 
                error( errmsg ) ; 
            end
            return ; 
        end

        if ( v(4) > 0.05)
            errmsg = ['Too much DC in current measurement : ',num2str(v(4))];
            if nargout < 2 
                error( errmsg ) ; 
            end
            return ; 
        end 

        v = v(1:3) ; 
        v = v / mean(v) * nomAmp / mean(thdvec(1,:));
        if ( 1- max(v) / min(v) ) > 0.05 
            errmsg = ['Phases are not equal : ',num2str(v)];
            if nargout < 2 
                error( errmsg ) ; 
            end
            return ; 
        end

        figure(1) ;clf
        plot( ThetaPu , Ia * v(1) , ThetaPu , Ib * v(2) , ThetaPu , Ic * v(3) ); legend('a','b','c')



%         kuku = 1 ; 

    case 'EncoderAndHalls'

        r = load('AtpComm.mat') ; 
        rslt = r.rslt ; 
        ExpMng = r.ExpMngSave ; 
        State    = rslt(4,:) ; 
        indfw    = find(State==1) ; 
        indbw    = find(State==3) ; 
        HallKeyFw = rslt(1,indfw) ; 
        HallKeyBw = rslt(1,indbw) ; 
        EncCountsFw  = rslt(2,indfw) ; 
        EncCountsBw  = rslt(2,indbw) ; 
        ThetaElectFw  = rslt(5,indfw) ; 
        ThetaElectBw  = rslt(5,indbw) ; 

        % ThetaElectFw = unwrap( ThetaElectFw * 2 * pi ) / 2 / pi ; 
        % ThetaElectBw = unwrap( ThetaElectBw(end:-1:1) * 2 * pi ) / 2 / pi ; 
        % HallKeyBw = HallKeyBw(end:-1:1) ; 
%         figure(10) ; clf
        
%         plot( ThetaElectFw , HallKeyFw + 0.05,'x', ThetaElectBw , HallKeyBw - 0.05 ,'d'  ) ; legend('Forward','Back') ; 
        LoLimit = (0:1/6:5/6) - 1/24 ; 
        HiLimit = (0:1/6:5/6) + 1/24 ; 
        
        tht = ThetaElectFw ;
        halls = HallKeyFw ; 
        thtm = zeros(1,6) ; 
        key  = zeros(1,6) - 1  ; 
        for cnt = 1:6 
            ind = find(halls ==cnt) ;  
            thth = tht(ind) ; 
            if ( any(thth < 0.17 ) && any(thth > 0.83) )
                indg = find(thth > 0.7); 
                thth(indg) = thth(indg) - 1 ; 
            end 
            thtm(cnt) = mean(thth ) ; 
        end 
        off1 = mean(sort(thtm) - (0:1/6:5/6)) ; 
        for cnt = 1:6 
            nextKey = find( (thtm(cnt)-off1 > LoLimit ) & (thtm(cnt)-off1 < HiLimit )  ) ; 
            if isempty( nextKey )
                errordlg(['Hall value of ', num2str(cnt),' is missing']) ; 
                return ; 
            end  
            key(cnt)  = nextKey ; 
        end
        OffFw   = off1 ; 
        iKeyFw = key-1 ; 
        
        tht = ThetaElectBw ;
        halls = HallKeyBw ; 
        thtm = zeros(1,6) ; 
        key  = zeros(1,6) - 1  ; 
        %ikey  = zeros(1,6) - 1  ; 
        for cnt = 1:6 
            ind = find(halls ==cnt) ;  
            thth = tht(ind) ; %#ok<*FNDSB> 
            if ( any(thth < 0.17 ) && any(thth > 0.83) )
                indg = find(thth > 0.7); 
                thth(indg) = thth(indg) - 1 ; 
            end 
            thtm(cnt) = mean(thth ) ; 
        end 
        off1 = mean(sort(thtm) - (0:1/6:5/6)) ; 
        for cnt = 1:6 
            key(cnt)  = find( (thtm(cnt)-off1 > LoLimit ) & (thtm(cnt)-off1 < HiLimit )  ) ; 
        end
        OffBw   = off1 ; 
        iKeyBw = key - 1 ; 
        
        if any( key < 1 ) 
            errmsg = 'At least one Hall key is missing'  ;
            return ;
        end 
        if ~isequal(iKeyFw,iKeyBw) 
            errmsg = 'Hall ordering unequal between directions' ; 
            return ;
        end 
        offs = mean(  [OffBw , OffFw] ) ;
        str = string(  ['Additive Offset: ', num2str(offs) ]); 
        str = [str , string(  ['Key sequence: ', num2str(iKeyBw)]  )]; 
        
%         figure(20) ; clf 
        ThetaElectFw = unwrap( ThetaElectFw * 2 * pi ) / 2 / pi ; 
        ThetaElectBw = unwrap( ThetaElectBw(end:-1:1) * 2 * pi ) / 2 / pi ; 
        EncCountsBw = EncCountsBw(end:-1:1) ; 
        
%         plot( ThetaElectFw , EncCountsFw , ThetaElectBw , EncCountsBw  );
        
        p1 = polyfit(ThetaElectFw,EncCountsFw,1) ; 
        p2 = polyfit(ThetaElectBw,EncCountsBw,1) ; 
        
        EncRes = mean([p1(1),p2(1)]) * ExpMng.npp ; 
        EncSign = sign(EncRes) ; 
        EncRes = EncRes * EncSign ; 
        elog = log2(abs(EncRes)) ; 
        if abs( elog - round(elog) ) < 0.005 
            EncRes = 2^round(elog); 
        end
        
        str = [str , string(['Estimated encoder resolution :' , num2str(EncRes)] )] ; 
        
        if ( EncSign > 0 )
            str = [str , "Encoder direction OK"] ; 
        else
            str = [str , "You MUST negate encoder direction"] ; 
        end
        
    otherwise 
        error ([arg , ' : Cannot identify test']) ; 
end

end