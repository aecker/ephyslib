%{
ae.LfpByTrialProjects (manual) # Mapping from parameters to projects

-> ae.Projects
---
%}

classdef LfpByTrialProjects < dj.Relvar
    properties (Constant)
        table = dj.Table('ae.LfpByTrialProjects');
    end
end
