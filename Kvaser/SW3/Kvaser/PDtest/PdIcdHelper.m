classdef PdIcdHelper
    %PDICDHELPER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
    end
    
    methods (Static)
		function out = buildControlWord(isPackage, isGetPackage, side)
			out = 1 + bitshift(1,13); % auto + Matlab signature on 'Reserved' field taking bits 13-14
			out = out+ 2; % motor on
			if(isPackage == 1)
				out = out + bitshift(1,3); %package
				if (isGetPackage ==1)
				  out = out +  bitshift(1,4); %get package
				end
			else
			  out = out + bitshift(1,2); %standby
			end
			switch(side)
			  case 'right'
				  out = out + bitshift(2,5);
			  case 'left'
				  out = out + bitshift(1,5);
			end
		end
		  
		function out = buildControlWordLaserReport(measuredRange_mm)
		  out = 3; %auto and motor on bits
		  out = out + bitshift(1,7) + bitshift(1,15); %laser valid, disregard control word fields
		  out = out + bitshift(measuredRange_mm*10, 16);
		end
		
		function out = buildControlWordManualMode()
			out = 0 + bitshift(1,13); % auto + Matlab signature on 'Reserved' field taking bits 13-14;
		end
	end
end

