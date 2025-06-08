classdef DlgTimerObj < handle
    properties
        theTimer
    end
    events
        TimerEvent
    end
    methods
        function this = DlgTimerObj
            this.theTimer = timer( ...
                'ExecutionMode', 'fixedSpacing', ...
                'Period', GetAtpTimerPeriod(), ...
                'TimerFcn', @(src, evt) this.notify( 'TimerEvent' ) );
            start(this.theTimer);
        end
        function delete(this)
            stop(this.theTimer);
            delete( this.theTimer ) ; 
        end
    end
end

