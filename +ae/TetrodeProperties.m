%{
ae.TetrodeProperties (manual) # Tetrode properties

-> ae.TetrodeImplants
electrode_num   : tinyint unsigned   # electrode number
---
material        : ENUM("NiCh", "PtIr")  # tetrode material
loc_x           : float     # x coordinate
loc_y           : float     # y coordinate
%}

classdef TetrodeProperties < dj.Relvar
    properties(Constant)
        table = dj.Table('ae.TetrodeProperties');
    end
    
    methods
        function self = TetrodeProperties(varargin)
            self.restrict(varargin{:})
        end
    end
end
