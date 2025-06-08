function ExpMng = CalibNeckMgr(mgr_in) 
    ExpMng = mgr_in ; 
    ExpMng.ButtonVisibility ='off' ; 
    NeckCanId = 30; 
    LpCanId = 124 ; 
    DataType = GetDataType(); 

    switch ExpMng.NextCnt
        case 1 % Just wait NEXT button
            ExpMng.ButtonVisibility ='on' ;
        case 2 % Prep Log results
            SendObj( [hex2dec('2220'),26], 0 , GetDataType('float') , 'Home to zero'); 
            ExpMng.RecNames = {'PotFilt0','PotFilt1','UserPos'}  ; 
            ExpMng.TypeFlags = SetSnap( ExpMng.RecNames ) ;
            ExpMng.Rslt    = zeros(5,10000); 
            ExpMng.SnapCnt = 0 ; 
            ExpMng.NextCnt = 3 ; 
            ExpMng.MessageToHumanity = {'Recording: Do not touch the neck now'} ;
        case 3 % Log stationary results 
            if ( ExpMng.SnapCnt >= 5 )
                ExpMng.ButtonVisibility ='on' ;
                ExpMng.NextCnt = ExpMng.NextCnt + 1  ; 
                ExpMng.MessageToHumanity = {'Brake is released: rotate the neck MANUALLY',...
                    '90deg right, stay 1 sec,then 90 deg left, stay 1 sec',...
                    'Return to zero, Then press NEXT'} ;
            else
                roll1 = FetchObj([hex2dec('2204'),54,LpCanId],DataType.float,'Roll') ;
                r = GetSnap( ExpMng.RecNames,ExpMng.TypeFlags,NeckCanId) ; 
                roll2 = FetchObj([hex2dec('2204'),54,LpCanId],DataType.float,'Roll') ;
                roll = 0.5 * (roll1 + roll2) ;
                %r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
                ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
                ExpMng.Rslt(:,ExpMng.SnapCnt) = [roll;r.PotFilt0  ; r.PotFilt1 ; r.UserPos;ExpMng.NextCnt];
            end
        case 4
            roll1 = FetchObj([hex2dec('2204'),54,LpCanId],DataType.float,'Roll') ;
            r = GetSnap( ExpMng.RecNames,ExpMng.TypeFlags,NeckCanId) ; 
            roll2 = FetchObj([hex2dec('2204'),54,LpCanId],DataType.float,'Roll') ;
            roll = 0.5 * (roll1 + roll2) ;
            ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
            ExpMng.Rslt(:,ExpMng.SnapCnt) = [roll;r.PotFilt0 ; r.PotFilt1 ; r.UserPos;ExpMng.NextCnt];
            ExpMng.ButtonVisibility ='on' ;
        case 5
            ExpMng.NextCnt = 0 ; 
            ExpMng.Rslt = ExpMng.Rslt(:,1:ExpMng.SnapCnt);
            save  CalibNeckRslt ExpMng
            ExpMng.MessageToHumanity = {'Motion complete'} ;


            x = load('CalibNeckRslt');
            r = x.ExpMng;
            state = r.Rslt(5,:) ;
            ind   = find( (state == 4) & (r.Rslt(2,:) > 0.2)  & (r.Rslt(3,:) > 0.2) );
            roll = r.Rslt(1,ind) ;
            pot1 = r.Rslt(2,ind) ;
            pot2 = r.Rslt(3,ind) ;
            userPos = r.Rslt(4,ind) ; %#ok<NASGU> 
            pp1 = polyfit( pot1 , roll , 3 ) ; 
            pp2 = polyfit( pot2 , roll , 3 ) ; 
            pp11 = polyfit( pot1 , roll , 1 ) ; 
            pp21= polyfit( pot2 , roll , 1 ) ; 
            figure(10) ; clf 
            subplot( 2,2,1);
            plot( pot1 , roll , pot1 , polyval(pp1,pot1) ) 
            legend('roll','potentiometer #1') ; 
            subplot( 2,2,2);
            plot( pot1 , roll - polyval(pp1,pot1) ) 
            legend('Fitting error #1') ; 

            subplot( 2,2,3);
            plot( pot2 , roll , pot2 , polyval(pp2,pot2) ) 
            legend('roll','potentiometer #2') ; 
            subplot( 2,2,4);
            plot( pot2 , roll - polyval(pp2,pot2) ) 
            legend('Fitting error #2') ; 
            
            if ( std(roll - polyval(pp1,pot1) ) > 0.025 ) 
                MyErrDlg('Error in potentiometer #1 too large') ; 
                return ;
            end
            if ( std(roll - polyval(pp2,pot2) ) > 0.025 ) 
                MyErrDlg('Error in potentiometer #2 too large') ; 
                return ;
            end
            if   abs(abs(pp11(1))-8) > 2   
                MyErrDlg('Error in potentiometer #1 scale') ; 
                return ;
            end
            if   abs(abs(pp21(1))-8) > 2   
                MyErrDlg('Error in potentiometer #2 scale') ; 
                return ;
            end
            
            ButtonName = questdlg({'\fontsize{12}Pos limits should be -1.57 to 1.57',...
                'Fitting Error should not exeed 0.025','Do you approve the plot?'}, ...
                         'Decision', ...
                         'RAM','Flash', 'No', struct('Default','No','Interpreter','tex'));



            switch ButtonName
                case 'No'
                    return ; 
                case 'RAM'
                    SetCalibPar('Pot1CalibP3',pp1(1) );
                    SetCalibPar('Pot1CalibP2',pp1(2) );
                    SetCalibPar('Pot1CalibP1',pp1(3) );
                    SetCalibPar('Pot1CalibP0',pp1(4) );

                    SetCalibPar('Pot2CalibP3',pp2(1) );
                    SetCalibPar('Pot2CalibP2',pp2(2) );
                    SetCalibPar('Pot2CalibP1',pp2(3) );
                    SetCalibPar('Pot2CalibP0',pp2(4) );
                case 'Flash'
                    cpars =  SaveCalib([]) ; 
                    cpars.Pot1CalibP3 = pp1(1);
                    cpars.Pot1CalibP2 = pp1(2);
                    cpars.Pot1CalibP1 = pp1(3);
                    cpars.Pot1CalibP0 = pp1(4);

                    cpars.Pot2CalibP3 = pp2(1);
                    cpars.Pot2CalibP2 = pp2(2);
                    cpars.Pot2CalibP1 = pp2(3);
                    cpars.Pot2CalibP0 = pp2(4);
                    ProgCalib(cpars,1,struct('ProjType','Neck')); 
            end


    end
end

