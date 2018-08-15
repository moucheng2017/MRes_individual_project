function data = classify_US(block,net)
%threshold=10;
data = block.data;
data = imresize(data,[224 224]);
segmented_image = semanticseg(data,net); 
data = labeloverlay(data, segmented_image);
%{
[a,b] = size(data);
temp = ones(a,b,3);
for i=1:a
    for j=1:b
        pred=data(i,j);
        if (pred == 'tumour')   % malignant
           temp(1:a,1:b,1)= 1;
           temp(1:a,1:b,2)= 0;
           temp(1:a,1:b,3)= 0;
           data= temp;        
        elseif (pred == 'healthy')
           temp(1:a,1:b,1)= 0;
           temp(1:a,1:b,2)= 1;
           temp(1:a,1:b,3)= 0;
           data= temp;
        elseif (pred == 'others')
           temp(1:a,1:b,1)= 0;
           temp(1:a,1:b,2)= 0;
           temp(1:a,1:b,3)= 1;
           data= temp;    
        elseif (pred == 'background')
           temp(1:a,1:b,1)= 0;
           temp(1:a,1:b,2)= 0;
           temp(1:a,1:b,3)= 1;
           data= temp;
        end
    end
end
%}
%data= labeloverlay(data, segmentedI);
%{
[a,b,c] = size(data);
temp = ones(a,b,c);
%new_data = imresize(data,[32 32]);
%mean_data = mean(new_data(:));
%mean_data = mean(data(:));
%{
%e = entropy(new_data);
%if (e<=4.2975)%for case1video1 others
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
%else
if (mean_data<=threshold)
    temp(1:a,1:b,1)= 0;
    temp(1:a,1:b,2)= 0;
    temp(1:a,1:b,3)= 0;
    data= temp;
else
    [pred,score] = classify(net,new_data);
    %{
    temp(1:a,1:b,1)= 1*score(3);
    temp(1:a,1:b,2)= 2*score(1);
    temp(1:a,1:b,3)= 3*score(2);
    data= temp;
end
    %}
    
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
      
%end