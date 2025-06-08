function [str,reply] = SpiEmcyPack(  cmd , DoTx ) 
% function [str,reply] = SpiEmcyPack( cmd , DoTx ) 
% Produce an emergency package activation 
% Arguments: 
% cmd : Struct of attributes 
% DoTx : 0: Just prepare message, 1: Transmit to matlab simulation, 2:

if ( nargin < 2 ) 
    DoTx = 1 ; 
end 

Geo = struct ( 'XDistWheelShoulderPivot', 0.24, 'YDistWheelShoulderPivot' , 0.28  ) ;

actions = struct('None', 0 , 'Standby' , 1 , 'Repush' , 2 , 'GetRetry' , 3 , 'Laser' , 4 , 'Reset' , 8 ,'RstCmd' , 15 ) ; 
sides   = struct('Right', 2 , 'Left' , 1 ) ; 
dfltcmd = struct ('OpCode',8 , ...
    'Action' ,actions.None,  'Side' , sides.Right , ...
    'PackageDepth' , 0.15 ,'PackageXOffset' , -(Geo.XDistWheelShoulderPivot+0.335) , ...
    'IncidenceDeg' , 6 ,'Get' , []) ; % Just get a status report

if   ~isfield( cmd, 'Action'  ) 
    error ('Specification should include Action field') ; 
end 

cmd = MergeStruct( dfltcmd , cmd ,1  ); 

cmd.Incidence = cmd.IncidenceDeg * pi / 180 ; 

[str,reply] = SendSpiSim( cmd ,0 , DoTx  ); 