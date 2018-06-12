function data = classify_US(block,net)
data = block.data;
[a,b,c] = size(data);
temp = ones(a,b,c);
new_data = imresize(data,[224 224]);

mean_intensity = mean(new_data(:));
%e = entropy(new_data);
if (mean_intensity<25)
    temp(1:a,1:b,1)= 0;
    temp(1:a,1:b,2)= 0;
    temp(1:a,1:b,3)= 0;
    data= temp; 
else

    [pred] = classify(net,new_data);
    if pred == 'Tumour'   % malignant
           temp(1:a,1:b,1)= 1;
           temp(1:a,1:b,2)= 0;
           temp(1:a,1:b,3)= 0;
           data= temp;        
        elseif pred == 'Healthy'
           temp(1:a,1:b,1)= 0;
           temp(1:a,1:b,2)= 1;
           temp(1:a,1:b,3)= 0;
           data= temp;
        elseif pred == 'Others'
           temp(1:a,1:b,1)= 0;
           temp(1:a,1:b,2)= 0;
           temp(1:a,1:b,3)= 1;
           data= temp;            
     end

end

%{
temp(1:a,1:b,1)= score(3);
temp(1:a,1:b,2)= score(1);
temp(1:a,1:b,3)= score(2);
data= temp;
%}

        
end