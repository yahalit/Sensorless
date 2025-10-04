% Directory of BetEl 

% VoltExp: Make  a "Volt experiment" - identification of motor parameters without any movement 
% AnaAll    Analyze the results of L by angle determination
% AnaExp: Analyze resistance out ov V-experiment results
% AnaExp2 : Estimate L from V experiment, given R 
% AnaLoop: Analysis loop for R/L in v experiment, using AnaExp and AnaExp2
% AnaLoop2 : Analysis loop for R/L in v experiment, using AnaExp and AnaExp2, All-legs conducting version
% AtpStart : Initilize the work environment 
% AtpStartNew : Initilize the work environment , forcing target reselect 
% AtpUpdateDbase : Build parameter recorder and other databases on the basis of source project files
% CalcR(fname,seq,Deg30,doplot,VdcOverRide)  - Get motor resistance from V experiment results
% ExpLoop: Run V experiments in a loop, with various initial rotor angles
% PulseSequenceForStart - Generate a voltage pulse sequence that takes a stationary motor back to same position, zero speed
% function s = SGetState(CanId) Get the state of a controller
% SetSpeed: Set acceleration to speed in open loop mode, and activate sensorless estimator 
% motor(state,CanId) : Motor enable or disable 

% Temporary tests: 
% munk,  Untitled3,zzz, ViewEst


% Recording and Operation experiments
%%%%%%%%%%%%%%%%%%%%%%%
% RecCurs Experiment to record current loop variables
% EMFExp : Record stator voltages 
% SetAngleExp: Set the field angle of a motor to a static per-unit value (AnglePu)

% TestCmpss: Test the voltage trip limits 

% Utility 
%%%%%%%%%%
% CurrentCalibExp: Calibrate the current sensors against scope measurements
% function str = DrvVersionString( vr ) - Decompose the version parameters from the version code number
% function largestYFile = FindLatestFile(folderPath, Initials) - Find the latest version of hex file based on its version code
% function tf2 = Get2ndOrder(Ts,IsSimplepole,IsSimplezero,F1,F2,Xi1,Xi2,SimpleP,SimpleZ) Get a 2nd order filter based on its arameters
% function data = GetCfgPar( name  ): Get a configuration parameter by its name
% function [pars,misfit]  = GetDetectedSlavePars(DetectedSlaves) : Decode parameters of detected slaves through the contents of their extended identity messages
% function ent = GetEntityByVersion(projname,ver,EntityDir,workdir)  Get entity database by version number
% function str = GetFwString( nver)  Generate description string from version code
% function [ClaPars,MainPars,SimPars]=GetParams(tab) Get (sorted) parameters to fill the parameters table
% function [pf,pdb,pdeg] = GetPlantFromXls(fname,sname) Read the results of plant identification from an Excel file
% function [BESensorlessRoot,BESensorlessDir,ExeDir,EntityDir] = GetProjDirInfo(), return the source folder of the project 
% function [str,IsOperational] = GetProjTypeString( ProjType) : Get project name and if in boot state by ProjType number
% function str = GetProjectAttributesByName(strin) Get project decriptor from its name
% function list = GetProjectsList( srcDir) : Get the list of supported projects from constDef.h file 
% function  base = GetSignalsByList(proto) : Get the project specific signals for project's "GetState"
% function RecStr = GetSnap(RecNames,TypeFlags,CanId) : Get a snapped short of programmed recorder signals 
% function x = GetSignalIndex( list , cpu , recstruct ): Get the signal indices and type info out of signal names
% function srcver = GetSourceVersion(fname) : Get the source version code out of a .hex file name
% function U = GetUseCase() : Get the use case of a project 
% [fout,InsertIdx] = InsertF(pfInterp,pf): Help generate a frequency vector which can have integer amount sampling times in multiple periods 
% function [z,g] = KpKi2ZG(kp,ki) Convert Kp/Ki controller to zero and gain 
% function tf2 = Lead2(Ts,F1,F2,maxangle,Xi2,SimpleZ) : Generate an order 2 lead by parameters
% function MyErrDlg(str) Error dialog with given string and enlarged font
% function ParTable2Xls(ParFullTable,fname,Sheet): Store a parameters table in an excel file
% function DefTable = ReadDefFile(fname,WhoIsThisProject) Get project #define variables from source h file
% function THISCARD = ReadWhoIsThisProject(fname) : Read project identifier from a source file 
% classdef STimerManagerObj < handle: Class to manage the timing of periodoc-update GUI
% function SetCanComTarget(entity,Side,servo,Project,RecStruct) Set the default entity to communicate with
% function grstam(varargin) Handler for the ViewNic mouse, displays frequency + cursor data
% function msgBox(str) - Message box with enlarged text 

% Math & general 
%%%%%%%%%%%%%%%%%%
% function x = h2s(str) : get a number out of exadecimal string, that may include 0x and may be negative
% function x = h2d(str) get number from a string that may include 0x, always unsigned
% function p = WRegression(xin,yin,Nbin) Weighted linear Regression, with per-bin equilization weighting
% function y = twoside ( x , z ) : Two sided symmetric (delayless) filtering of a signal
% function [g , a,p] = fitsin( f , t , u , y , nfig) - Fit a sine of known frequency to data
% function rslt = thd ( vec , tht) :  Total harmonic distortion of a signal, given the angle 


% Sensored motor only
% CommutationExp: Make a commutation tuning experiment 
% CurrentIdentificationExp  Identify the current loop plant
% function str = DecodeHallStat(x) - Decompose the fileds of HallDecode.ComStat.fields.HallStat for Hall sensor analysis
% GetCommAnglePu ???
% function [t,x1,x2,x3] = GetTrapezeTime( s , v , a , d) : Get timing information for a trapeze trajectory with given distance (s), speed (v) , acceleration (a) and deceleration (d) 
% SpeedIdentificationExp: manage a speed plant odentification experiment
% function ViewNic(nFig,pf,fInterp,org_db, org_deg ,int_db,int_deg,M) View a Nichols chart

% Examples
% Prefilt: Example , Design a prefilter with maximal smoothness 

% junk
% kku : Test the calculation of the sensorless filter
% SinCosEq: Basic commutation calculations 
% RLFit ??

% Obsolete 
% CalibMotorCur: Calibrate motor parameters = obsolete
% function [TargetId,IntfcId] = GetTargetCanId(CanId) 
% function  Cfg = ProgCfg(fname) Read a Configuration file (jsn) and optionally program it to the robot
% function CfgStr = SaveCfg ( Cfg , fname )   reads the Cfgration from the robot and save
% SetCanComTargetByCanId SetCanComTarget with definitions selected by CAN ID
% InitDrvSetup
% VNgrtext

                                                                                                                
                                                                                                  
                                                                                                         
                                                                                                  
                                                                                                       
                                                                                                              
                                                                                            
                                                                                                                 
                                                                                                                     
                                                                                                            
                                                                                                      
                                                                                                           
					                                                                                               
                                                                                                                        
                                                                                                                        
                                                                                     
                                                                                      
                                                                                