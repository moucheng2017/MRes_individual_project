function [lgraph]=add_attention_block_new(coarsefeatures,finefeatures,destination,attention_tag,lgraph,channels)
% compatability score version
attentionlayers = attention_block_new(attention_tag,channels);
lgraph=addLayers(lgraph,attentionlayers);
lgraph=disconnectLayers(lgraph,coarsefeatures,[destination,'/in2']);
lgraph=connectLayers(lgraph,finefeatures,[attention_tag,'_compatability_mapping']);
lgraph=connectLayers(lgraph,coarsefeatures,[attention_tag,'_attention_addition/in2']);
lgraph=connectLayers(lgraph,coarsefeatures,[attention_tag,'_attention_transition/in2']);
lgraph=connectLayers(lgraph,[attention_tag,'_attention_dotproduct'],[destination,'/in2']);
end