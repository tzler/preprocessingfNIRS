function notes4users()
% 
% using the homer2 scripts as a base 
%
%
%
%
% % % % % % % % % % % % % %  SEVERAL EXAMPLES OF CODE TO RUN AUTOMATED PREPROCESSING % % % % % % % % % % % % % % % % % % % % % % % % 
%
% % % % % % % % % % % % % % % % 1. minimal inputs, relies on defaults                            
%
% addpath ~/Desktop/autofNIRS/testScripts/               % add location of automated scripts to path                         
% info.folder = 'folderName';                            % tell scripts where to look for the data to preprocess          %  
% prepped = preprocessingfNIRS(info);                    % run procprcessing 
%                                                        % in this case, specifics are set in loadCfg.m:  
%                                                        % will look in CFG.default.baseDir/data/dataFolderName for the data  
%                                                        % will load all files matching string given by CFG.default.prefix
%                                                        % will run preprocessing steps defined by CFG.steps.run
%
% % % % % % % % % % % % 2. use alternate defaults, only work on several subjects                                                       
%
% addpath ~/Desktop/autofNIRS/testScripts/    
% info.folder = '/absolute/path/to/folderName' ;         % don't rely on folder structure specified in cfg file % 
% info.cfgName = 'differentCfg';                         % loads a different cfg file you've created named 'differentCfg'% 
% info.subjectList = {'s01', 's02', 's06'}               % only preprocesses data from these subjects
% data = preprocessingfNIRS(info)                        % run preprocessing 
%
% 
% % % % % % % % % % % % % % % 3.update only some parameters, set where to save data
%
% addpath ~/Desktop/autofNIRS/testScripts/
% info.folder = 'folderName';
% info.cfg.PCA.nSV = .97;                                % set PCA filter to extract 97% of variance  
% info.results.save = 1;                                 % set data to be saved once completed 
% info.results.folderName = 'resultsFolder'              % set output folder name  
% data = preprocessingfNIRS(info)
%
%
% % % % % % % % % % % 4. set functions to use from command window
%
% addpath ~/Desktop/autofNIRS/testScripts/
% inputs.folder = 'folderName';
% inputs.cfg.steps.run = {'hmrIntensity2OD'                               
%                         'enPCAFilter'
%                         'hmrBandpassFilt'
%                         'hmrOD2Conc'}; 
% data = preprocessingfNIRS(inputs)
%
% % % % % % % % % % % % % % % % % % % % % % % % % SETTING UP  ENVIRONMENT % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  
%                                                                                                                                         
% script defaults to loading parameters from loadCfg.m 
%      -this file sets which preprocessing steps will run, in which order, and what the parameter for those steps will be 
%      -there are at least two lines that need to be updated in loadCfg.m to run on each unique study: 
%           CFG.default.baseDir : set this to the absolute path of the parent directory where the data are housed                 
%           CFG.default.prefix  : set this to the prefix of the subject data that the function will look for.                     
%               if data file names are 's01.nirs', 's02.nirs', etc., then the prefix is 's'                    
%               if data file names are irregular, include them in the commmand line before running scripts     
%                i.e. >> info.subjectList = {'firstName', 'sub2', 'thi3Dsub'}          
%
% those defaults can be changed in three ways: 
%       1. by updating those options from the command window, before running scipts, which will update parameters for this iteration only 
%            e.g. >> inputs.cfg.PCA.nSV = .97 updates the PCA filter to remove 97% of variance % 
%       2. by changing the default settings in loadCfg.m
%            matching not only the parameters for each function, but also which folder structures are best 
%       3. by defining a new cfg file and calling that file from the command line before proprocessing
%            e.g. >> inputs.cfgName = 'differentCfg'
%
% calling preprocessingfNIRS(), or by changing the loadCfg.m file directly. command window changes are temporary, while updating    %
% the loadCfg.m file changes the defaults. there are only a couple of defaults that must be changed to work within the local        %  
% environment, and they are all in the very beginning of loadCfg.m
%
%             CFG.default.baseDir : set this to the absolute path of the parent directory where the data are housed                 %
%             CFG.default.prefix  : set this to the prefix of the subject data that the function will look for.                     %
%                                   if data file names are 's01.nirs', 's02.nirs', etc., then the prefix is 's'                     % 
%                                   if data file names are irregular, include them in the commmand line before running scripts      %
%                                                                i.e. info.subjectList = {'firstName', 'sub2', 'thi3Dsub'}          %
%
%             if no other changes are made, pipeline will assume that there is a a parent folder specified by CFG.default.baseDir   %
%             that contains 'data', which contains the folder name specified at the command line that contains the data. e.g.:      %
%                                                                                                                                   %
%             in loadCfg.m, if  CFG.default.baseDir = '~/Desktop/autofNIRS' and CFG.default.prefix = 'testSubject'                  %
%             then preprocessing data using the commands   
%                   info.folder = 'dataFolderName';                                                                                 %
%                   prepped = preprocessingfNIRS(info);   
%             will look in ~/Desktop/autofNIRS/data/dataFolderName for any files beginning with 'testSubject',    visually:         % 
%                                                                                                                                   %    
%                                                           CFG.default.baseDir         : set in loadCfg.m                          %
%                                                                     |                                                             % 
%                                                                  'data'               : default setting                           %
%                                                                     |                                                             %
%                                                               info.folder             : set in command window                     % 
%                                                                     |   
%                                                            CFG.default.prefix         : set in loadCfg.m                          %
%
%             the scripts are able to support one of two file folder structures: 
%             either all data is in one folder, or each subject's data is in a folder with the same name, i.e.: 
%                                              
%
%                                                                               | 
%                                                                         info.folder      
%                                            |                            /  /  |  \  \
%                                        info.folder          OR        s01    ...     sN 
%                                       /  /  |  \  \                  /                \ 
%                                  s01.nirs  ...   sN.nirs        s01.nirs    ...      sN.nirs
%
%

