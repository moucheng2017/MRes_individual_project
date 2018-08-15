function [lgraph,networkname]=resnet12_Unet_attention_v3(classes,netWidth,height,width,beta)
lgraph=resnet12_Unet(classes,netWidth,height,width,beta);
networkname='resnet12_Unet_attention_v3';
[lgraph]=add_attention_block_v3('s4u2_add','bridge_upconv','concat_bridge','bridge',lgraph);
[lgraph]=add_attention_block_v3('s3u2_add','d4_upconv','d4_contac','d4',lgraph);
[lgraph]=add_attention_block_v3('s2u2_add','d3_upconv','d3_contac','d3',lgraph);
[lgraph]=add_attention_block_v3('s1u2_add','d2_upconv','d2_contac','d2',lgraph);
[lgraph]=add_attention_block_v3('convInp','d1_upconv','d1_contac','d1',lgraph);
analyzeNetwork(lgraph);
end