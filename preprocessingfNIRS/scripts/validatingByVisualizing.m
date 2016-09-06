
%% below is just visualizations to validate that my scripts are working. 

% load data created by the GUI

names = dir('~/Desktop/fNIRS/NIRS1_s02_preproc_stages/s02*'); 
for iStep = 1:length(names)
    step(iStep) = load(fullfile('~/Desktop/fNIRS/NIRS1_s02_preproc_stages/', names(iStep).name, 's02.nirs'),'-mat'); 
end

%% visualize how well overlap is between automated scripts and GUI
% could go through each step. now it's only the band pass filter step 
% data from the GUI are solid, data from the automated script is dashed
% ideally it would look like there's only one line--i.e they overlap

figure(1)
results = [5]; % only compares the band pass filter step. [1 3 5] would be all of them
hold off
for iStep = 1%:length(results)
    % iterate through channels
    for iChan = 1:size(data.procResult.dod,2)
        
        plot(original.procResult.dc(:,iChan)); 
        axis([0 length(data.t) min(min(min(data.procResult.dc))) max(max(max(data.procResult.dc)))]); 
        hold on; 
        plot(data.procResult.dc(:,iChan), '--'); 
        beginRun = nan(size(data.d(:,1))); 
        beginRun(data.stim_marks) = .1; 
        plot(beginRun,'b-'); hold off
        title(sprintf('step %d channel # %d', iStep, iChan))
       
        
       
        pause (2)
    end 
end

%% compare channels between automated scripts and the GUI (one subject)
% seems like it's an order of magnitude off 
% plus things seem off at the end, from the band pass filter error 

figure(2) 
for iChan = 1:size(data.procResult.dc,3)
    subplot(211)
    plot(squeeze(data.procResult.dc(:,:,iChan)))
    title('from automated scripts') 
    subplot(212)
    plot(squeeze(step(6).procResult.dc(:,:,iChan)))
    title('from the GUI')
    pause(3)
end 

%%
figure(2)
subplot(211)
hold off; 
timecourse = [100:1000]
scale1 = std(data.procResult.dc(:,1,1)) * 5; 
for iChan = size(data.procResult.dc,3):-1:1
    plot(data.procResult.dc(:,1,iChan) + iChan * scale1); hold on
end

subplot(212)
imagesc(data.procResult.tIncAuto'); colormap gray
