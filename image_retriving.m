% images retriving
folder='C:\Users\NeuroBeast\Desktop\train - Copy';
all_imgs = dir(fullfile(folder,'\*.tif'));
all_imgs = {all_imgs.name}';

for i = 1:length(all_imgs)
    img_name=all_imgs{i};img_full_name=fullfile(folder,img_name);
    %img=imread(img_full_name);
    if (contains(img_name,'mask')==1)
        movefile (img_full_name,'C:\Users\NeuroBeast\Desktop\nerves train\labels')
    else
        movefile (img_full_name,'C:\Users\NeuroBeast\Desktop\nerves train\patches')
    end
    %{
    if (mean2(img)==0)
        delete(img_full_name);
        maskindex=img_name(1:end-9);
        mask_img_name=strcat(maskindex,'.tif');
        img_full_name_mask=fullfile(folder,mask_img_name);
        delete(img_full_name_mask);
    else
    end
    %}
end

