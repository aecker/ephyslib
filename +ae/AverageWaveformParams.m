%{
ae.AverageWaveformParams (manual) # Parameters for average waveforms

fs      : int unsigned  # sampling rate
pre     : double        # ms pre peak
post    : double        # ms past peak
---
%}

classdef AverageWaveformParams < dj.Relvar
end
