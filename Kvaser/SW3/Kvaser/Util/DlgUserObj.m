classdef DlgUserObj < handle
    properties
        funchandle
        hobj
        active
        doNothing 
        r
    end
    methods
        function this = DlgUserObj( funchandle , hobj )
            this.funchandle = funchandle;
            this.hobj       = hobj ; 
            this.active     = 1 ; 
            this.doNothing  = 0 ; 
            this.r = [] ; 
        end
        function delete(this)
            if ~isempty(this.r) 
                delete(this.r) ; 
            end 
        end

        function MylistenToTimer(this, timerobj)
            this.doNothing = 1 ; 
            x1 = @(src, evt)this.MyTimerEvent(src, evt) ; 
            this.r = addlistener( timerobj, 'TimerEvent', x1 );
            this.doNothing = 0 ; 
        end
        %function onTimerEvent(this,~,~)
        function MyTimerEvent(this,~,~)
            % disp( [this.Name ' responding to TimerEvent!'] );
            if this.doNothing 
                return ; 
            end 

            try
                if this.active
                    this.funchandle(this.hobj) ; 
                end
            catch me 
                this.active = 0 ; 
                if ~isempty(this.r) 
                    delete(this.r) ; 
                    this.r = [] ; 
                end 
                disp(this.funchandle)
                disp(['Timer function deleted due to: ',me.message]) ; 
                disp( me.stack(1) ); 
                delete( this) ; 

            end
        end
    end
end


