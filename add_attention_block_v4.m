function [lgraph]=add_attention_block_v4(coarsefeatures,finefeatures,destination,nextdestination,attention_tag,lgraph)
attentionlayers = attention_block_v4(attention_tag);
lgraph=addLayers(lgraph,attentionlayers);
lgraph=disconnectLayers(lgraph,coarsefeatures,[destination,'/in2']);
lgraph = removeLayers(lgraph,destination);
%
lgraph=connectLayers(lgraph,finefeatures,[attention_tag,'_attention_softmax']);
lgraph=connectLayers(lgraph,coarsefeatures,[attention_tag,'_attention_transition/in2']);
%lgraph=connectLayers(lgraph,coarsefeatures,[attention_tag,'_attention_addition/in2']);
lgraph=connectLayers(lgraph,[attention_tag,'_attention_dotproduct'],nextdestination);

end