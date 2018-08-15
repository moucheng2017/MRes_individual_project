function layers = attention_block_new(tag,channels)
% compatability score version
layers = [
    convolution2dLayer(2,channels,'Stride',1,'Padding','same','Name',[tag,'_compatability_mapping'])
    additionLayer(2,'Name',[tag,'_attention_addition']);
    batchNormalizationLayer('Name',[tag,'_attention_BN'])
    reluLayer('Name',[tag,'_attention_relu'])
    softmaxLayer('Name',[tag,'_attention_softmax'])
    depthConcatenationLayer(2,'Name',[tag,'_attention_transition'])
    dotproductLayer([tag,'_attention_dotproduct'])
    ];

end
