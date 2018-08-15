function [lgraph]=add_attention_block_v2(coarsefeatures,finefeatures,destination,attention_tag,lgraph)
attentionlayers = attention_block_v2(attention_tag);
lgraph=addLayers(lgraph,attentionlayers);
lgraph=disconnectLayers(lgraph,coarsefeatures,[destination,'/in2']);
lgraph=connectLayers(lgraph,finefeatures,[attention_tag,'_attention_BN']);
lgraph=connectLayers(lgraph,coarsefeatures,[attention_tag,'_attention_transition/in2']);
lgraph=connectLayers(lgraph,[attention_tag,'_attention_dotproduct'],[destination,'/in2']);

end