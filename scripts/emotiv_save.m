function eeg_final = emotiv_save(eeg_final,hData)

%Get rid of zeros in the first row of eeg_final data
eeg_final.alpha = eeg_final.alpha(2:end,:);
eeg_final.theta = eeg_final.theta(2:end,:);
eeg_final.lowBeta = eeg_final.lowBeta(2:end,:);
eeg_final.highBeta = eeg_final.highBeta(2:end,:);
eeg_final.gamma = eeg_final.gamma(2:end,:);
eeg_final.tot = eeg_final.tot(2:end,:);
eeg_final.raw = eeg_final.raw(2:end,:);

sampRateOutPtr = libpointer('uint32Ptr',0);
calllib('libD','IEE_DataGetSamplingRate',0,sampRateOutPtr);
calllib('libD','IEE_DataFree',hData);

%%disconnect the engine (very important)
calllib('libs','IEE_EngineDisconnect');
unloadlibrary libs
unloadlibrary libD