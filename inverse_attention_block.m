function layers = inverse_attention_block(tag)
layers = [
    additionLayer(2,'Name',[tag,'_attention_addition']);
    batchNormalizationLayer('Name',[tag,'_attention_BN'])
    reluLayer('Name',[tag,'_attention_relu'])
    softmaxLayer('Name',[tag,'_attention_softmax'])
    depthConcatenationLayer(2,'Name',[tag,'_attention_transition'])
    dotproductLayer_inverse([tag,'_attention_dotproduct_inverse'])
    ];

end
