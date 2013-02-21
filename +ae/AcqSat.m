%{
ae.AcqSat (computed) # Test for saturation of data acqusition system

-> ae.AcqSatSet
electrode_num   : tinyint unsigned  # electrode number
channel_num     : tinyint unsigned  # channel number
sat_start       : double            # start of saturation period
---
sat_end         : double            # end of saturation period 
%}

classdef AcqSat < dj.Relvar
    properties(Constant)
        table = dj.Table('ae.AcqSat');
    end
    
    methods 
        function self = AcqSat(varargin)
            self.restrict(varargin{:})
        end
    end
end
