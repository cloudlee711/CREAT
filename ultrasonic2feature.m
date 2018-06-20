function [ultrasonicyinjie ultrasonicmfccfeature]=ultrasonic2feature(x)
yizhen=256;
zhenyi=128;
yy=enframe(x,yizhen,zhenyi);
for i=1:size(yy,1)
    energy(i)=sum(yy(i,:).^2);
end

for i=1:size(yy,1)
    y1=yy(i,:);
    y1(1)=[];
    y1(size(yy,2))=yy(1,size(yy,2));
    zero_crossing(i)=0.5*sum(abs(sign(y1)-sign(yy(i,:))));
end

index=find(energy>=0.001);
index0=find(zero_crossing<100);
index=unique([index,index0]);

kk=1;
position=[];
for i=1:size(index,2)-1
    if index(i)~=index(i+1)-1
        position(kk)=i;
        kk=kk+1;
        position(kk)=i+1;
        kk=kk+1;
    end
end


position1=index(position);
point=[index(1),position1,index(size(index,2))];

point
for i=1:size(point,2)/2
    if (point(2*i)*zhenyi+yizhen)>size(x,2)
        ultrasonicyinjie(i).data=x(point(2*i-1)*zhenyi+1:size(x,2));
    else
        ultrasonicyinjie(i).data=x(point(2*i-1)*zhenyi+1:point(2*i)*zhenyi+yizhen);
    end
end


for i=1:size(ultrasonicyinjie,2)
    fram=enframe(ultrasonicyinjie(i).data,yizhen,zhenyi);
    for j=1:size(fram,1)
        zz(j,:)=rceps(fram(j,:));
    end
    ultrasonicmfccfeature(i).data=zz;
    
end
