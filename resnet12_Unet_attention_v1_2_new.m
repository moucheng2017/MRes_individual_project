function [lgraph,networkname]=resnet12_Unet_attention_v1_2_new(classes,netWidth,height,width,beta)
lgraph=resnet12_Unet(classes,netWidth,height,width,beta);
networkname='resnet12_Unet_attention_v1_2_new';
[lgraph]=add_attention_block_new('s4u2_add','bridge_upconv','concat_bridge','bridge',lgraph,netWidth*8);
[lgraph]=add_attention_block_new_2('s3u2_add','bridge_upconv','d4_contac','d4',lgraph,netWidth*4,2);
%analyzeNetwork(lgraph);
end