%{
ae.Projects (manual) # Assigns stimulations to projects

project_name : ENUM("NoiseCorrAnesthesia", "RfMap") # Name of the project
---
%}

classdef Projects < dj.Relvar
    properties (Constant)
        table = dj.Table('ae.Projects');
    end
end
