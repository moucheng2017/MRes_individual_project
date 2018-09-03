function layers=decoder_attention(tag)
layers=[
    depthConcatenationLayer(2,'Name',[tag,'_decoder_attention_transition'])
    dotproductLayer([tag,'_decoder_attention_dotproduct'])];
end