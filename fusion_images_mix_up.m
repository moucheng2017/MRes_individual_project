%fusion
folder='C:\Users\NeuroBeast\Desktop\new results';
f1='fcn8s_v2_train_c2_validate_c3_norm_binary_case3video2000000000000021.png';
f2='fcn8s_train_case2 new_validate_case3 new_fb loss fb=2.5_case3video2000000000000021.png';
img1=imread(fullfile(folder,f1));
img2=imread(fullfile(folder,f2));
f=0.5*img2+0.5*img1;

%{
%median_value=median(median(f1,2),1);
[height,width,dims]=size(f);
for i=1:height
    for j=1:width
        if (f(i,j,1)>100)
            f(i,j,1)=1;
            f(i,j,2)=1;
            f(i,j,3)=1;
        else
            f(i,j,1)=0;
            f(i,j,2)=0;
            f(i,j,3)=0;
        end
    end
end
%}
figure
imshow(f)