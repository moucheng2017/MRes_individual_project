function [lgraph,networkname]=resnet12_Unet_attention_v4(classes,netWidth,height,width,beta)
lgraph=resnet12_Unet(classes,netWidth,height,width,beta);
networkname='resnet12_Unet_attention_v4';
[lgraph]=add_attention_block_v4('s4u2_add','bridge_upconv','concat_bridge','d4_BN1','bridge',lgraph);
[lgraph]=add_attention_block_v4('s3u2_add','d4_upconv','d4_contac','d3_BN1','d4',lgraph);
[lgraph]=add_attention_block_v4('s2u2_add','d3_upconv','d3_contac','d2_BN1','d3',lgraph);
[lgraph]=add_attention_block_v4('s1u2_add','d2_upconv','d2_contac','d1_BN1','d2',lgraph);
[lgraph]=add_attention_block_v4('convInp','d1_upconv','d1_contac','d0_BN1','d1',lgraph);
analyzeNetwork(lgraph);
end
