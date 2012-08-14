%{
ae.Test (manual) # 

blub            : int                   # 
---
bla                         : int                           # haha
%}

classdef Test < dj.Relvar
    properties(Constant)
        table = dj.Table('ae.Test');
    end
    
    methods
        function self = Test(varargin)
            self.restrict(varargin{:})
        end
    end
end
