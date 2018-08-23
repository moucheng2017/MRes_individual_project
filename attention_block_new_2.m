function layers = attention_block_new_2(tag,channels,upsamplingRatio)
% compatability score version
layers = [
    transposedConv2dLayer(upsamplingRatio,channels,'Stride',upsamplingRatio,'Name',[tag,'_compatability_mapping'])
    additionLayer(2,'Name',[tag,'_attention_addition'])  
    batchNormalizationLayer('Name',[tag,'_attention_BN'])
    reluLayer('Name',[tag,'_attention_relu'])
    convolution2dLayer(1,channels,'Stride',1,'Padding','same','Name',[tag,'_compatability_mapping_phi'])
    softmaxLayer('Name',[tag,'_attention_softmax'])
    depthConcatenationLayer(2,'Name',[tag,'_attention_transition'])
    dotproductLayer([tag,'_attention_dotproduct'])
    ];
end