%U net first implementation
inputTileSize = [224,224,3];
lgraph = createUnet;
%stage2 down
lgraph = disconnectLayers(lgraph,'Encoder-Stage-2-ReLU-1','Encoder-Stage-2-Conv-2');
drop2=dropoutLayer(0.2,'Name','dropout-stage2');
lgraph = addLayers(lgraph,drop2);
lgraph = connectLayers(lgraph,'Encoder-Stage-2-ReLU-1','dropout-stage2');
lgraph = connectLayers(lgraph,'dropout-stage2','Encoder-Stage-2-Conv-2');
%stage3 down
lgraph = disconnectLayers(lgraph,'Encoder-Stage-3-ReLU-1','Encoder-Stage-3-Conv-2');
drop3=dropoutLayer(0.3,'Name','dropout-stage3');
lgraph = addLayers(lgraph,drop3);
lgraph = connectLayers(lgraph,'Encoder-Stage-3-ReLU-1','dropout-stage3');
lgraph = connectLayers(lgraph,'dropout-stage3','Encoder-Stage-3-Conv-2');
%stage4 down
lgraph = disconnectLayers(lgraph,'Encoder-Stage-4-ReLU-1','Encoder-Stage-4-Conv-2');
drop4=dropoutLayer(0.3,'Name','dropout-stage4');
lgraph = addLayers(lgraph,drop4);
lgraph = connectLayers(lgraph,'Encoder-Stage-4-ReLU-1','dropout-stage4');
lgraph = connectLayers(lgraph,'dropout-stage4','Encoder-Stage-4-Conv-2');
%stage1 up
lgraph = disconnectLayers(lgraph,'Decoder-Stage-1-ReLU-1','Decoder-Stage-1-Conv-2');
drop5=dropoutLayer(0.4,'Name','dropout-de-stage1');
lgraph = addLayers(lgraph,drop5);
lgraph = connectLayers(lgraph,'Decoder-Stage-1-ReLU-1','dropout-de-stage1');
lgraph = connectLayers(lgraph,'dropout-de-stage1','Decoder-Stage-1-Conv-2');
%stage2 up
lgraph = disconnectLayers(lgraph,'Decoder-Stage-2-ReLU-1','Decoder-Stage-2-Conv-2');
drop6=dropoutLayer(0.4,'Name','dropout-de-stage2');
lgraph = addLayers(lgraph,drop6);
lgraph = connectLayers(lgraph,'Decoder-Stage-2-ReLU-1','dropout-de-stage2');
lgraph = connectLayers(lgraph,'dropout-de-stage2','Decoder-Stage-2-Conv-2');
%stage3 up
lgraph = disconnectLayers(lgraph,'Decoder-Stage-3-ReLU-1','Decoder-Stage-3-Conv-2');
drop7=dropoutLayer(0.4,'Name','dropout-de-stage3');
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
analyzeNetwork(lgraph)
