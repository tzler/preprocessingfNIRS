function choppedData = extractTimeCourse(data,option)
%%
output = exist('option'); 

if ~ data.cfg.timecourse.extract
    choppedData = data; 
    fprintf('\t\tWARNING: not working on %s ... \n', mfilename)
    return
else
    fprintf('\t\tworking on %s ... \n', mfilename)
end 
amp = 10^6; % suggested by Grace from Lindsey's original script
v2struct(data.cfg.timecourse)
fs = 1/(data.t(2)-data.t(1)); 
beforeStim = beforeRun * fs; 
endTime = size(data.t,1);     
blood = {'HbO' 'HbR' 'HbT'};

% find the total time points in our data, NOT our stim 
% for each condition 
for iCond = 1:size(data.s,2) 
    stimMarks{iCond} = find(data.s(:,iCond));
    for iStim = 1:length(stimMarks{iCond})             
        % identify the interval we're interested in for each stim point, for each condition 
        beginPoint = stimMarks{iCond}(iStim) - round(beforeStim); %%%%%%% had problem that was ended with rounding beforeStim ...? 
        endPoint = beginPoint + condTimes(iCond) - 1; %%%%%%%%%%%%
        blank(iCond) = length(beginPoint:endPoint); %%%%%%%%%%%%%%

        % if the data contain the desired time course after the stim mark
        % extract the data we want in the desired interval  
        if endPoint < endTime
            for iBlood = 1:length(blood)

                for iChan = 1:size(data.procResult.dc,3) % ty get rig of this loop by reshaping things 
                    tmpData.(blood{iBlood}){iCond}(iStim,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,iBlood,iChan)*amp;
                end
                % 
                if exist('extractDetails')
                    runData.(blood{iBlood}){iCond}(iStim,:,:) = tmpData.(blood{iBlood}){iCond}(iStim,:,extractDetails{iCond});
                    extendedRunData.(blood{iBlood}){iCond}(iStim,:,:) = tmpData.(blood{iBlood}){iCond}(iStim,:,:);
                else
                    runData.(blood{iBlood}){iCond}(iStim,:,:) = tmpData.(blood{iBlood}){iCond}(iStim,:,:);
                end
            end

            
%             for iChan = 1:size(data.procResult.dc,3)
%                 runData.HbO{iCond}(iStim,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,1,iChan)*amp;
%                 runData.HbR{iCond}(iStim,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,2,iChan)*amp;
%                 runData.HbT{iCond}(iStim,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,3,iChan)*amp;
%             end
%             
        else 
            fprintf('\t\t Condition %d Trial %d was excluded because of time range\n', iCond, iStim)
        end
    end
end

data.runData = runData; clear blood
% add option to export extended run data as well so lindsey can visualize
% swap data between conditions if requested 
if swapRun == 1
    data  = swapRuns(data); 
end
if output 
    choppedData = runData;
else 
    choppedData = data;
end 

end

%% old script that took the group as input, not individuals 
% function choppedData = extractTimeCourse(subject)
% fprintf('\nExtracting time courses for subject ... \n')
% amp = 10^6; % suggested by Grace from Lindsey's original script
% 
% for iSubject = 1:length(subject)
% 
%     fprintf('     %s ... ', subject(iSubject).sub_path);    
%     data = subject(iSubject); 
%     v2struct(data.cfg.timecourse)
% %    before = cfg.timecourse.beforeRun; % 2 seconds
% %    condTimes = cfg.timecourse.condTimes; 
%     fs = 1/(data.t(2)-data.t(1)); 
%     beforeStim = beforeRun * fs; 
%     endTime = size(data.t,1);     
%     % find the total time points in our data, NOT our stim 
%     % for each condition 
%     for iCond = 1:size(data.s,2) % this is 'j' in the previous script
%         stimMarks{iCond} = find(data.s(:,iCond));
%         for iStim = 1:length(stimMarks{iCond})             
%             % identify the interval we're interested in for each stim point, for each condition 
%             beginPoint = stimMarks{iCond}(iStim) - beforeStim; % had problem that was ended with rounding beforeStim ...? 
%             endPoint = beginPoint + condTimes(iCond) - 1; 
%             blank(iCond) = length(beginPoint:endPoint); 
% 
%             % if the data contain the desired time course after the stim mark
%             % extract the data we want in the desired interval  
%             if endPoint < endTime
%                 for iChan = 1:size(data.procResult.dc,3)
%                     runData.HbO{iCond}(iStim,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,1,iChan)*amp;
%                     runData.HbR{iCond}(iStim,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,2,iChan)*amp;
%                     runData.HbT{iCond}(iStim,iChan,1:blank(iCond)) = data.procResult.dc(beginPoint:endPoint,3,iChan)*amp;
%                 end 
%             else 
%                 fprintf('\n             Condition %d Trial %d was excluded because of time range', iCond, iStim)
%             end
%         end
%     end
%     
%     data.runData = runData; clear blood
%     % swap data between conditions if requested 
%     if swapRun == 1
%         data  = swapRuns(data); 
%     end 
%     
%     choppedData(iSubject) = data;
%     
% end
% fprintf('\n\nDone! ')
% end
