%%  PCA_Filter (tyler's adaptation for wavelength data)

% INPUT: all in data
% y: Data matrix: rows are time points. Columns are channels as described in SD.MeasList. 
% SD: This is the source detector structure.
% tInc: A vector whose length = nTimePoints. 1 to include 0 to exclude 
% nSV: Specifies what fraction of the data should be removed; 
%
% OUTPUT: all in data
% yc: The filtered data matrix.
% svs: The singuler value spectrum from the PCA.
% nSV: This is the number of components filtered from the data.
%
% TO DO: 
% what isn't this script using only running the PCA on the good channels? 


function [data] = auto_enPCAFilter(data)

fprintf('\t\tworking on %s ... \n', mfilename)
    
y = data.procResult.dod; 
SD = data.SD; 
tInc = ones(length(data.d),1); 
nSV = data.cfg.PCA.nSV; info.nSV = nSV;
nSv = 90;               
lstInc = find(tInc==1); 
                        

        %function [yc, svs, nSV] = enPCAFilter( y, SD, tInc, nSV )

if ~exist('nSV')
    disp('USAGE: [yc,svs,nSV] = enPCAFilter( y, SD, tInc, nSV )');
    yc = [];
    svs = [];
    nSV = [];
    return
end
if any(isinf(y(:)))
    disp('WARNING: [yc,svs,nSV] = enPCAFilter( y, SD, tInc, nSV )');
    disp('      The data matrix y can not have any Inf numbers.');
    yc = [];
    svs = [];
    nSV = [];
    return
end

lstInc = find(tInc==1);

ml = SD.MeasList;
nMeas = size(ml,1);
nLambda = length(SD.Lambda);
for ii=1:nLambda
    nMeasPerLambda(ii) = length(find(ml(:,4)==ii));
end

if ~isfield(SD,'MeasListAct')
    SD.MeasListAct = ones(nMeas,1);
end

% do the PCA
ndim = ndims(y);
%
    % PCA on wavelength data
    
    if length(nSV)==1
        % apply PCA to all data
        lstAct = find(SD.MeasListAct==1);
        yc = y;
        yo = y(lstInc,lstAct);
        y = squeeze(yo);

        c = y.' * y;
        [V,St,foo] = svd(c);
        svs = diag(St) / sum(diag(St));
%        [foo,St,V] = svd(y);
%        svs = diag(St).^2/sum(diag(St).^2);        
%        figure; plot(svsc,'*-');
        if nSV<1 % find number of SV to get variance up to nSV
            svsc = svs;
            for idx = 2:size(svs,1)
                svsc(idx) = svsc(idx-1) + svs(idx);
            end        
            ev = diag(svsc<nSV);
            nSV = find(diag(ev)==0,1)-1;
        else
            ev = zeros(size(svs,1),1);
            ev(1:nSV) = 1;
            ev = diag(ev);
        end        
        yc(lstInc,lstAct) = yo - y*V*ev*V';

    elseif length(nSV)==2
        % apply to each wavelength individually
        % verify that length(nSV)==length(wavelengths)
        yc = y;
        for iW=1:2
            lstAct = find(SD.MeasListAct==1 & SD.MeasList(:,4)==iW);
            yo = y(lstInc,lstAct);
            yo = squeeze(yo);
            
            c = yo.' * yo;
            [V,St,foo] = svd(c);
            svs(:,iW) = diag(St) / sum(diag(St));
            %        [foo,St,V] = svd(y);
            %        svs = diag(St).^2/sum(diag(St).^2);
            %        figure; plot(svsc,'*-');
            if nSV(iW)<1 % find number of SV to get variance up to nSV
                svsc = svs(:,iW);
                for idx = 2:size(svs,1)
                    svsc(idx) = svsc(idx-1) + svs(idx,iW);
                end
                ev = diag(svsc<nSV(iW));
                nSV(iW) = find(diag(ev)==0,1)-1;
            else
                ev = zeros(size(svs,1),1);
                ev(1:nSV(iW)) = 1;
                ev = diag(ev);
            end
            yc(lstInc,lstAct) = yo - yo*V*ev*V';
        end

    else
        warndlg( 'enPCAFilter was not passed proper arguments', 'hmrPCAFilter' )
    end


data.procResult.dod = yc; 
data.procResult.svs = svs; 
data.tInc = tInc; 
if isempty(nSV)
    nSV = 0;
end
data.procResult.nSV = nSV; 
results = yc; 
data = updateRecord(data, mfilename, info, results); 
end
