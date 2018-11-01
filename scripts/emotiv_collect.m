%% emotiv_collect_test function for SRM
%%jnt January 2018

function eeg_final = emotiv_collect(eeg_final,elapsed_time,thetaPtr,alphaPtr,lowBetaPtr,highBetaPtr,gammaPtr,DataChannels,DataChannelsNames,DataChannelsNamesfull,userID_value,hData,task)

    %Each input is set up in emotiv_setup, and is saved with those names,
    %excluding:
    %   eeg_final is the struct that will become all the eeg data collected
    %   elapsed time is the amount of time since the beginning of the trial
    %       (not task) ranging from (standard) 0 to 20
    %   task is the task number (0 = rest; 1 = activate; 2 = sham)
    
    % initialize outputs:
    eeg.filt = zeros(1,17); %%raw data with high pass filter and median correction applied
    eeg.raw = zeros(1,17); %%raw eeg data
    eeg.alpha = zeros(1,16); %%alpha power
    eeg.theta = zeros(1,16); %%theta power
    eeg.gamma = zeros(1,16); %%gamma power
    eeg.highBeta = zeros(1,16); %%high Beta power
    eeg.lowBeta = zeros(1,16); %%low Beta power
    eeg.tot = zeros(1,26); %%all data collected
    mycolumn=numel(DataChannelsNamesfull);
    result =calllib('libD','IEE_DataUpdateHandle', userID_value, hData); %result = 0 if no errors returned

    nSamples = libpointer('uint32Ptr',0); %%pointer for number of samples taken from 'IEE_DataUpdateHandle'
    calllib('libD','IEE_DataGetNumberOfSample', hData, nSamples);
    nSamplesTaken = get(nSamples,'value'); %%number of samples from previous collection

    if (nSamplesTaken ~= 0) %%Only write data files if samples are taken
        dataflag=true;
        data = libpointer('doublePtr', zeros(1, nSamplesTaken)); %%pointer for each sample
        data2 = zeros(nSamplesTaken,numel(DataChannelsNames)); %%empty matrix that becomes eeg.tot

        for i = 1:mycolumn %%mycolumn = each point of data for each sample
            calllib('libD', 'IEE_DataGet', hData, DataChannels.([DataChannelsNamesfull{i}]), data, uint32(nSamplesTaken));
            data_value = get(data,'value');
            for k = 1:nSamplesTaken
                data2(k,i) = data_value(k); %list data in data2 by sample and then by column
            end   	

        end
        
        for index = 1:size(DataChannelsNames,2)
            res = calllib('libD','IEE_GetAverageBandPowers', userID_value, DataChannels.([DataChannelsNames{index}]), thetaPtr, alphaPtr, lowBetaPtr, highBetaPtr, gammaPtr);
            if res == 0 && thetaPtr.Value ~= 0
                eeg.theta(1,index) = [thetaPtr.Value];
                eeg.alpha(1,index) = [alphaPtr.Value];
                eeg.lowBeta(1,index) = [lowBetaPtr.Value];
                eeg.highBeta(1,index) = [highBetaPtr.Value];
                eeg.gamma(1,index) = [gammaPtr.Value];
            end  
        end
        eeg.theta(end,15:16) = [elapsed_time task]; %%column 15 and 16 are 15:the elapsed time since the start of the task to the first sample taken and 16:the task (0 = rest, 1 = train, 2 = sham)
        eeg.alpha(end,15:16) = [elapsed_time task];
        eeg.lowBeta(end,15:16) = [elapsed_time task];
        eeg.highBeta(end,15:16) = [elapsed_time task];
        eeg.gamma(end,15:16) = [elapsed_time task];
        eeg.tot = data2; 
        eeg.tot(:,22) = elapsed_time;
        eeg.tot(:,27) = task;
        fprintf('%d \n',eeg.theta)
        
        for row = 1:size(data2,1)
            eeg.raw(row,:) = [data2(row,1) data2(row,4:17) elapsed_time task];
        end
        
        
        eeg_final.theta = [eeg_final.theta; eeg.theta(:,1:14).^2 eeg.theta(:,15:16)]; %%The powers have to be squared from when they come off the Emotiv
        eeg_final.alpha = [eeg_final.alpha; eeg.alpha(:,1:14).^2 eeg.alpha(:,15:16)];
        eeg_final.lowBeta = [eeg_final.lowBeta; eeg.lowBeta(:,1:14).^2 eeg.lowBeta(:,15:16)];
        eeg_final.highBeta = [eeg_final.highBeta; eeg.highBeta(:,1:14).^2 eeg.highBeta(:,15:16)];
        eeg_final.gamma = [eeg_final.gamma; eeg.gamma(:,1:14).^2 eeg.gamma(:,15:16)];
        eeg_final.raw = [eeg_final.raw; (eeg.raw)];
        eeg_final.tot = [eeg_final.tot; (eeg.tot)];
        
    end
end