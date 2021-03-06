%{
ae.LfpByTrial (computed) # LFP organized by trials

-> ae.LfpByTrialSet
-> stimulation.StimTrials
electrode_num           : tinyint unsigned  # electrode number
---
lfp_by_trial = NULL     : mediumblob        # LFP for one trial
rel_t0                  : double            # t0 of 1st LFP sample (relative to stim)
first_sample_index      : bigint            # index (in file) of first sample
%}

classdef LfpByTrial < dj.Relvar
    properties (Constant)
        table = dj.Table('ae.LfpByTrial');
    end
    
    methods 
        function makeTuples(self, key, reader)
            totalTrials = count(stimulation.StimTrials & rmfield(key, 'trial_num'));
            
            if key.trial_num < totalTrials
                switch fetch1(acq.Stimulation & key, 'exp_type')
                    case 'AcuteGratingExperiment'
                        event = 'showStimulus';
                    case {'mgrad', 'movgrad'}
                        event = 'startTrial';
                    otherwise
                        error('Don''t know which event to use to determine start of next trial!')
                end
                nextTrial = key;
                nextTrial.trial_num = nextTrial.trial_num + 1;
                endTrial = fetch1(stimulation.StimTrialEvents & nextTrial & ...
                    sprintf('event_type = "%s"', event), 'event_time');
            else
                endTrial = fetch1(stimulation.StimTrialEvents & key, 'max(event_time) -> t') + 2000;
            end
            showStim = fetch1(stimulation.StimTrialEvents & key & 'event_type = "showStimulus"', 'event_time');
            first = getSampleIndex(reader, showStim - fetch1(ae.LfpByTrialSet & key, 'pre_stim_time'));
            last = getSampleIndex(reader, endTrial);
            tuple = key;
            tuple.lfp_by_trial = reader(first:last, 1);
            tuple.rel_t0 = reader(first, 't') - showStim;
            tuple.first_sample_index = first;
            insert(self, tuple);
        end
    end
end
