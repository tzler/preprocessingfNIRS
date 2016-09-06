function cfg = saveResults(data,folder)
% saves results for single subjects or group data
% + suports setting result folder name in loadCfg.m or when saveResults() is called.
% + instead of overwriting files, function creates new time-stamped folders
% + updates folder names and replaces data in cfg struct for future subjects in for loop

% load result info from cfg 
cfg = data(1).cfg;

% if a folder name was specified when the function was called, use it
if exist('folder')
    resultsFolder = sprintf('%s/%s',cfg.results.saveDir,folder); 
    cfg.results.folderName = folder; % used to update folder name if necessary
else 
    resultsFolder = sprintf('%s/%s',cfg.results.saveDir,cfg.results.folderName); 
end 

multipleSubjects = length(data) > 1; 
if multipleSubjects     
    % if desired foldername exists, timestamp and create a new one
    if ~exist(resultsFolder) 
        mkdir(resultsFolder)
    else 
        resultsFolder = sprintf('%s_%s',resultsFolder, datestr(now,'HH.MM')); 
        mkdir(resultsFolder)        
    end  
    % iterate through subjects, saving in appropriate folder
    for iSubject = 1:length(data)
        subjectData = data(iSubject);
        save(sprintf('%s/%s.nirs',resultsFolder, data(iSubject).name), '-struct', 'subjectData') ; 
    end
    % update cfg struct (necessary when the filename is updated while in a for loops)
    folderUsed = resultsFolder(strfind(resultsFolder,cfg.results.folderName):end);   
    cfg.results.folderName = folderUsed;     
else 
    if ~exist(resultsFolder) 
        mkdir(resultsFolder);
    % check if individual subjectID exists in existing folder. if not, use old folder.
    elseif exist(sprintf('%s/%s.nirs',resultsFolder,data.name))
        resultsFolder = sprintf('%s_%s',resultsFolder, datestr(now,'HH.MM'));
        mkdir(resultsFolder)        
    end  
    
    save(sprintf('%s/%s.nirs',resultsFolder, data.name), '-struct', 'data');  
    fprintf('\t\tsaving results in %s/%s.nirs\n',resultsFolder,data.name)
    % update cfg struct (necessary when the filename is updated while in a for loops)
    folderUsed = resultsFolder(strfind(resultsFolder,cfg.results.folderName):end);   
    cfg.results.folderName = folderUsed; 
end
end 