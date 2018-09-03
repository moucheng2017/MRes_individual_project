function [lgraph,networkname]=attention_Unet_5stages_new_new_decoder(height,width,netwidth)
% added compatibility mapping of local features
networkname='attention_network_5stages_new_new_decoder';
% U net with attention
lgraph = createUnet(5,height,width,netwidth);
larray=imageInputLayer([height width 3],'Name','Input','Normalization','None');
lgraph=replaceLayer(lgraph,'ImageInputLayer',larray);
[lgraph]=add_attention_block_new_3('Encoder-Stage-5-ReLU-2','Decoder-Stage-1-upBN-1','Decoder-Stage-1-DepthConcatenation','bridge',lgraph,netwidth*16);
[lgraph]=add_attention_block_new_3('Encoder-Stage-4-ReLU-2','Decoder-Stage-2-upBN-1','Decoder-Stage-2-DepthConcatenation','s4',lgraph,netwidth*8);
[lgraph]=add_attention_block_new_3('Encoder-Stage-3-ReLU-2','Decoder-Stage-3-upBN-1','Decoder-Stage-3-DepthConcatenation','s3',lgraph,netwidth*4);
[lgraph]=add_attention_block_new_3('Encoder-Stage-2-ReLU-2','Decoder-Stage-4-upBN-1','Decoder-Stage-4-DepthConcatenation','s2',lgraph,netwidth*2);
[lgraph]=add_attention_block_new_3('Encoder-Stage-1-ReLU-2','Decoder-Stage-5-upBN-1','Decoder-Stage-5-DepthConcatenation','s1',lgraph,netwidth);
%%
lgraph = disconnectLayers(lgraph,'Decoder-Stage-1-upBN-1','Decoder-Stage-1-DepthConcatenation/in1');
layers=decoder_attention('decoder1');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'bridge_attention_dotproduct','decoder1_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'Decoder-Stage-1-upBN-1','decoder1_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'decoder1_decoder_attention_dotproduct','Decoder-Stage-1-DepthConcatenation/in1');
%
lgraph = disconnectLayers(lgraph,'Decoder-Stage-2-upBN-1','Decoder-Stage-2-DepthConcatenation/in1');
layers=decoder_attention('decoder2');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'s4_attention_dotproduct','decoder2_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'Decoder-Stage-2-upBN-1','decoder2_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'decoder2_decoder_attention_dotproduct','Decoder-Stage-2-DepthConcatenation/in1');
%
lgraph = disconnectLayers(lgraph,'Decoder-Stage-3-upBN-1','Decoder-Stage-3-DepthConcatenation/in1');
layers=decoder_attention('decoder3');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'s3_attention_dotproduct','decoder3_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'Decoder-Stage-3-upBN-1','decoder3_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'decoder3_decoder_attention_dotproduct','Decoder-Stage-3-DepthConcatenation/in1');
%
lgraph = disconnectLayers(lgraph,'Decoder-Stage-4-upBN-1','Decoder-Stage-4-DepthConcatenation/in1');
layers=decoder_attention('decoder4');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'s2_attention_dotproduct','decoder4_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'Decoder-Stage-4-upBN-1','decoder4_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'decoder4_decoder_attention_dotproduct','Decoder-Stage-4-DepthConcatenation/in1');
%
lgraph = disconnectLayers(lgraph,'Decoder-Stage-5-upBN-1','Decoder-Stage-5-DepthConcatenation/in1');
layers=decoder_attention('decoder5');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'s1_attention_dotproduct','decoder5_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'Decoder-Stage-5-upBN-1','decoder5_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'decoder5_decoder_attention_dotproduct','Decoder-Stage-5-DepthConcatenation/in1');
%analyzeNetwork(lgraph);
end


