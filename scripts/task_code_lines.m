%Lines to be called within task script

%%%%%%%%%%
%Looks for and sets up Emotiv headset
emotiv_setup
%%%%%%%%%%

%%%%%%%%%%
%Call every second or so to dump data stream into Matlab struct
%expVars.emotiv is a logical of whether or not we're collecting EEG data
if expVars.emotiv == 1
    elapsed_time = toc; %timestamp for eeg data
    %All these variables are set up verbatim in other scripts except:
    %task = what part of the task you're within (we needed it for
    %neurofeedback)
    eeg_final = emotiv_collect(eeg_final,elapsed_time,thetaPtr,alphaPtr,lowBetaPtr,highBetaPtr,gammaPtr,DataChannels,DataChannelsNames,DataChannelsNamesfull,userID_value,hData,task);
end
%%%%%%%%%%%

%%%%%%%%%%%
if expVars.emotiv == 1
    %Finalize data and disconnect from headset
    eeg_final = emotiv_save(eeg_final,hData);
end
%%%%%%%%%%%