%% example code to run automated fNIRS preprocessing pipeline -- assuming preprocessing parameters are all set in loadCfg.m    

clear all ; close all ; addpath /absolute/path/to/autofNIRS/scripts/ % and you don't want other homer scripts in the path

% specify folder where subject data (or subject folders) are 
info.folder =  '/absolute/path/to/subjectData';      % assumes 'folder' is in the baseDir specified in loadCfg.m
info.cfg.results.folderName = 'resultsFolderName';    % will save in the base directory where 'autofNIRS' is                                                                

% preprocess subject data and bring results into the workspace
data = preprocessingfNIRS(info);

% now we have a struct, 'data', which is the length of subjects in 'subjectData' 
% and contains the results from each preprocessing step in 'data(iSubject).procResults'

%% ALTERNATIVELY, variables can be set in the workspace 
clear all ; close all ; addpath /absolute/path/to/autofNIRS/scripts/                                         % make sure that other homer scripts aren't in the path 

% specify folder where subject data (or subject folders) are 
info.folder =  '/absolute/path/to/subject/data';          % assumes 'folder' is in the baseDir specified in loadCfg.m

% specify whether results will be saved and what the folderName should be 
info.cfg.results.save = 1; % if you wouldn't like to save results, set to '0' 
info.cfg.results.folderName = 'resultsFolderName';                                                                   

% specify subjects to preprocess -- if left blank will run all subjects in folder 
info.subjectList = {'subject1','subject2','subject3'};                       

% specify the length of each condition (seconds*samplingFrequency) so they can be extracted 
info.cfg.timecourse.condTimes = [1050 1050 600 750 1050 1050 600 750]; 

% specify steps to be run during preprocessing
info.cfg.steps.run    = {'hmrIntensity2OD'                
                           'hmrBandpassFilt'               
                           'enPruneChannels'
                           'hmrMotionArtifactByChannel'
                           'enPCAFilter'
                           'hmrOD2Conc'       
                           'extractTimeCourse'}; 

% specify some parameters -- all can be set in loadCfg.m
info.cfg.PCA.nSV = .97;            
info.cfg.pruneChan.SNRthresh = 2; 

% preprocess data
data = preprocessingfNIRS(info);

% extract fCOI data for further statistical testing
fCOIanalysis = functionalChannelOfInterest(data,1); 

%% plot results for fun 


nChans = length(autoData(1).SD.MeasList); 
randChan = ceil(rand * nChans/2); 
subplot(411)
plot(autoData(1).record(1).results(:,randChan));
title(sprintf('visualizing  %s results for a random channel (%d)', autoData.record(1).name,randChan)) 
subplot(412)
plot(autoData(1).record(3).results(:,randChan));
title(sprintf('visualizing  %s results for a random channel (%d)', autoData.record(3).name,randChan))
subplot(413)
plot(autoData(1).record(5).results(:,randChan));
title(sprintf('visualizing  %s results for a random channel (%d)', autoData.record(5).name,randChan))
subplot(414)
plot(autoData(1).record(6).results(:,:,randChan));
title(sprintf('visualizing  %s results for a random channel (%d)', autoData.record(6).name,randChan))
shg
