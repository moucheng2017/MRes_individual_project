%u net using pretrained vgg16 backbone
net=vgg16;
lgraph=net.Layers;
lgraph=layerGraph(lgraph);
% replace all pooling layers with convolutional layers
conv_pooling1=convolution2dLayer(3,128,'Padding','same','Stride',2,'Name','conv1_transition');
lgraph = replaceLayer(lgraph,'pool1',conv_pooling1);
conv_pooling2=convolution2dLayer(3,256,'Padding','same','Stride',2,'Name','conv2_transition');
lgraph = replaceLayer(lgraph,'pool2',conv_pooling2);
conv_pooling3=convolution2dLayer(3,256,'Padding','same','Stride',2,'Name','conv3_transition');
lgraph = replaceLayer(lgraph,'pool3',conv_pooling3);
conv_pooling4=convolution2dLayer(3,512,'Padding','same','Stride',2,'Name','conv4_transition');
lgraph = replaceLayer(lgraph,'pool4',conv_pooling4);
bridge_conv1=convolution2dLayer(3,1024,'Padding','same','Stride',1,'Name','bridge-conv1');
lgraph = replaceLayer(lgraph,'conv5_1',bridge_conv1);
bridge_conv2=convolution2dLayer(3,1024,'Padding','same','Stride',1,'Name','bridge-conv2');
lgraph = replaceLayer(lgraph,'conv5_2',bridge_conv2);
lgraph = removeLayers(lgraph,{'pool5','fc6','relu6','drop6',...
                              'fc7','relu7','drop7','fc8',...
                              'prob','output'});

analyzeNetwork(lgraph);