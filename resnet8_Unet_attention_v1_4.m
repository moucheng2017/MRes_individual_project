function [lgraph,networkname]=resnet8_Unet_attention_v1_4(classes,netWidth,height,width,beta)
lgraph=resnet8_Unet(classes,netWidth,height,width,beta);
networkname='resnet8_Unet_attention_v1_4';
%[lgraph]=add_attention_block('s4u1_add','bridge_upconv','concat_bridge','bridge',lgraph);
[lgraph]=add_attention_block('s3u1_add','d4_upconv','d4_contac','d4',lgraph);
[lgraph]=add_attention_block('s2u1_add','d3_upconv','d3_contac','d3',lgraph);
%[lgraph]=add_attention_block('convInp','d1_upconv','d1_contac','d1',lgraph);
analyzeNetwork(lgraph);
end