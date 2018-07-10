clc
clear all
%% data preparation
ladir_train='C:\Users\NeuroBeast\Desktop\semantic segmentation\labels train';
imdir_train='C:\Users\NeuroBeast\Desktop\semantic segmentation\patches train';
ladir_validate='C:\Users\NeuroBeast\Desktop\semantic segmentation\labels validate';
imdir_validate='C:\Users\NeuroBeast\Desktop\semantic segmentation\patches validate';
imds_train = imageDatastore(imdir_train);
imds_validate =imageDatastore(imdir_validate);
classNames = ["background",...
              "tumour",...
              "healthy",...
              "others"];
pixelLabelID = [0 0 0;...
                255 0 0;...
                0 255 0;...
                0 0 255];
pxds_train = pixelLabelDatastore(ladir_train,classNames,pixelLabelID);
% imbalance data training
tbl = countEachLabel(pxds_train);
totalNumberOfPixels = sum(tbl.PixelCount);
frequency = tbl.PixelCount / totalNumberOfPixels;
inverseFrequency = 1./frequency;
%
pxds_validate = pixelLabelDatastore(ladir_validate,classNames,pixelLabelID);
%{
I = readimage(imds_train,200);
C = readimage(pxds_train,200);
B = labeloverlay(I,C);
figure
imshow(B)
%}
train = pixelLabelImageDatastore(imds_train,pxds_train);
validate = pixelLabelImageDatastore(imds_validate,pxds_validate);

%% network 
%{
lgraph = createUnet;
%stage2 down
lgraph = disconnectLayers(lgraph,'Encoder-Stage-2-ReLU-1','Encoder-Stage-2-Conv-2');
drop2=dropoutLayer(0.2,'Name','dropout-stage2');
lgraph = addLayers(lgraph,drop2);
lgraph = connectLayers(lgraph,'Encoder-Stage-2-ReLU-1','dropout-stage2');
lgraph = connectLayers(lgraph,'dropout-stage2','Encoder-Stage-2-Conv-2');
%stage3 down
lgraph = disconnectLayers(lgraph,'Encoder-Stage-3-ReLU-1','Encoder-Stage-3-Conv-2');
drop3=dropoutLayer(0.2,'Name','dropout-stage3');
lgraph = addLayers(lgraph,drop3);
lgraph = connectLayers(lgraph,'Encoder-Stage-3-ReLU-1','dropout-stage3');
lgraph = connectLayers(lgraph,'dropout-stage3','Encoder-Stage-3-Conv-2');
%stage4 down
lgraph = disconnectLayers(lgraph,'Encoder-Stage-4-ReLU-1','Encoder-Stage-4-Conv-2');
drop4=dropoutLayer(0.2,'Name','dropout-stage4');
lgraph = addLayers(lgraph,drop4);
lgraph = connectLayers(lgraph,'Encoder-Stage-4-ReLU-1','dropout-stage4');
lgraph = connectLayers(lgraph,'dropout-stage4','Encoder-Stage-4-Conv-2');
%stage1 up
lgraph = disconnectLayers(lgraph,'Decoder-Stage-1-ReLU-1','Decoder-Stage-1-Conv-2');
drop5=dropoutLayer(0.3,'Name','dropout-de-stage1');
lgraph = addLayers(lgraph,drop5);
lgraph = connectLayers(lgraph,'Decoder-Stage-1-ReLU-1','dropout-de-stage1');
lgraph = connectLayers(lgraph,'dropout-de-stage1','Decoder-Stage-1-Conv-2');
%stage2 up
lgraph = disconnectLayers(lgraph,'Decoder-Stage-2-ReLU-1','Decoder-Stage-2-Conv-2');
drop6=dropoutLayer(0.3,'Name','dropout-de-stage2');
lgraph = addLayers(lgraph,drop6);
lgraph = connectLayers(lgraph,'Decoder-Stage-2-ReLU-1','dropout-de-stage2');
lgraph = connectLayers(lgraph,'dropout-de-stage2','Decoder-Stage-2-Conv-2');
%stage3 up
lgraph = disconnectLayers(lgraph,'Decoder-Stage-3-ReLU-1','Decoder-Stage-3-Conv-2');
drop7=dropoutLayer(0.3,'Name','dropout-de-stage3');
lgraph = addLayers(lgraph,drop7);
lgraph = connectLayers(lgraph,'Decoder-Stage-3-ReLU-1','dropout-de-stage3');
lgraph = connectLayers(lgraph,'dropout-de-stage3','Decoder-Stage-3-Conv-2');
%stage4 up
lgraph = disconnectLayers(lgraph,'Decoder-Stage-4-ReLU-1','Decoder-Stage-4-Conv-2');
drop8=dropoutLayer(0.4,'Name','dropout-de-stage4');
lgraph = addLayers(lgraph,drop8);
lgraph = connectLayers(lgraph,'Decoder-Stage-4-ReLU-1','dropout-de-stage4');
lgraph = connectLayers(lgraph,'dropout-de-stage4','Decoder-Stage-4-Conv-2');
%final layers
lgraph = disconnectLayers(lgraph,'Decoder-Stage-4-ReLU-2','Final-ConvolutionLayer');
drop9=dropoutLayer(0.5,'Name','dropout-final');
lgraph = addLayers(lgraph,drop9);
lgraph = connectLayers(lgraph,'Decoder-Stage-4-ReLU-2','dropout-final');
lgraph = connectLayers(lgraph,'dropout-final','Final-ConvolutionLayer');
%}
% fully convolutional network
imageSize = [224 224];
numClasses = 4;
lgraph = fcnLayers(imageSize,numClasses,'type','8s');
classificationlayer = pixelClassificationLayer('ClassNames',tbl.Name,'ClassWeights',inverseFrequency,'Name','pixelclassification');
lgraph = removeLayers(lgraph,'pixelLabels');
lgraph = addLayers(lgraph,classificationlayer);
lgraph = connectLayers(lgraph,'softmax','pixelclassification');
%
lgraph = disconnectLayers(lgraph,'relu3_1','conv3_2');
drop3_1=dropoutLayer(0.3,'Name','dropout3-1');
lgraph = addLayers(lgraph,drop3_1);
lgraph = connectLayers(lgraph,'relu3_1','dropout3-1');
lgraph = connectLayers(lgraph,'dropout3-1','conv3_2');
%
lgraph = disconnectLayers(lgraph,'relu3_2','conv3_3');
drop3_2=dropoutLayer(0.3,'Name','dropout3-2');
lgraph = addLayers(lgraph,drop3_2);
lgraph = connectLayers(lgraph,'relu3_2','dropout3-2');
lgraph = connectLayers(lgraph,'dropout3-2','conv3_3');
%{
lgraph = disconnectLayers(lgraph,'relu3_3','pool3');
drop3_3=dropoutLayer(0.3,'Name','dropout3-3');
lgraph = addLayers(lgraph,drop3_3);
lgraph = connectLayers(lgraph,'relu3_3','dropout3-3');
lgraph = connectLayers(lgraph,'dropout3-3','pool3');
%}
lgraph = disconnectLayers(lgraph,'relu4_1','conv4_2');
drop4_1=dropoutLayer(0.4,'Name','dropout4-1');
lgraph = addLayers(lgraph,drop4_1);
lgraph = connectLayers(lgraph,'relu4_1','dropout4-1');
lgraph = connectLayers(lgraph,'dropout4-1','conv4_2');
%
lgraph = disconnectLayers(lgraph,'relu4_2','conv4_3');
drop4_2=dropoutLayer(0.4,'Name','dropout4-2');
lgraph = addLayers(lgraph,drop4_2);
lgraph = connectLayers(lgraph,'relu4_2','dropout4-2');
lgraph = connectLayers(lgraph,'dropout4-2','conv4_3');
%{
lgraph = disconnectLayers(lgraph,'relu4_3','pool4');
drop4_3=dropoutLayer(0.4,'Name','dropout4-3');
lgraph = addLayers(lgraph,drop4_3);
lgraph = connectLayers(lgraph,'relu4_3','dropout4-3');
lgraph = connectLayers(lgraph,'dropout4-3','pool4');
%}
lgraph = disconnectLayers(lgraph,'relu5_1','conv5_2');
drop5_1=dropoutLayer(0.5,'Name','dropout5-1');
lgraph = addLayers(lgraph,drop5_1);
lgraph = connectLayers(lgraph,'relu5_1','dropout5-1');
lgraph = connectLayers(lgraph,'dropout5-1','conv5_2');
%
lgraph = disconnectLayers(lgraph,'relu5_2','conv5_3');
drop5_2=dropoutLayer(0.5,'Name','dropout5-2');
lgraph = addLayers(lgraph,drop5_2);
lgraph = connectLayers(lgraph,'relu5_2','dropout5-2');
lgraph = connectLayers(lgraph,'dropout5-2','conv5_3');
%
%analyzeNetwork(lgraph);
  
