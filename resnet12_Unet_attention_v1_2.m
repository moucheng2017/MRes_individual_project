function [lgraph,networkname]=resnet12_Unet_attention_v1_2(classes,netWidth,height,width,beta)
lgraph=resnet12_Unet(classes,netWidth,height,width,beta);
networkname='resnet12_Unet_attention_v1_2';
[lgraph]=add_attention_block_new('s4u2_add','bridge_upconv','concat_bridge','bridge',lgraph,netWidth*8);
[lgraph]=add_attention_block_new('s3u2_add','d4_upconv','d4_contac','d4',lgraph,netWidth*4);
%analyzeNetwork(lgraph);
end