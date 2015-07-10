%{
ae.AverageWaveforms (computed) # Average waveforms for all single untis

-> ephys.Spikes
-> AverageWaveformParams
---
average_waveform : blob # average waveform
%}

classdef AverageWaveforms < dj.Relvar & dj.AutoPopulate
    properties(Constant)
        popRel = ephys.Spikes
    end
    
    methods (Access = protected)
        function makeTuples(self, key)
            tuple = key;
            file = fetch1(acq.Ephys & key, 'ephys_path');
            tt = fetch1(sort.KalmanLink & key, 'electrode_num');
            br = baseReader(getLocalPath(file), sprintf('t%dc*', tt));
            Fs = getSamplingRate(br);
            spikeTimes = fetch1(ephys.Spikes & key, 'spike_times');
            
            
            % USE SUBSET OF SPIKES ONLY
            
            % ALSO HIGH-PASS-FILTER DATA TO BE COMPARABLE
            
            spikeSamples = getSampleIndex(br, spikeTimes);
            s = -ceil(key.pre * Fs / 1000) : ceil(key.post * Fs / 1000);
            samples = bsxfun(@plus, spikeSamples, s)';
            w = br(samples(:), :);
            w = reshape(w, [numel(s), numel(spikeTimes), size(w, 2)]);
            w = permute(mean(w, 2), [1 3 2]);
            w = resample(w, key.fs, Fs); % CHECK
            tuple.average_waveform = w;
            self.insert(tuple);
        end
    end
end
