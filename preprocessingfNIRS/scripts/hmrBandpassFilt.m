% y2 = hmrBandpassFilt( y, fs, hpf, lpf )
%
% UI NAME:
% Bandpass_Filter
%
% y2 = hmrBandpassFilt( y, fs, hpf, lpf )
% Perform a bandpass filter
%
% INPUT:
% y - data to filter #time points x #channels of data
% fs - sample frequency (Hz). If length(fs)>1 then this is assumed to be a time
%      vector from which fs is estimated
% hpf - high pass filter frequency (Hz)
%       Typical value is 0 to 0.02.
% lpf - low pass filter frequency (Hz)
%       Typical value is 0.5 to 3.
%
% OUTPUT:
% y2 - filtered data

function data = auto_hmrBandpassFilt(data)
fprintf('\t\tworking on %s ... \n', mfilename)

        %[y2,ylpf] = hmrBandpassFilt( y, fs, hpf, lpf )
cfg = data.cfg; 
v2struct(cfg.BPfilter)
info.hpf = hpf; 
info.lpf = lpf; 
y = data.procResult.dod; 
fs = 1/(data.t(2)-data.t(1)); 


% low pass filter
FilterType = 1;
FilterOrder = 3;
%[fa,fb]=butter(FilterOrder,lpf*2/fs);
if FilterType==1 | FilterType==5
    [fb,fa] = MakeFilter(FilterType,FilterOrder,fs,lpf,'low');
elseif FilterType==4
%    [fb,fa] = MakeFilter(FilterType,FilterOrder,fs,lpf,'low',Filter_Rp,Filter_Rs);
else
%    [fb,fa] = MakeFilter(FilterType,FilterOrder,fs,lpf,'low',Filter_Rp);
end
ylpf=filtfilt(fb,fa,y);


% high pass filter
FilterType = 1;
FilterOrder = 5;
if FilterType==1 | FilterType==5
    [fb,fa] = MakeFilter(FilterType,FilterOrder,fs,hpf,'high');
elseif FilterType==4
%    [fb,fa] = MakeFilter(FilterType,FilterOrder,fs,hpf,'high',Filter_Rp,Filter_Rs);
else
%    [fb,fa] = MakeFilter(FilterType,FilterOrder,fs,hpf,'high',Filter_Rp);
end

if FilterType~=5
    y2=filtfilt(fb,fa,ylpf); 
else
    y2 = ylpf;
end

data.procResult.dod = y2; 
data.procResult.ylpf = ylpf;
results = y2; 
data = updateRecord(data, mfilename, info, results); 
end
