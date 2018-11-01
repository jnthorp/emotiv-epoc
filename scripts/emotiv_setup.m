%%Emotiv Setup
w = warning ('off','all');
enuminfo.IEE_DataChannels_enum = struct('IED_COUNTER', 0, 'IED_INTERPOLATED', 1, 'IED_RAW_CQ', 2,'IED_AF3', 3, 'IED_F7',4, 'IED_F3', 5, 'IED_FC5', 6, 'IED_T7', 7,'IED_P7', 8, 'IED_Pz', 9,'IED_O2', 10, 'IED_P8', 11, 'IED_T8', 12, 'IED_FC6', 13, 'IED_F4', 14, 'IED_F8', 15, 'IED_AF4', 16, 'IED_GYROX', 17,'IED_GYROY', 18, 'IED_TIMESTAMP', 19,'IED_MARKER_HARDWARE', 20, 'IED_ES_TIMESTAMP',21, 'IED_FUNC_ID', 22, 'IED_FUNC_VALUE', 23, 'IED_MARKER', 24,'IED_SYNC_SIGNAL', 25);
enuminfo.IEE_MentalCommandTrainingControl_enum = struct('MC_NONE',0,'MC_START',1,'MC_ACCEPT',2,'MC_REJECT',3,'MC_ERASE',4,'MC_RESET',5);

% Column names in the final files
DataChannels = enuminfo.IEE_DataChannels_enum;
DataChannelsNames = {'IED_AF3', 'IED_F7', 'IED_F3', 'IED_FC5', 'IED_T7','IED_P7', 'IED_Pz','IED_O2', 'IED_P8', 'IED_T8', 'IED_FC6', 'IED_F4', 'IED_F8', 'IED_AF4'};
DataChannelsNamesfull ={'IED_COUNTER','IED_INTERPOLATED','IED_RAW_CQ','IED_AF3','IED_F7','IED_F3','IED_FC5','IED_T7','IED_P7','IED_Pz','IED_O2','IED_P8','IED_T8','IED_FC6','IED_F4','IED_F8','IED_AF4','IED_GYROX','IED_GYROY','IED_TIMESTAMP','IED_MARKER_HARDWARE','IED_ES_TIMESTAMP','IED_FUNC_ID','IED_FUNC_VALUE','IED_MARKER','IED_SYNC_SIGNAL'};
clc
    %%full path names for each library loaded
    try
        loadlibrary('C:/Users/adcocklab/Documents/MATLAB/community-sdk-master/bin/win32/edk.dll','C:/Users/adcocklab/Documents/MATLAB/community-sdk-master/include/Iedk.h','addheader','IedkErrorCode.h','addheader','IEmoStateDLL.h','addheader','FacialExpressionDetection.h','addheader','MentalCommandDetection.h','addheader','IEmotivProfile.h','addheader','EmotivLicense.h','alias','libs'); 
        loadlibrary('C:/Users/adcocklab/Documents/MATLAB/community-sdk-master/bin/win32/edk.dll','C:/Users/adcocklab/Documents/MATLAB/community-sdk-master/include/IEegData.h','addheader','Iedk.h','alias','libD');
    catch
        loadlibrary('C:/Users/activate-ccn/Documents/MATLAB/community-sdk-master/bin/win32/edk.dll','C:/Users/activate-ccn/Documents/MATLAB/community-sdk-master/include/Iedk.h','addheader','IedkErrorCode.h','addheader','IEmoStateDLL.h','addheader','FacialExpressionDetection.h','addheader','MentalCommandDetection.h','addheader','IEmotivProfile.h','addheader','EmotivLicense.h','alias','libs'); 
        loadlibrary('C:/Users/activate-ccn/Documents/MATLAB/community-sdk-master/bin/win32/edk.dll','C:/Users/activate-ccn/Documents/MATLAB/community-sdk-master/include/IEegData.h','addheader','Iedk.h','alias','libD');
    end
    
eEvent = calllib('libs','IEE_EmoEngineEventCreate');%1
default = int8(['Emotiv Systems-5' 0]);
AllOK = calllib('libs','IEE_EngineConnect','Emotiv Systems-5'); %%AllOK == 0 if no errors
sampFreq = 256;
EDK_OK=0;
rectime=0.2;
hData = calllib('libD','IEE_DataCreate');
calllib('libD','IEE_DataSetBufferSizeInSec',rectime)
readytocollect = false;
cnt = 0;

%Pointers for each of the power bands
thetaPtr = libpointer('doublePtr', 0);
alphaPtr = libpointer('doublePtr', 0);
lowBetaPtr = libpointer('doublePtr', 0);
highBetaPtr = libpointer('doublePtr', 0);
gammaPtr = libpointer('doublePtr', 0);

%Getting each of the eeg_final matrices ready
eeg_final.filt = zeros(1,17);
eeg_final.raw = zeros(1,17);
eeg_final.alpha = zeros(1,16);
eeg_final.theta = zeros(1,16);
eeg_final.gamma = zeros(1,16);
eeg_final.highBeta = zeros(1,16);
eeg_final.lowBeta = zeros(1,16);
eeg_final.tot = zeros(1,27);

state = 2;
%%This part takes a while, the engine has to ping the headset for a while to
%%find it without any erros, but once it does it will continue to collect
%%without any interruptions
while readytocollect == false
    state = calllib('libs','IEE_EngineGetNextEvent',eEvent); % state = 0 if no errors
    if(state==EDK_OK)
        eventType = calllib('libs','IEE_EmoEngineEventGetType',eEvent);
        userID=libpointer('uint32Ptr',0);
        calllib('libs','IEE_EmoEngineEventGetUserId',eEvent, userID);

        if (strcmp(eventType,'IEE_UserAdded') == true)
            userID_value = get(userID,'value');
            calllib('libD','IEE_DataAcquisitionEnable',userID_value,true);      
            readytocollect = true;
        end
    end
end