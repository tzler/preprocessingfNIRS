function cfg = loadCfg(optionalInputs)
% computer specific path configurations
% information about version, updates, etc.
% and don't keep updating things on the github -- one standard script
%   

% set data directory and prefix defaults
if exist('optionalInputs') && isfield(optionalInputs,'default') && isfield(optionalInputs.default,'baseDir')
    CFG.default.baseDir = optionalInputs.default.baseDir; 
else 
    CFG.default.baseDir = '/Users/biota/science/preprocessingfNIRS'; % update this to reflect local environment! 
end
CFG.default.dataDir = sprintf('%s/data',CFG.default.baseDir ); 
CFG.default.prefix = 's'; 


% results director name and default settings
CFG.results.save = 1; 
CFG.results.saveDir = sprintf('%s/results',CFG.default.baseDir); 
CFG.results.folderName = 'settingUp'; 
CFG.results.summary = sprintf('%s/summary.txt',CFG.results.saveDir); 


% default order of functions
CFG.steps.run = {'hmrIntensity2OD'                               
                 'enPruneChannels'
                 'enPCAFilter'
                 'hmrMotionArtifactByChannel'
                 'hmrBandpassFilt'
                 'hmrOD2Conc'
                 'extractTimeCourse'};
%                 'fCOI'};              
             
% set intensity and pruning options (from Lindsey) 
CFG.pruneChan.SNRthresh = 2; 
CFG.pruneChan.SDrange = [0.0 45]; %%%%% what should this one be ? all the other's i've validated with step7.procInput.procParam
CFG.pruneChan.resetFlag = 0; 
CFG.pruneChan.dRange = [0 10000000]; 

% set PCA options
CFG.PCA.runAnalysis = 0;  % if 0, runs PCA on whole timecouse. othewise, it goes run by run. 
CFG.PCA.tailored = 0;   % if 1, uses noise to determine how much PC to remove 
%need to find a better way to validate whether these are the kinds of threshholds ... 
CFG.PCA.removeBelow = [.95, .94, .93];  
CFG.PCA.motionThreshold = [3.5, 2.75 2];  
%or you can use the default method that isn't noise adjusted
% for the moment use this: 
CFG.PCA.nSV = .97; 

% set motion artifact options (from Lindsey) 
CFG.motionArt.tMotion = 1 ; 
CFG.motionArt.tMask = 1 ;  
CFG.motionArt.std_thresh = 50; 
CFG.motionArt.amp_thresh = 5;

% set band pass filter options (from Lindsey) 
CFG.BPfilter.hpf = .01;  %%  high pass filter frequency (Hz) Typical value is 0 to 0.02.
CFG.BPfilter.lpf = .5;   %% low pass filter frequency (Hz) Typical value is 0.5 to 3.

% set optical density to concentration options (from Lindsey) 
CFG.optics.ppf = [6 6]; %  ppf: partial pathlength factors for each wavelength. If there are 2 wavelengths of data, then this is a vector ot 2 elements.

% set options for block average (from Lindsey) 
CFG.blockavg.trange = [-2 20]; % trange: defines the range for the block average [tPre tPost]

% set options for wavelet motion correction 
CFG.wavelet.iqr = 1.5; %        parameter used to compute the statistics (iqr = 1.5 is 1.5 times the
        %                       interquartile range and is usually used to detect outliers). 
        
        
% set options for enStimReject (from Lauren) 
CFG.stimReject.tRange = [-5 10]; % 'seconds' before and after ... ? 

% contrast options --specified for the script/data i was running with Grace
CFG.timecourse.extract = 1; 
CFG.timecourse.condTimes = [1050 1050 600 750 1050 1050 600 750]; % length of each condition to include in data analysis
CFG.timecourse.swapRun = 0; % set whether to replace runs
CFG.timecourse.swapWhich = [1 5]; % if swapWhich = 1, will take runs from which(2) and put them in which(1)
CFG.timecourse.swapNeeds = 3; % amount of runs which(1) needs; 
CFG.timecourse.swapLeave = 9; % amount of runs you have to leave in which(2)
CFG.timecourse.beforeRun = 2; % time betfore run starts to include in data analysis (seconds)
%CFG.timecourse.extractDetails = {[401:950],[401:950],[401:500],[401:650]}; % this is terrible. make it better :)  

% fCOI options 
% generic variables that dont need to change
CFG.fCOI.blood = {'HbO' 'HbR' 'HbT'}; 
CFG.fCOI.splits = [1 1; 1 2; 2 1; 2 2]; 
% experiment specific variables that should be specified
CFG.fCOI.compareConds = [1 2]; 
%CFG.fCOI.clusters = {1:14}; % if you want to partition the search space into different clusters: CFG.fCOI.clusters = {[1 2 3 4 5 7 8],[6 9 10 11 12 13 14]};  
CFG.fCOI.clusters = {[1 2 3 4 5 7 8],[6 9 10 11 12 13 14]};  
CFG.fCOI.bloodType = 'HbO'; % the blood type to define the fCOI
CFG.fCOI.condNames = {'faces','scenes','shortScambled','longScrambled'}; % names of the conditions  
% determine how runs will be partitioned
CFG.fCOI.automatedSplitHalf = 0; % set to '1' if you want to automate split halving of data, '0' if you dont 
CFG.fCOI.splitFilesLocation = '/Users/biota/science/autofNIRS/data/data_chopped_marked_forTyler/partitions'; % location of folder where manual partitions are 
CFG.fCOI.splitFileName = 'trialsplit.txt'; % will look for 'subjectID_splitfileName', i.e. 'subject1_trialsplit.txt'


% replace generic parameters with trial dependent ones, if specified: 
if exist('optionalInputs')
    step = fieldnames(optionalInputs);
    for iStep = 1:length(step)
        params = fieldnames(optionalInputs.(step{iStep})); 
        for iParam = 1:length(params)
            CFG.(step{iStep}).(params{iParam}) = optionalInputs.(step{iStep}).(params{iParam}); 
        end 
    end
end 

cfg = CFG; 
end