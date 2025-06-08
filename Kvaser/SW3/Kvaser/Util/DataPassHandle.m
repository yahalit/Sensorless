classdef DataPassHandle < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties (Access = public)
        DataArea 
    end

    methods
        function obj = DataPassHandle(inputArg)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            if nargin < 1 
                inputArg = [] ; 
            end 
            obj.DataArea = inputArg;
        end

        function delete(~)
        end
    end
end