function [CH gg image2] = colorhistogram(bimage,containersize,image)

gg=double(bimage);
gg(find(gg==0))=NaN;

colorchannel=size(image,3);
for i=1:colorchannel
    image2(:,:,i)=im2double(image(:,:,i)).*gg;
end
siz=size(image2);

image3=reshape(image2,siz(1)*siz(2),siz(3));
image3=double(image3);
[N,X]=hist(image3, [0:containersize:1]);

for i=1:colorchannel
    CH(:,i,1)=N(:,i,1)/sum(N(:,i,1));
end



