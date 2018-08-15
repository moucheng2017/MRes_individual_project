function [lgraph,networkname]=attention_Unet_3stages_v3(height,width)
networkname='attention_network_3stages_v3';
% U net with attention
lgraph = createUnet(3);
larray=imageInputLayer([height width 3],'Name','Input','Normalization','None');
lgraph=replaceLayer(lgraph,'ImageInputLayer',larray);
[lgraph]=add_attention_block_v3('Encoder-Stage-3-ReLU-2','Decoder-Stage-1-upBN-1','Decoder-Stage-1-DepthConcatenation','bridge',lgraph);
[lgraph]=add_attention_block_v3('Encoder-Stage-2-ReLU-2','Decoder-Stage-2-upBN-1','Decoder-Stage-2-DepthConcatenation','s2',lgraph);
[lgraph]=add_attention_block_v3('Encoder-Stage-1-ReLU-2','Decoder-Stage-3-upBN-1','Decoder-Stage-3-DepthConcatenation','s1',lgraph);
analyzeNetwork(lgraph);
end