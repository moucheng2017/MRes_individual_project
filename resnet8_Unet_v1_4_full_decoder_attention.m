function [lgraph,networkname]=resnet8_Unet_v1_4_full_decoder_attention(classes,netWidth,height,width,beta)
% skip connnections in both encoder and decoder
% attention in decoder
% compatability score used
lgraph=resnet8_Unet(classes,netWidth,height,width,beta);
networkname='resnet8_Unet_v1_4_full_decoder_attention';
[lgraph]=add_attention_block_new_3('s4u1_add','bridge_upconv','concat_bridge','bridge',lgraph,netWidth*8);
[lgraph]=add_attention_block_new_3('s3u1_add','d4_upconv','d4_contac','d4',lgraph,netWidth*4);
[lgraph]=add_attention_block_new_3('s2u1_add','d3_upconv','d3_contac','d3',lgraph,netWidth*2);
[lgraph]=add_attention_block_new_3('s1u1_add','d2_upconv','d2_contac','d2',lgraph,netWidth*1);
%% decoder attention
lgraph = disconnectLayers(lgraph,'bridge_upconv','concat_bridge/in1');
layers=decoder_attention('bridge');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'bridge_attention_dotproduct','bridge_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'bridge_upconv','bridge_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'bridge_decoder_attention_dotproduct','concat_bridge/in1');
%
lgraph = disconnectLayers(lgraph,'d4_upconv','d4_contac/in1');
layers=decoder_attention('d4');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'d4_attention_dotproduct','d4_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'d4_upconv','d4_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'d4_decoder_attention_dotproduct','d4_contac/in1');
%
lgraph = disconnectLayers(lgraph,'d3_upconv','d3_contac/in1');
layers=decoder_attention('d3');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'d3_attention_dotproduct','d3_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'d3_upconv','d3_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'d3_decoder_attention_dotproduct','d3_contac/in1');
%
lgraph = disconnectLayers(lgraph,'d2_upconv','d2_contac/in1');
layers=decoder_attention('d2');
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'d2_attention_dotproduct','d2_decoder_attention_transition/in1');
lgraph = connectLayers(lgraph,'d2_upconv','d2_decoder_attention_transition/in2');
lgraph = connectLayers(lgraph,'d2_decoder_attention_dotproduct','d2_contac/in1');
%% connect layers

%analyzeNetwork(lgraph);
end