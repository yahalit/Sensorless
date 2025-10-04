classdef STimerManagerObj < handle
% classdef STimerManagerObj < handle: Class to manage the timing of periodoc-update GUI
    properties
        TimerCnt  
        ServiceTrackCnt 
        ServiceNames 
        r
    end
    methods
        function this = STimerManagerObj(   )
            this.TimerCnt = 0 ; 
            this.ServiceNames = {'NBIT'} ; 
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