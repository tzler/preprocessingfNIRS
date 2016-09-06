 %% Intensity_to_OD 

% Converts internsity (raw data) to optical density
% INPUT
% data : which has data.d : intensity data (#time points x #data channels%
% OUTPUT

% data : which now has data.dod: the change in optical density

function data = ty_Intensity(data)
fprintf('\t\tworking on %s ... \n', mfilename)
d = data.d; 
dm = mean(abs(d),1);
nTpts = size(d,1);
dod = -log(abs(d)./(ones(nTpts,1)*dm));
info = []; 

if ~isempty(find(d(:)<=0))
    warning( 'WARNING: Some data points in d are zero or negative.' );
end

data.procResult.dod = dod;
results = dod; 
data = updateRecord(data, mfilename, info, results); 
end 