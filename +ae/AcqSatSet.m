%{
ae.AcqSatSet (computed) # Test for saturation of data acqusition system

-> acq.Ephys
---
%}

classdef AcqSatSet < dj.Relvar & dj.AutoPopulate
    properties(Constant)
        table = dj.Table('ae.AcqSatSet');
        popRel = acq.Ephys & 'setup = 100'; % applies only to Blackrock system
    end
    
    methods 
        function self = AcqSatSet(varargin)
            self.restrict(varargin{:})
        end
    end
    
    methods (Access = protected)
        function makeTuples(self, key)
            
            br = getFile(acq.Ephys & key);
            tetrodes = getTetrodes(br);
            nTet = numel(tetrodes);
            Fs = getSamplingRate(br);
            nChans = 4;
            nSamples = size(br, 1);
            seg = 50 / 1000 * Fs;               % ms
            n = fix(nSamples / seg) * seg + 1;  % # samples/packet
            
            % if more than x% of adjacent samples have equal values, this
            % indicates saturation
            thresh = 0.05;
            
            % identify periods of saturation
            saturated = cell(nTet, nChans);
            for iTet = 1 : nTet
                fprintf('Tetrode %d\n', tetrodes(iTet))
                br = getFile(acq.Ephys & key, sprintf('t%dc*', tetrodes(iTet)));
                t = br(1 : seg : end, 't');
                for iChan = 1 : nChans
                    x = diff(br(1 : n, iChan));
                    x = reshape(x, seg, []);
                    sat = find(mean(x == 0, 1) > thresh);
                    if ~isempty(sat)
                        gaps = [0, find(diff(sat) > 1), numel(sat)];
                        saturated{iTet, iChan} = ...
                            [t(sat(gaps(1 : end - 1) + 1)); t(sat(gaps(2 : end)) + 1)]';
                    end
                end
            end
            
            % insert into database
            tuple = key;
            insert(self, tuple);
            for iTet = 1 : nTet
                for iChan = 1 : nChans
                    s = saturated{iTet, iChan};
                    for i = 1 : size(s, 1)
                        tuple = key;
                        tuple.electrode_num = tetrodes(iTet);
                        tuple.channel_num = iChan;
                        tuple.sat_start = s(i, 1);
                        tuple.sat_end = s(i, 2);
                        insert(ae.AcqSat, tuple);
                    end
                end
            end
        end
    end
end
