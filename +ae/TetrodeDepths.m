%{
ae.TetrodeDepths (manual) # Tetrode depths

-> ae.TetrodeProperties
-> acq.Ephys
---
depth           : float     # tetrode depth below cortical surface
%}

classdef TetrodeDepths < dj.Relvar
    properties(Constant)
        table = dj.Table('ae.TetrodeDepths');
    end
    
    methods
        function self = TetrodeDepths(varargin)
            self.restrict(varargin{:})
        end
    end
end