%
%
%
%   more generally, using these scripts requres 
%
%       1. a recent version of matlab (2014b was used to generate these scripts) 
%
%       2. .nirs files that contain the same raw inputs the homer GUI would need--d, SD, etc....   
%
%       4. updating loadCfg.m to reflect your local data structure 
%                 cfg.default.prefix = 'PREFIX';                    
%                           e.g: 's' for filenames like s01.nirs, s02.nirs, etc. 
%                 cfg.default.baseDir = '/PATH/TO/LOCATION/CONTAINING/DATA/FOLDER'; 
%
% % % % % % % % % % % % % % % % % % % % CHANGING DEFAULTS FROM THE COMMAND WINDOW % % % % % % % % % % % % % % % % % % % % % % % % % %
%
%
%  
%     including parameter information within a single struct from the command window will temporarally change defaults, e.g.:     
%               info.folder = 'dataFolderName';
%               info.cfg.PCA.nSV = .95; 
%               info.cfg.timecourse.extract = 1; 
%               info.cfg.BPfilter.hpf = .01; 
%               info.cfg.wavelet.iqr = 1.5;
%                                  etc. 
%                                  etc.                     
%               preppedData = preprocessingfNIRS(info); 
%
%              if you want to make long term changes,manually update the loadCfg.m FILE 
%
%
%         preprocessingfNIRS.m     
%           MINIMUM INPUTS:     name of folder containing .nirs files              
%                                   e.g. >> folder = 'myBaseDir' 
%                                        >> preppedData = preprocessingfNIRS(folder) 
%                               if specifying trial specific preprocessing options, you'll need to place them all in a struct. 
%                                   e.g. >> input.folder = 'myBaseDir'; 
%                                        >> input.cfg.PCA.nSV = .97; 
%                                        >> preppedData = preprocessingfNIRS(inputs);
%
%           POSSIBLE INPUTS:    trial specific options for each step                 
%           FUNCTION:           does all preprocessing steps 
%           OUTPUTS:            preprocessedData  
%
%
%         loadCfg.m
%           FUNCTION:           populates the workspace with options that preprocessing will need, including: 
%
%                                          pruneChan:
%                                                PCA:
%                                          motionArt: 
%                                           BPfilter:             
%                                             optics: 
%                                           blockavg:
%                                            wavelet:
%                                         timecourse:
%
%
%
%
%
%         formatSubjectData.m    
%           FUNCTION:           loads folder and trial specific cfg data into necessary formats
%           MINIMUM INPUTS:     a folder passed by preprocessingfNIRS.m containing data location
%           POSSIBLE INPUTS:                 trial specific preprocessing options 
%                                            e.g. PCA.nSV = .97 (removes 97% of variance with the PCA filter 
%           OUTPUTS:            [cfg subject] info containing options, file paths, and subject names 
%
%
%         extractTimeCourse.m
%           FUNCTION:           cut preprocessed data and sort by condition
%           MINIMUM INPUTS:     the output of auto_hmrOD2Conc.m (hemoglobin concentrations)
%                               set cfg file to extract time course 
%                                       e.g. 
%                                        >> cfg.timecourse.extract = 1;
%                               relay duration of condition times (in fs)
%                                       e.g. cfg.timecourse.condTimes = [1050 1050 600 750 1050 1050 600 750]
%                                       e.g. runData.HmO{iCondition}(iTrial,iHemoType,iChannel)
%                                        >> cfg.timecourse.swapRun = 1;         % set whether to replace runs
%                                        >> cfg.timecourse.swapWhich = [1 5];   % if please = 1, will take runs from which(2) and put them in which(1)
%                                        >> cfg.timecourse.swapNeeds = 3;       % amount of runs which(1) needs; 
%                                        >> cfg.timecourse.swapLeave = 9;       % amount of runs you have to leave in which(2)
%                                        >> cfg.timecourse.beforeRun = 2;       % time betfore run starts to include in data analysis (seconds)
%           POSSIBLE INPUTS:    allows you to swap runs between conditions if one set hasn't met some minimim amount 
%                                       
%
%           OUTPUTS:            struct containing hemoglobin concentration data by condition, run, and trail 
%                                           runData.HbO{iCondition}(iTrial,iHemoType,iChannel) 
%                                           runData.HbR{iCondition}(iTrial,iHemoType,iChannel) 
%                                           runData.HbT{iCondition}(iTrial,iHemoType,iChannel)  
%
%         swapRuns.m
%           FUNCTION:           moves runs from one condition to another, if asked
%                                               see notes on extractTimeCourse.m                   
% 
%         updateRecord.m
%           FUNCTION:           keeps a log of the order of preprocessing, as well as the parameters used   
% 
%         v2struct.m            a very helpful script created by Adi Navve
%           FUNCTION:           used here to bring variables from the cfg file into the workspace for functions 
% 
     type('notes4users.m')
%           FUNCTION:           to bring forth the (infra-red) light and dispell non-significant p-values
%           INPUTS:             ignorange
%           POSSIBLE INPUTS:    gratitude  
%           OUTPUTS:            knowledge
% 



%       an inventory of the supported HOMER2 scripts and their dependencies you need to have in your path: 
%
%
%
%                         auto_calibratedPCAFilter.m
%                         auto_hmrIntensity2OD.m			
%                         auto_hmrMotionArtifactByChannel.m	
%                         auto_hmrMotionCorrectWavelet.m		
%                               NormalizationNoise.m			
%                               WT_inv.m				
%                               WaveletAnalysis.m
%                               MakeFilter.m				
%                               IWT_inv.m				
%                         auto_hmrOD2Conc.m	
%                               GetExtinctions.m			
%                         auto_enPCAFilter.m			
%                         auto_enPruneChannels.m							
%                         auto_hmrBandpassFilt.m					
%                         auto_hmrBlockAvg.m			
%
%
end 