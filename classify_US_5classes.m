function data = classify_US_5classes(block,net)
data = block.data;
[a,b,c] = size(data);
temp = ones(a,b,c);
new_data = imresize(data,[224 224]);
[pred,score] = classify(net,new_data);%(:,1) background,(:,2)healthy tissues,(:,3) sulcus (:,4) TBC1 (:,5)tumours
%{
temp(1:a,1:b,1)= score(1);
temp(1:a,1:b,2)= score(2);
temp(1:a,1:b,3)= score(3);
%}
%{
temp(1:a,1:b,1)= score(3);
temp(1:a,1:b,2)= score(1);
temp(1:a,1:b,3)= score(2);
data= temp;
%}

        if pred == 'Tumour'  
           temp(1:a,1:b,1)= 1;
           temp(1:a,1:b,2)= 0;
           temp(1:a,1:b,3)= 0;
           data= temp;
        
        elseif pred == 'Grey matter'
           temp(1:a,1:b,1)= 0;
           temp(1:a,1:b,2)= 1;
           temp(1:a,1:b,3)= 0;
           data= temp;
        elseif pred == 'White matter'
           temp(1:a,1:b,1)= 1;
           temp(1:a,1:b,2)= 1;
           temp(1:a,1:b,3)= 1;
           data= temp;
           
        elseif pred == 'Sulcus'
           temp(1:a,1:b,1)= 1;
           temp(1:a,1:b,2)= 1;
           temp(1:a,1:b,3)= 0;
           data= temp;
        elseif pred == "Others"
           temp(1:a,1:b,1)= 0;
           temp(1:a,1:b,2)= 0;
           temp(1:a,1:b,3)= 1;
           data= temp;    
        else
            % pass
        end


end