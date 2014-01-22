%{
ae.Test (manual) # 

blub            : int                   # 
---
bla                         : int                           # haha
%}

classdef Test < dj.Relvar
    properties (Constant)
        table = dj.Table('ae.Test');
    end
end
