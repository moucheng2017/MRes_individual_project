function options = training_options(optimizer,Initial_rate,DropFactor,DropPeriod,MaxEpochs,MiniBatchSize,validate)
if (optimizer=='adam')
options = trainingOptions('adam', ...
    'InitialLearnRate',Initial_rate, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',DropFactor,...
    'LearnRateDropPeriod',DropPeriod,...
    'MaxEpochs',MaxEpochs,...
    'Shuffle','every-epoch',...
    'MiniBatchSize',MiniBatchSize,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.1,...
    'ValidationData',validate,...
    'L2Regularization',0.005,...
    'GradientThresholdMethod','l2norm',...
    'GradientThreshold',0.05,...
    'ValidationFrequency',50,...
    'ValidationPatience',Inf,...
    'ExecutionEnvironment','gpu',... 
    'Plots','training-progress');
elseif (optimizer=='sgdm')
options = trainingOptions('sgdm',...
    'InitialLearnRate',Initial_rate,...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',DropFactor,...
    'LearnRateDropPeriod',DropPeriod,...
    'Momentum',0.9,...
    'MaxEpochs',MaxEpochs,...
    'Shuffle','every-epoch',...
    'MiniBatchSize',MiniBatchSize,...
    'Verbose',true,...
    'ValidationData',validate,...
    'ValidationFrequency',50,...
    'ValidationPatience',Inf,...
    'L2Regularization',0.005,...
    'GradientThresholdMethod','l2norm',...
    'GradientThreshold',0.05,...
    'ExecutionEnvironment','gpu',... 
    'Plots','training-progress');
end
end