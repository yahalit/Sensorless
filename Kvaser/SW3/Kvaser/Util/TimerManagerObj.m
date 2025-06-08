classdef TimerManagerObj < handle
    properties
        TimerCnt  
        ServiceTrackCnt 
        ServiceNames 
        r
    end
    methods
        function this = TimerManagerObj( ServiceNames  )
            this.TimerCnt = 0 ; 
            if nargin >=1
                this.ServiceNames = ServiceNames ; 
            else
                this.ServiceNames = {'BIT','TESTSW','RESCUE','PACKAGE','CAL_NECK','CAL_STEER',...
			'RECORDER','PATHDATA','GND_TRAVEL','CAL_LASER','CAL_TRAY','CAL_MAN','TEST_WARM','BRAKES','CAL_IMU'} ; 
            end 
            this.ServiceTrackCnt = zeros(1,length(this.ServiceNames)+1 ) ; 
            this.r = [] ; 
        end
        function delete(this)
            if ~isempty(this.r) 
                delete(this.r) ; 
            end 
        end

        function listenToTimer(this, timerobj)
            this.r = addlistener( timerobj, 'TimerEvent', @(src, evt) this.onTimerEvent );
        end
        
        function onTimerEvent(this)
            % disp( [this.Name ' responding to TimerEvent!'] );
            this.TimerCnt = 1 ; 
            this.ServiceTrackCnt = max( this.ServiceTrackCnt - 1 , 0 ) ; 
        end

        function SetCounter(this,name,value)
            n = find(strcmp(this.ServiceNames,name) ) ;
            if ~isempty(n) 
                this.ServiceTrackCnt(n) = value ; 
            end 
        end
        
        function cnt = GetCounter(this,name)
            cnt = [] ; 
            n = find(strcmp(this.ServiceNames,name) ) ;
            if ~isempty(n) 
                cnt = this.ServiceTrackCnt(n)  ; 
            end 
        end
        
        function cnt = IncrementCounter(this,name,inc,minval,maxval) 
            cnt = [] ; 
            n = find(strcmp(this.ServiceNames,name) ) ;
            if nargin < 3 
                inc = 2 ; 
            end 
            if nargin < 4
                minval = 0 ; 
            end 
            if nargin < 5 
                maxval = 3 ; 
            end 
            if ~isempty(n) 
                cnt = max( min(this.ServiceTrackCnt(n) + inc,maxval),minval)  ; 
                this.ServiceTrackCnt(n) = cnt ; 
            end 
        end 
    end
end