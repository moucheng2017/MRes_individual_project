function [lgraph,networkname]=resnet10_Unet_attention_v1_2_new(classes,netwidth,height,width,beta)
lgraph=resnet10_Unet(classes,netwidth,height,width,beta);
networkname='resnet10_Unet_attention_v1_2_new';
[lgraph]=add_attention_block('s3u2_add','bridge_upconv','concat_bridge','bridge',lgraph);
[lgraph]=add_attention_block_new_2('s2u2_add','d3_upconv','d3_contac','d3',lgraph,netwidth*2,2);
%[lgraph]=add_attention_block('s1u2_add','d2_upconv','d2_contac','d2',lgraph);
%[lgraph]=add_attention_block('convInp','d1_upconv','d1_contac','d1',lgraph);
analyzeNetwork(lgraph);
end