function data = classify_US(block,net)
data = block.data;
[a,b,c] = size(data);
temp = ones(a,b,c);
new_data = imresize(data,[224 224]);
e = entropy(new_data);
if (e<=4.2975)%for case1video1 others
%if (e<=3.3179)%for case1video4    
%if (e<=5)%for case1video4
    temp(1:a,1:b,1)= 0;
    temp(1:a,1:b,2)= 0;
    temp(1:a,1:b,3)= 0;
    data= temp; 
%}
%{    
elseif (e>4.2975 && e<4.8445)
    temp(1:a,1:b,1)= 0;
    temp(1:a,1:b,2)= 0;
    temp(1:a,1:b,3)= 0;
    data= temp;
    %}
else
    [pred,score] = classify(net,new_data);
    temp(1:a,1:b,1)= score(3);
    temp(1:a,1:b,2)= score(1);
    temp(1:a,1:b,3)= score(2);
    data= temp;
    %{
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
%}
end

%{
temp(1:a,1:b,1)= score(3);
temp(1:a,1:b,2)= score(1);
temp(1:a,1:b,3)= score(2);
data= temp;
%}
      
end