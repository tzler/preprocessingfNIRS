function swappedData = swapRuns(data)
v2struct(data.cfg.timecourse)
fprintf('\t\tworking on %s ... ', mfilename)
HbO = data.runData.HbO; % delete the one in a minute
HbR = data.runData.HbR; 
HbT = data.runData.HbT; 

change = swapWhich;
nRuns{1} = size(HbO{change(1)},1); 
nRuns{2} = size(HbO{change(2)},1); 
swapDiff = swapNeeds - length(nRuns{1}); 
% and it needs to be
if swapNeeds > nRuns{1} && swapLeave < nRuns{2} - swapDiff
    fprintf(' moving %d runs from condition %d to condition %d \n', swapDiff, change(2), change(1))
    haveRuns = nRuns{1}; 
    % swap runs, delate old locations
    while haveRuns < swapNeeds
        randomNumber = ceil(rand(1)*max(nRuns{2})); 
        HbO{change(1)}(haveRuns+1,:,:) = HbO{change(2)}(randomNumber,:,:); 
        HbR{change(1)}(haveRuns+1,:,:) = HbR{change(2)}(randomNumber,:,:); 
        HbT{change(1)}(haveRuns+1,:,:) = HbT{change(2)}(randomNumber,:,:); 
        HbO{change(2)}(randomNumber,:,:) = [];
        HbR{change(2)}(randomNumber,:,:) = []; 
        HbT{change(2)}(randomNumber,:,:) = []; % this gives us an array that has some zeros -- is that okay ??
        haveRuns = haveRuns + 1; 
    end
else 
    fprintf(' but we dont need to move anything\n')
end

data.runData.HbO = HbO; 
data.runData.HbR = HbR; 
data.runData.HbT = HbT; 
swappedData = data; 
end
