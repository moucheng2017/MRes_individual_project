function [lgraph,networkname]=resnet8_Unet_v1_attention_v1_4_connections_literature(classes,netWidth,height,width,beta)
% use connections methods as in literature
% compatability score used
lgraph=resnet8_Unet(classes,netWidth,height,width,beta);
networkname='resnet8_Unet_v1_attention_v1_4_connections_literature';
[lgraph]=add_attention_block_new_3('s4u1_add','bridge_upconv','concat_bridge','bridge',lgraph,netWidth*8);
[lgraph]=add_attention_block_new_3('s3u1_add','d4_upconv','d4_contac','d4',lgraph,netWidth*4);
[lgraph]=add_attention_block_new_3('s2u1_add','d3_upconv','d3_contac','d3',lgraph,netWidth*2);
[lgraph]=add_attention_block_new_3('s1u1_add','d2_upconv','d2_contac','d2',lgraph,netWidth*1);
%analyzeNetwork(lgraph);
end