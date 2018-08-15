function [lgraph,networkname]=attention_Unet_5stages_new(height,width)
% added compatibility mapping of local features
networkname='attention_network_5stages_new';
% U net with attention
lgraph = createUnet(5,height,width);
larray=imageInputLayer([height width 3],'Name','Input','Normalization','None');
lgraph=replaceLayer(lgraph,'ImageInputLayer',larray);
[lgraph]=add_attention_block_new('Encoder-Stage-5-ReLU-2','Decoder-Stage-1-upBN-1','Decoder-Stage-1-DepthConcatenation','bridge',lgraph,1024);
[lgraph]=add_attention_block_new('Encoder-Stage-4-ReLU-2','Decoder-Stage-2-upBN-1','Decoder-Stage-2-DepthConcatenation','s4',lgraph,512);
[lgraph]=add_attention_block_new('Encoder-Stage-3-ReLU-2','Decoder-Stage-3-upBN-1','Decoder-Stage-3-DepthConcatenation','s3',lgraph,256);
[lgraph]=add_attention_block_new('Encoder-Stage-2-ReLU-2','Decoder-Stage-4-upBN-1','Decoder-Stage-4-DepthConcatenation','s2',lgraph,128);
[lgraph]=add_attention_block_new('Encoder-Stage-1-ReLU-2','Decoder-Stage-5-upBN-1','Decoder-Stage-5-DepthConcatenation','s1',lgraph,64);
analyzeNetwork(lgraph);
end