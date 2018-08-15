function [lgraph]=add_inverse_attention_block(coarsefeatures,finefeatures,destination,attention_tag,lgraph)
attentionlayers = inverse_attention_block(attention_tag);
lgraph=addLayers(lgraph,attentionlayers);
lgraph=disconnectLayers(lgraph,coarsefeatures,[destination,'/in2']);
lgraph=connectLayers(lgraph,finefeatures,[attention_tag,'_attention_addition/in1']);
lgraph=connectLayers(lgraph,coarsefeatures,[attention_tag,'_attention_addition/in2']);
lgraph=connectLayers(lgraph,coarsefeatures,[attention_tag,'_attention_transition/in2']);
lgraph=connectLayers(lgraph,[attention_tag,'_attention_dotproduct_inverse'],[destination,'/in2']);

end