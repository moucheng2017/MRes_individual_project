%function net=resnet18()
% resnet18 version 1
% reduce resnet50 to resnet18
net=resnet50;
net = layerGraph(net);
net=removeLayers(net,{'res2c_branch2a','bn2c_branch2a','activation_8_relu','res2c_branch2b','bn2c_branch2b','activation_9_relu','res2c_branch2c','bn2c_branch2c','add_3','activation_10_relu',...
                     'res3c_branch2a','bn3c_branch2a','activation_17_relu','res3c_branch2b','bn3c_branch2b','activation_18_relu','res3c_branch2c','bn3c_branch2c','add_6','activation_19_relu',...
                     'res3d_branch2a','bn3d_branch2a','activation_20_relu','res3d_branch2b','bn3d_branch2b','activation_21_relu','res3d_branch2c','bn3d_branch2c','add_7','activation_22_relu',...
                     'res4c_branch2a','bn4c_branch2a','activation_29_relu','res4c_branch2b','bn4c_branch2b','activation_30_relu','res4c_branch2c','bn4c_branch2c','add_10','activation_31_relu',...
                     'res4d_branch2a','bn4d_branch2a','activation_32_relu','res4d_branch2b','bn4d_branch2b','activation_33_relu','res4d_branch2c','bn4d_branch2c','add_11','activation_34_relu',...
                     'res4e_branch2a','bn4e_branch2a','activation_35_relu','res4e_branch2b','bn4e_branch2b','activation_36_relu','res4e_branch2c','bn4e_branch2c','add_12','activation_37_relu',...
                     'res4f_branch2a','bn4f_branch2a','activation_38_relu','res4f_branch2b','bn4f_branch2b','activation_39_relu','res4f_branch2c','bn4f_branch2c','add_13','activation_40_relu',...    
                     'res5c_branch2a','bn5c_branch2a','activation_47_relu','res5c_branch2b','bn5c_branch2b','activation_48_relu','res5c_branch2c','bn5c_branch2c','add_16','activation_49_relu',...
                     'res5c_branch2a','bn5c_branch2a','activation_47_relu','res5c_branch2b','bn5c_branch2b','activation_48_relu','res5c_branch2c','bn5c_branch2c'});
net = connectLayers(net,'activation_7_relu','res3a_branch2a');
net = connectLayers(net,'activation_7_relu','res3a_branch1');
net = connectLayers(net,'activation_16_relu','res4a_branch2a');
net = connectLayers(net,'activation_16_relu','res4a_branch1');
net = connectLayers(net,'activation_28_relu','res5a_branch2a');
net = connectLayers(net,'activation_28_relu','res5a_branch1');
net = connectLayers(net,'activation_46_relu','avg_pool');
% add dropout layers
net = disconnectLayers(net,'activation_4_relu','res2b_branch2a');
net = disconnectLayers(net,'activation_4_relu','add_2/in2');
newlayer_1 = dropoutLayer(0.3,'Name','dropout1');
net = addLayers(net,newlayer_1);
net = connectLayers(net,'activation_4_relu','dropout1');
net = connectLayers(net,'dropout1','res2b_branch2a');
net = connectLayers(net,'dropout1','add_2/in2');
%
net = disconnectLayers(net,'activation_7_relu','res3a_branch1');
net = disconnectLayers(net,'activation_7_relu','res3a_branch2a');
newlayer_2 = dropoutLayer(0.4,'Name','dropout2');
net = addLayers(net,newlayer_2);
net = connectLayers(net,'activation_7_relu','dropout2');
net = connectLayers(net,'dropout2','res3a_branch1');
net = connectLayers(net,'dropout2','res3a_branch2a');
%
net = disconnectLayers(net,'activation_13_relu','add_5/in2');
net = disconnectLayers(net,'activation_13_relu','res3b_branch2a');
newlayer_3 = dropoutLayer(0.5,'Name','dropout3');
net = addLayers(net,newlayer_3);
net = connectLayers(net,'activation_13_relu','dropout3');
net = connectLayers(net,'dropout3','res3b_branch2a');
net = connectLayers(net,'dropout3','add_5/in2');
%
net = disconnectLayers(net,'activation_16_relu','res4a_branch1');
net = disconnectLayers(net,'activation_16_relu','res4a_branch2a');
newlayer_4 = dropoutLayer(0.5,'Name','dropout4');
net = addLayers(net,newlayer_4);
net = connectLayers(net,'activation_16_relu','dropout4');
net = connectLayers(net,'dropout4','res4a_branch1');
net = connectLayers(net,'dropout4','res4a_branch2a');
%
net = disconnectLayers(net,'activation_25_relu','add_9/in2');
net = disconnectLayers(net,'activation_25_relu','res4b_branch2a');
newlayer_5 = dropoutLayer(0.5,'Name','dropout5');
net = addLayers(net,newlayer_5);
net = connectLayers(net,'activation_25_relu','dropout5');
net = connectLayers(net,'dropout5','res4b_branch2a');
net = connectLayers(net,'dropout5','add_9/in2');
%
net = disconnectLayers(net,'activation_28_relu','res5a_branch1');
net = disconnectLayers(net,'activation_28_relu','res5a_branch2a');
newlayer_6 = dropoutLayer(0.5,'Name','dropout6');
net = addLayers(net,newlayer_6);
net = connectLayers(net,'activation_28_relu','dropout6');
net = connectLayers(net,'dropout6','res5a_branch1');
net = connectLayers(net,'dropout6','res5a_branch2a');
%
net = disconnectLayers(net,'activation_43_relu','add_15/in2');
net = disconnectLayers(net,'activation_43_relu','res5b_branch2a');
newlayer_7 = dropoutLayer(0.5,'Name','dropout7');
net = addLayers(net,newlayer_7);
net = connectLayers(net,'activation_43_relu','dropout7');
net = connectLayers(net,'dropout7','res5b_branch2a');
net = connectLayers(net,'dropout7','add_15/in2');
%
net = disconnectLayers(net,'activation_46_relu','avg_pool');
newlayer_8 = dropoutLayer(0.5,'Name','dropout8');
net = addLayers(net,newlayer_8);
net = connectLayers(net,'activation_46_relu','dropout8');
net = connectLayers(net,'dropout8','avg_pool');
%
net = removeLayers(net,{'fc1000_softmax','ClassificationLayer_fc1000'});
newLayers = [
    fullyConnectedLayer(100,'Name','fc_new1','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    fullyConnectedLayer(3,'Name','fc_new2','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
net = addLayers(net,newLayers);
net = connectLayers(net,'fc1000','fc_new1');
analyzeNetwork(net);
%end