function [lgraph,networkname]=attention_Unet_5stages_v4(height,width)
networkname='attention_network_5stages_v4';
% U net with attention
lgraph = createUnet(5);
larray=imageInputLayer([height width 3],'Name','Input','Normalization','None');
lgraph=replaceLayer(lgraph,'ImageInputLayer',larray);
[lgraph]=add_attention_block_v4('Encoder-Stage-5-ReLU-2','Decoder-Stage-1-upBN-1','Decoder-Stage-1-DepthConcatenation','Decoder-Stage-1-Conv-1','bridge',lgraph);
[lgraph]=add_attention_block_v4('Encoder-Stage-4-ReLU-2','Decoder-Stage-2-upBN-1','Decoder-Stage-2-DepthConcatenation','Decoder-Stage-2-Conv-1','s4',lgraph);
[lgraph]=add_attention_block_v4('Encoder-Stage-3-ReLU-2','Decoder-Stage-3-upBN-1','Decoder-Stage-3-DepthConcatenation','Decoder-Stage-3-Conv-1','s3',lgraph);
[lgraph]=add_attention_block_v4('Encoder-Stage-2-ReLU-2','Decoder-Stage-4-upBN-1','Decoder-Stage-4-DepthConcatenation','Decoder-Stage-4-Conv-1','s2',lgraph);
[lgraph]=add_attention_block_v4('Encoder-Stage-1-ReLU-2','Decoder-Stage-5-upBN-1','Decoder-Stage-5-DepthConcatenation','Decoder-Stage-5-Conv-1','s1',lgraph);
%analyzeNetwork(lgraph);
end