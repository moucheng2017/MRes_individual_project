function layers = skip_connection_decoder(netWidth,stride,tag)
layers=[
    batchNormalizationLayer('Name',[tag,'_skip_BN_decoder'])  
    transposedConv2dLayer(2,netWidth,'Stride',stride,'Name',[tag,'_upconv_decoder'])
    ];
end
