function ExpMng = CalibSteerMgr(mgr_in) 
    ExpMng = mgr_in ; 
    DataType = GetDataType(); 
    ExpMng.ButtonVisibility ='off' ; 
    switch ExpMng.NextCnt
        case 1 % Just wait NEXT button
            ExpMng.ButtonVisibility ='on' ;
        case 2 % Prep Log results
            
            % Test that the potentiometer reading near the center make any
            % fucking sense
            pot = GetSignal('PotFilt0') ; 
            if ( pot-0.4) * (pot-0.6) > 0 
                h = errordlg({'The potentiometer is not placed correctly:','Ratio reading near zero heading should be','In the 0.4 to 0.6 range',...
                    ['Was actually: ',num2str(pot)]}) ; 
                while isvalid(h) 
                    try
                        set(h,'WindowStyle','modal'); 
                    catch
                    end
                    pause(0.2) ;
                end
                ExpMng.NextCnt = 0 ; % Kill it
                ExpMng.MessageToHumanity = {'Calibration is aborted','To your service after you fix the potentiometer'} ;
                return ; 
            end
            
            % Stop thr motor 
            SendObj([0x2220,4],0,DataType.long,'Set motor enable/disable') ;
            SendObj([0x2223,8],1,DataType.long,'Dont test potentiometer matching')  ;
            SendObj([0x2220,26],0,DataType.long,'Set user position') ;
            SendObj([0x2220,4],1,DataType.long,'Set motor enable/disable') ;
            ExpMng.NextCnt = 21 ;
            ExpMng.ButtonVisibility ='on' ;
            ExpMng.MessageToHumanity = {'Use the motor controls to set the steering to EXACTLY zero','Press NEXT when done'} ;
        case 21
            ExpMng.ButtonVisibility ='on' ;
            ExpMng.MessageToHumanity = {'Use the motor controls to set the steering to EXACTLY zero','Press NEXT when done'} ;
        case 22
