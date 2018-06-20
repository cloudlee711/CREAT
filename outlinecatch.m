function [NFD FD bimage]=outlinecatch(image)

f=im2double(image); 
T=graythresh(f);
f=im2bw(f,T);
f=im2double(f);
h=fspecial('gaussian',15,9);
bimage=imfilter(f,h,'replicate');

bimage=im2bw(bimage,0.7);
bimage=double(bimage);
%contr=contour(bimage,1);
contr=contourc(bimage,1);
contrim=bound2im(contr);

boundary=boundaries(contrim);
boundary=boundary{1};
bim=bound2im(boundary);

i=sqrt(-1);
for j=1:size(boundary,1)
    s(j)=boundary(j,1)+i*boundary(j,2);
end
FD=fft(s);
for i=2:size(FD,2)
    NFD(i)=norm(FD(i))/norm(FD(2));
end

bimage=zeros(size(image,1),size(image,2));
contr(:,1)=[];
contr=ceil(contr);
for i=1:size(contr,2)
    bimage(contr(2,i),contr(1,i))=1;
end
bimage=imclose(bimage,strel('rectangle',[1 4]));
bimage=imfill(bimage,'holes');
