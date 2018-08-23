function [lgraph,networkname]=attention_Unet_3stages(height,width,netwidth)
networkname='attention_network_3stages';
% U net with attention
lgraph = createUnet(3,height,width,netwidth);
larray=imageInputLayer([height width 3],'Name','Input','Normalization','None');
lgraph=replaceLayer(lgraph,'ImageInputLayer',larray);
%[lgraph]=add_attention_block_new('Encoder-Stage-3-ReLU-2','Decoder-Stage-1-upBN-1','Decoder-Stage-1-DepthConcatenation','bridge',lgraph,netwidth*4);
[lgraph]=add_attention_block_new('Encoder-Stage-2-ReLU-2','Decoder-Stage-2-upBN-1','Decoder-Stage-2-DepthConcatenation','s2',lgraph,netwidth*2);
%[lgraph]=add_attention_block_new('Encoder-Stage-1-ReLU-2','Decoder-Stage-3-upBN-1','Decoder-Stage-3-DepthConcatenation','s1',lgraph,netwidth*1);
%analyzeNetwork(lgraph);
end