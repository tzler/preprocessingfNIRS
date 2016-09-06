%% example code that runs automated fNIRS preprocessing pipeline  

% first, let's assume that the preprocessing parameters are all set in scripts/loadCfg.m    

% let's add the automated preprocessing scripts to the path
addpath /absolute/path/to/autofNIRS/scripts/ 

% then specify folder where subject data are 
info.folder =  'subjectDataFolder';                           % assumes 'folder' is in the baseDir specified in loadCfg.m. alternatly, can give it an absolute path to the 'subjectData'

% preprocess subject data and bring results into the workspace
data = preprocessingfNIRS(info);

% now we have a struct, 'data', which is the length of subjects in 'subjectData' 
% with the results stored in the same place homer would have, e.g. data.procResult.dod
% if, in the loadCfg file, info.cfg.results.save = 1, then these results will be saved in location specified there

%% ALTERNATIVELY, we can run the same code, but explicitly set some variables in the workspace 

clear all ; close all ; addpath /absolute/path/to/autofNIRS/scripts/                                         

% specify folder where subject data (or subject folders) are 
info.folder =  '/absolute/path/to/subject/data';          % assumes 'folder' is in the baseDir specified in loadCfg.m

% specify whether results will be saved and what the folderName should be 
info.cfg.results.save = 1; % if you wouldn't like to save results, set to '0' 
info.cfg.results.folderName = 'resultsFolderName';                                                                   

% specify subjects to preprocess -- if left blank will run all subjects in folder 
info.subjectList = {'subject1','subject2','subject3'};                       

% specify the length of each condition (seconds*samplingFrequency) so they can be extracted for further analysis  
info.cfg.timecourse.condTimes = [cond1length cond2length cond3length cond4length]; % eg. [1050 800 1050 600]

% specify steps to be run during preprocessing
info.cfg.steps.run    = {'hmrIntensity2OD'                
                           'hmrBandpassFilt'               
                           'enPruneChannels'
                           'hmrMotionArtifactByChannel'
                           'enPCAFilter'
                           'hmrOD2Conc'
                           'extractTimeCourse'}; 

% specify some other parameters 
info.cfg.PCA.nSV = .97;            
info.cfg.pruneChan.SNRthresh = 2; 

% preprocess data
data = preprocessingfNIRS(info);

%% let's visualize some results from 'data', just to familiarize ourselves with the format

randSubject = ceil(rand*length(data));
nChans = size(data(randSubject).procResult.dc,3);
randChannel = ceil(rand*nChans);
subplot(1,3,1) 
plot(data(randSubject).d(:,randChannel)); 
title(sprintf('raw intensity data from channel %d subject %s',randChannel,data(randSubject).name))
subplot(1,3,2) 
plot(data(randSubject).procResult.dod(:,randChannel)); 
title(sprintf('preprocessed OD data from channel %d subject %s',randChannel,data(randSubject).name))
subplot(1,3,3) 
plot(data(randSubject).procResult.dc(:,:,randChannel)); 
title(sprintf('oxi, deoxy, and total blood concentration data from channel %d subject %s',randChannel,data(randSubject).name))
shg 