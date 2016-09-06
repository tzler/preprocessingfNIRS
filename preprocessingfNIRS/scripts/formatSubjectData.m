function [SUBJECTS CFG] = formatSubjectData(inputs)

% load cfg and folder from inputs 
if isstruct(inputs) && isfield(inputs,'cfg') && isfield(inputs,'cfgName')
    cfg = feval(inputs.cfgName, inputs.cfg); 
    folder = inputs.folder; 
elseif isstruct(inputs) && ~isfield(inputs,'cfg') && isfield(inputs,'cfgName')
    cfg = feval(inputs.cfgName); 
    folder = inputs.folder; 
elseif isstruct(inputs) && isfield(inputs,'cfg') && ~isfield(inputs,'cfgName')
    cfg = loadCfg(inputs.cfg); 
    folder = inputs.folder; 
elseif isstruct(inputs) && ~isfield(inputs,'cfg')
     folder = inputs.folder;    
     cfg = loadCfg();
else
     folder = inputs; clear inputs ;  
     cfg = loadCfg();
end

if exist(fullfile('/',folder))
    inputs.location = folder; 
else
    inputs.location = sprintf('%s/%s',cfg.default.dataDir, folder);
end 

if isstruct(inputs) && isfield(inputs,'subjectList')
    inputs.name = inputs.subjectList; 
elseif isfield(inputs,'prefix') 
    tmp = dir(fullfile(inputs.location,sprintf('%s*',inputs.prefix)));
    inputs.name = {tmp.name}; 
else % if prefix or subject list isn't specific, use the default from the cfg
    tmp = dir(fullfile(inputs.location,'*.nirs')); 
    if length(tmp) == 0 
        tmp = dir(fullfile(inputs.location,sprintf('%s*',cfg.default.prefix)))
        inputs.name = {tmp.name};
    else
        inputs.name = {tmp.name};
    end 
end 

if regexp(inputs.name{1},'.nirs') % if we found subject files, and not just subject folders 
    for iSubject = 1:length(inputs.name) 
        subjects(iSubject).path = fullfile(inputs.location, inputs.name{iSubject}); 
        subjects(iSubject).name = regexprep(inputs.name{iSubject},'.nirs','');  %cut out .nirs in name
    end 
else % if we found the folders, then just save the file names
    for iSubject = 1:length(inputs.name)
        subjects(iSubject).path = fullfile(inputs.location, inputs.name{iSubject}, sprintf('%s.nirs',inputs.name{iSubject})); 
        subjects(iSubject).name = inputs.name{iSubject}; 
    end
end

% if files will be saved, make dir (if necessary) and begin to store printout from the session (which including matlab system outputs)
if cfg.results.save == 1     
    if ~exist(cfg.results.saveDir)
        mkdir(cfg.results.saveDir)
    end
    diary(cfg.results.summary);
end
       
SUBJECTS = subjects; 
CFG = cfg; 
end