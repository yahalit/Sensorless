function ExpMng = CalibRotatorMgr(mgr_in) 
    ExpMng = mgr_in ; 
    ExpMng.ButtonVisibility ='off' ; 
    switch ExpMng.NextCnt
        case 1 % Just wait NEXT button
            ExpMng.ButtonVisibility ='on' ;
        case 2 % Prep Log results
            SendObj( [hex2dec('2220'),26], 0 , GetDataType('float') , 'Home to zero'); 
            ExpMng.RecNames = {'PotFilt0','UserPos'}  ; 
            ExpMng.TypeFlags = SetSnap( ExpMng.RecNames ) ;
            ExpMng.Rslt    = zeros(3,100000); 
            ExpMng.SnapCnt = 0 ; 
            ExpMng.NextCnt = 3 ; 
            ExpMng.MessageToHumanity = {'Recording: Do not touch the rotator now'} ;
        case 3 % Log stationary results 
            if ( ExpMng.SnapCnt >= 5 )
                ExpMng.ButtonVisibility ='on' ;
                ExpMng.NextCnt = ExpMng.NextCnt + 1  ; 
                ExpMng.MessageToHumanity = {'Brake is released',...
                    '90deg right, stay 1 sec,then 90 deg left, stay 1 sec',...
                    'Return to zero, Then press NEXT'} ;
            else
                r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
                ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
                ExpMng.Rslt(:,ExpMng.SnapCnt) = [r.PotFilt0  ; r.UserPos;ExpMng.NextCnt];
            end
        case 4
            r = GetSnap(ExpMng.RecNames,ExpMng.TypeFlags) ; 
            ExpMng.SnapCnt = ExpMng.SnapCnt + 1 ; 
            ExpMng.Rslt(:,ExpMng.SnapCnt) = [r.PotFilt0  ; r.UserPos;ExpMng.NextCnt];
            ExpMng.ButtonVisibility ='on' ;
        case 5
            ExpMng.NextCnt = 0 ; 
            ExpMng.Rslt = ExpMng.Rslt(:,1:ExpMng.SnapCnt);
            save  CalibRotatorRslt ExpMng
            ExpMng.MessageToHumanity = {'Motion complete'} ;


            x = load('CalibRotatorRslt');
            r = x.ExpMng;
            state = r.Rslt(3,:) ;
            ind   = find( state == 4);
            pot = r.Rslt(1,ind) ;
            userpos = r.Rslt(2,ind) ;
            pp = polyfit( pot , userpos , 3 ) ; 
            figure(10) ; clf 
            subplot( 2,1,1);
            plot( pot , userpos , pot , polyval(pp,pot) ) 
            legend('userpos','potentiometer') ; 
            subplot( 2,1,2);
            plot( pot , userpos - polyval(pp,pot) ) 
            legend('Fitting error') ; 

            ButtonName = questdlg({'\fontsize{12}Pos limits should be -1.57 to 1.57',...
                'Fitting Error should not exeed 0.025','Do you approve the plot?'}, ...
                         'Decision', ...
                         'RAM','Flash', 'No', struct('Default','No','Interpreter','tex'));

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
                    ProgCalib(cpars,1,struct('ProjType','Neck')); 
            end


    end
end

