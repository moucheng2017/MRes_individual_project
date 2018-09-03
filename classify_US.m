function data = classify_US(block,net)
data = block.data;
data = imresize(data,[224 224]);
[a,b,c] = size(data);
pred= classify(net,data);
temp = ones(a,b,c);
if (pred == 'Tumour')   % malignant
   temp(1:a,1:b,1)= 1;
   temp(1:a,1:b,2)= 0;
   temp(1:a,1:b,3)= 0;
   data= temp;        
elseif (pred == 'Healthy')
   temp(1:a,1:b,1)= 0;
   temp(1:a,1:b,2)= 0;
   temp(1:a,1:b,3)= 0;
   data= temp;  
end
end
