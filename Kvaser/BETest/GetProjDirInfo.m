function [BESensorlessRoot,BESensorlessDir,ExeDir,EntityDir] = GetProjDirInfo()
% function [BESensorlessRoot,BESensorlessDir,ExeDir,EntityDir] = GetProjDirInfo(), return the source folder of the project 
BESensorlessRoot   =  '..\..\BEMain\'; 
BESensorlessDir  = [BESensorlessRoot,'Application\'] ; % 'C:\Nimrod\BHT\kvaser\PdTest\CCS';
ExeDir   = '..\..\Exe\'; 
EntityDir   = '..\..\Entity\'; 
end