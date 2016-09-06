%% next steps: 
% sort out annoying empty cell array issue

% let's make a flexible way to calculate time of the condition
% if we want 2 seconds before 

function choppedData = chopData(subject)

amp = 10^6; 
cfg = loadCfg(); 
for iSubject = 1:length(subject)
   
    data = subject(iSubject); 
    before = cfg.contrast.beforeRun; % 2 seconds
    condTimes = cfg.contrast.condTimes; 
    
    fs = 1/(data.t(2)-data.t(1)); 
    beforeStim = before * fs; 
    endTime = size(data.t,1);     
    % find the total time points in our data, NOT our stim 
    % for each condition 
    for iCond = 1:size(data.s,2) % this is 'j' in the previous script
       
        stimMarks{iCond} = find(data.s(:,iCond));
        for iStim = 1:length(stimMarks{iCond}) 
            
            % identify the interval we're interested in for each stim point, for each condition 
            beginPoint = stimMarks{iCond}(iStim) - beforeStim; 
            endPoint = beginPoint + condTimes(iCond) - 1; 
            blank(iCond) = length(beginPoint:endPoint); 

            % if the data contain the desired time course after the stim mark
            % extract the data we want in the desired interval  
            if endPoint < endTime
                for iChan = 1:size(data.procResult.dc,3)
                    chopped.HbO(iStim,iCond,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,1,iChan)*amp;
                    chopped.HbR(iStim,iCond,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,2,iChan)*amp;
                    chopped.HbT(iStim,iCond,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,3,iChan)*amp;
                end 
            end
        end
    end
    
    data.chopped = chopped; clear blood
    % swap data between conditions if requested 
    if cfg.contrast.swapData.please == 1
        data  = swapRuns(data); 
    end 
    
    choppedData(iSubject) = data;
end 

