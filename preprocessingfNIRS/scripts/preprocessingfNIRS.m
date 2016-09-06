function DATA = preprocessingfNIRS(inputs)  
%% Preprocess fNIRS data using scripts adopted from the HOMER2 GUI
% call notes4users() from the command line for more info

[subjects, cfg] = formatSubjectData(inputs); tic % load info into desired format : subjectIDs & paths, trail-specified cfg if specified 

for iSubject = 1:length(subjects)
    fprintf('Preprocessing data from subject %s ... \n', subjects(iSubject).name)  % print info for subject in progress 
     
     data = load(subjects(iSubject).path, '-mat');  % load data
     data.cfg = cfg; data.name = subjects(iSubject).name;  % populate data struct with parameters and log name
     
     analyses = cfg.steps.run ;
     for iStep = 1:length(analyses)
         try data = feval(sprintf(analyses{iStep}), data);  
         catch fprintf('\t\tWARNING: not able to run %s!\n', analyses{iStep}) ; continue
         end        
     end
     
     % import cfg struct with updated results folder name
     if cfg.results.save == 1 ;cfg = saveResults(data) ; end  
     
     % populate the results struct for this subject
     fields = fieldnames(data);
     for iField = 1:length(fields) ; DATA(iSubject).(fields{iField}) = data.(fields{iField}); end
end 

fprintf('Done! '); toc; fprintf('\n') ; diary off; 
if cfg.results.save == 1; movefile(cfg.results.summary, fullfile(data(1).cfg.results.saveDir,data(1).cfg.results.folderName)); end

end 