function [lgraph,networkname]=resnet12_Unet_attention_v1_3_new(classes,netWidth,height,width,beta)
lgraph=resnet12_Unet(classes,netWidth,height,width,beta);
networkname='resnet12_Unet_attention_v1_3_new';
[lgraph]=add_attention_block_new('s4u2_add','bridge_upconv','concat_bridge','bridge',lgraph,netWidth*8);
[lgraph]=add_attention_block_new_2('s3u2_add','bridge_upconv','d4_contac','d4',lgraph,netWidth*4,2);
[lgraph]=add_attention_block_new_2('s2u2_add','bridge_upconv','d3_contac','d3',lgraph,netWidth*2,4);
%[lgraph]=add_attention_block_new_2('s1u2_add','d4_upconv','d2_contac','d2',lgraph,netWidth*1,4);
%[lgraph]=add_attention_block('convInp','d1_upconv','d1_contac','d1',lgraph);
analyzeNetwork(lgraph);
end