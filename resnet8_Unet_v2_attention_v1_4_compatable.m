function [lgraph,networkname]=resnet8_Unet_v2_attention_v1_4_compatable(classes,netWidth,height,width,beta)
% skip connnections in both encoder and decoder
% compatability score used
lgraph=resnet8_Unet_v2(classes,netWidth,height,width,beta);
networkname='resnet8_Unet_v2_attention_v1_4_compatable';
%[lgraph]=add_attention_block('s4u1_add','bridge_upconv','concat_bridge','bridge',lgraph);
[lgraph]=add_attention_block_new('s3u1_add','d4_add_decoder','d4_contac','d4',lgraph,netWidth*4);
[lgraph]=add_attention_block_new('s2u1_add','d3_add_decoder','d3_contac','d3',lgraph,netWidth*2);
%[lgraph]=add_attention_block('convInp','d1_upconv','d1_contac','d1',lgraph);
analyzeNetwork(lgraph);
end