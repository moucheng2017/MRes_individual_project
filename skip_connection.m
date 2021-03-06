function layers = skip_connection(netWidth,stride,tag)
layers=[
    batchNormalizationLayer('Name',[tag,'_skip_BN'])  
    convolution2dLayer(3,netWidth,'Padding','same','Stride',stride,'Name',[tag,'_skip_conv']);
    ];
end