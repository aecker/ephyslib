%{
ae.LfpParams (lookup) # LFP parameters

min_freq        : float                 # lowpass cutoff
max_freq        : float                 # highpass cutoff
---
%}

classdef LfpParams < dj.Relvar

	properties(Constant)
		table = dj.Table('ae.LfpParams')
	end

	methods
		function self = LfpParams(varargin)
			self.restrict(varargin)
		end
	end
end