%            SendObj( [hex2dec('2220'),26], 0 , GetDataType('float') , 'Home to zero'); 
            ExpMng.RecNames = {'PotFilt0','UserPos'}  ; 
            ExpMng.TypeFlags = SetSnap( ExpMng.RecNames ) ;
            ExpMng.Rslt    = zeros(3,100000); 
            ExpMng.SnapCnt = 0 ; 
            ExpMng.NextCnt = 3 ; 
            ExpMng.MessageToHumanity = {'Recording: Do not touch the robot now'} ;
        case 3 % Log stationary results for the level  
            if ( ExpMng.SnapCnt >= 5 )
                ExpMng.ButtonVisibility ='on' ;
                ExpMng.NextCnt = ExpMng.NextCnt + 1  ; 
                ExpMng.MessageToHumanity = {'Use the up/down controls to go to 90deg (UP) ,',...
                     'do it with overshoot, stay 1 sec,then press NEXT'} ;
            else
                r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
                ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
                ExpMng.Rslt(:,ExpMng.SnapCnt) = [r.PotFilt0  ; r.UserPos;ExpMng.NextCnt];
                ExpMng.MessageToHumanity = {'Recording: Do not touch the robot now'} ;
            end
        case 4 % Prep Log results
            ExpMng.MessageToHumanity = {'Use the up/down controls to go to 90deg (UP) ,',...
                 'Do it with overshoot stay 1 sec,then press NEXT'} ;
            r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
            ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
            ExpMng.Rslt(:,ExpMng.SnapCnt) = [r.PotFilt0  ; r.UserPos;ExpMng.NextCnt];
            ExpMng.SnapCntOnCatch = ExpMng.SnapCnt ;
            ExpMng.ButtonVisibility ='on' ;
        case 5 % Log for the right side 
            if ( ExpMng.SnapCnt >= ExpMng.SnapCntOnCatch+5 )
                ExpMng.ButtonVisibility ='on' ;
                ExpMng.NextCnt = ExpMng.NextCnt + 1  ; 
                ExpMng.MessageToHumanity = {'Use the up/down controls to go to 90deg  (Down),',...
                     'Do it with overshoot stay 1 sec,then press NEXT'} ;
            else
                r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
                ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
                ExpMng.Rslt(:,ExpMng.SnapCnt) = [r.PotFilt0  ; r.UserPos;ExpMng.NextCnt];
                ExpMng.MessageToHumanity = {'Recording: Do not touch the robot now'} ;
            end

        case 6
            ExpMng.MessageToHumanity = {'Use the up/down controls to go to 90deg  (Down),',...
                     'Do it with overshoot stay 1 sec,then press NEXT'} ;
            r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
            ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
            ExpMng.Rslt(:,ExpMng.SnapCnt) = [r.PotFilt0  ; r.UserPos;ExpMng.NextCnt];
            ExpMng.SnapCntOnCatch = ExpMng.SnapCnt ;
            ExpMng.ButtonVisibility ='on' ;

        case 7 % Log the down 
            if ( ExpMng.SnapCnt >= ExpMng.SnapCntOnCatch+5 )
                ExpMng.ButtonVisibility ='on' ;
                ExpMng.NextCnt = ExpMng.NextCnt + 1  ; 
                ExpMng.MessageToHumanity = {'Use the up/down controls straighten the wheel (UP),',...
                     'Do it with overshoot stay 1 sec,then press NEXT'} ;
            else
                r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
                ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
                ExpMng.Rslt(:,ExpMng.SnapCnt) = [r.PotFilt0  ; r.UserPos;ExpMng.NextCnt];
                ExpMng.MessageToHumanity = {'Recording: Do not touch the robot now'} ;
            end

        case 8
            ExpMng.MessageToHumanity = {'Use the up/down controls straighten the wheel (UP),',...
                     'stay 1 sec,then press NEXT'} ;
            r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
            ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
            ExpMng.Rslt(:,ExpMng.SnapCnt) = [r.PotFilt0  ; r.UserPos;ExpMng.NextCnt];
            ExpMng.SnapCntOnCatch = ExpMng.SnapCnt ;
            ExpMng.ButtonVisibility ='on' ;

        case 9
            ExpMng.NextCnt = 0 ; 
            ExpMng.Rslt = ExpMng.Rslt(:,1:ExpMng.SnapCnt);
            save  CalibSteerRslt ExpMng
            ExpMng.MessageToHumanity = {'Motion complete'} ;
            SendObj([hex2dec('2220'),4],0,GetDataType('long'),'Set motor enable/disable') ;


            x = load('CalibSteerRslt');
            r = x.ExpMng;
            state = r.Rslt(3,:) ;
            ind   = find( state == 3);
            pot0 = mean( r.Rslt(1,ind) ) ;
            userpos0 = mean( r.Rslt(2,ind) ) ;

            ind   = find( state == 5);
            potr = mean( r.Rslt(1,ind) ) ;
            userposr = mean( r.Rslt(2,ind) ) ;
            
            ind   = find( state == 7);
            potl = mean( r.Rslt(1,ind) ) ;
            userposl = mean( r.Rslt(2,ind) ) ;

            ind   = find( (state == 4) |(state == 6)|(state == 8));
            potw = r.Rslt(1,ind) ;
            userposw =  r.Rslt(2,ind) ;
            ind = find(( potw > potr) | (potw < potl )) ; 
            potw(ind) = [] ; 
            userposw(ind) = [] ; 

            d = userposr - userposl ;

            Farsh = 0 ; 
            if ( abs( d / pi - 1 ) > 0.02)
                Farsh = 1 ; 
            end

            userposw = userposw * pi / d  ;
            userposw = userposw - ( max(userposw) + min(userposw)) / 2;  

            % Get the potentiometer positions at the stationary points 
            % plot( t , state , t , userpos )

            pp = polyfit( potw , userposw , 3 ) ; 

            figure(10) ; clf 
            subplot( 2,1,1);
            plot( potw , userposw , potw , polyval(pp,potw) , pot0 , 0,'r+',potr,pi/2,'r+',potl,-pi/2,'r+'); % 
            legend('userpos','potentiometer') ; 
            subplot( 2,1,2);
            plot( potw , userposw - polyval(pp,potw) ) 
            legend('Fitting error') ; 

            if ( Farsh)
                ButtonName = 'No';
                uiwait( errordlg ( {'Encoder difference between the two motion limits did not make sense','Either encoder is defective','Or too big backlash','or incorrect placing'},'Problem' )) ; 
            else
                ButtonName = questdlg({'\fontsize{12}Pos limits should be -1.57 to 1.57',...
                    'Fitting Error should not exeed 0.025','Do you approve the plot?'}, ...
                             'Decision', ...
                             'RAM','Flash', 'No', struct('Default','No','Interpreter','tex'));
            end

            switch ButtonName
                case 'No'
                    return ; 
                case 'RAM'
                    SetCalibPar('Pot1CalibP3',pp(1) );
                    SetCalibPar('Pot1CalibP2',pp(2) );
                    SetCalibPar('Pot1CalibP1',pp(3) );
                    SetCalibPar('Pot1CalibP0',pp(4) );
                case 'Flash'
                    cpars =  SaveCalib([]) ; 
                    cpars.Pot1CalibP3 = pp(1);
                    cpars.Pot1CalibP2 = pp(2);
                    cpars.Pot1CalibP1 = pp(3);
                    cpars.Pot1CalibP0 = pp(4);
                    ProgCalib(cpars,1,struct('ProjType','Steer')); 
            end


    end
end