%% training
opts = trainingOptions('adam', ...
    'InitialLearnRate',0.001, ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',0.01,...
    'LearnRateDropPeriod',200,...
    'MaxEpochs',10,...
    'MiniBatchSize',16,...
    'Verbose',true,...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.999,...
    'Epsilon',0.1,...
    'ValidationData',validate,...
    'L2Regularization',0.005,...
    'ValidationFrequency',30,...
    'ValidationPatience',Inf,...
    'ExecutionEnvironment','multi-gpu',...    
    'Plots','training-progress');
%'CheckpointPath','C:\Users\NeuroBeast\Desktop\network_checkpoints_0704',...
net = trainNetwork(train,lgraph,opts);
model_folder_saved= '../trained models/semantic segmentation';
model=fullfile(model_folder_saved,'fcn8_case1video1_20epochs.mat');
%model=fullfile(model_folder_saved,'Unet_vgg_case1video1.mat');
save (model,'net');
%% testing
test1=imread('C:\Users\NeuroBeast\Desktop\images_high_resolution\Testing\US\case1_video10209.jpeg');
test2=imresize(test1,[224 224]);
%[height,width,channel]=size(test1);
%predictPatchSize = [height width];
segmentedImage1 = semanticseg(test1,net);
segmentedImage2 = semanticseg(test2,net);
figure
imshow(segmentedImage1)
imwrite(segmentedImage1,'C:\Users\NeuroBeast\Desktop\results fcn\fcn8_case1video1_209_01')
%imwrite(segmentedImage1,'C:\Users\NeuroBeast\Desktop\resnet16 results\Unet_vgg_case1video1_209_01')
figure
imshow(segmentedImage2)
imwrite(segmentedImage2,'C:\Users\NeuroBeast\Desktop\results fcn\fcn8_case1video1_209_02')
%imwrite(segmentedImage2,'C:\Users\NeuroBeast\Desktop\resnet16 results\Unet_vgg_case1video1_209_02')
