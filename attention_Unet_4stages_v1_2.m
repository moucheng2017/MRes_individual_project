function [lgraph,networkname]=attention_Unet_4stages_v1_2(height,width)
networkname='attention_network_4stages_v1_2';
% U net with attention
lgraph = createUnet(4);
larray=imageInputLayer([height width 3],'Name','Input','Normalization','None');
lgraph=replaceLayer(lgraph,'ImageInputLayer',larray);
[lgraph]=add_attention_block('Encoder-Stage-4-ReLU-2','Decoder-Stage-1-upBN-1','Decoder-Stage-1-DepthConcatenation','bridge',lgraph);

analyzeNetwork(lgraph);
end
