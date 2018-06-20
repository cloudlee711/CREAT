function [syllabel mfcc] = voice2syllable (x,label,fs)
%first order high pass filter
x1 = filter([1-0.9375],1,x);
%amplitude normalization
x1=x1/max(abs(x1));
%framing
framelength=256;
frameshift=128;
frame=enframe(x1,framelength,frameshift);
%short-time energy of each frame
for i=1:size(frame,1)
    energy(i)=sum(frame(i,:).^2);
end
%short-time zero crossing rate of each frame
for i=1:size(frame,1)
    y1=frame(i,:);
    y1(1)=[];
    y1(size(frame,2))=frame(1,size(frame,2));
    zero_crossing(i)=0.5*sum(abs(sign(y1)-sign(frame(i,:))));
end
%find candidate frame
index1=find(energy>=0.5);
index0=find(zero_crossing>100);
index1=unique([index1,index0]);
%merge frame
k=1;
position=[];
for i=1:size(index1,2)-1
    if index1(i)~=index1(i+1)-1
        position(k)=i;
        k=k+1;
        position(k)=i+1;
        k=k+1;
    end
end
position1=index1(position);
point=[index1(1),position1,index1(size(index1,2))];
point1=point;
merge=[];
if (size(point,2)-2)/2~=0
    merge((size(point,2)-2)/2)=0;
end
for i=2:2:size(point,2)-2
    if point(i+1)-point(i)<=2
        merge(i/2)=1;
    end
end
for i=1:size(merge,2)
    if merge(i)==1
        point(i*2)=0;
        point(i*2+1)=0;
    end
end
point(find(point==0))=[];

for i=1:size(point,2)/2
    if (point(2*i)*frameshift+framelength)>size(x,1)
        syllabel(i).data=x(point(2*i-1)*frameshift+1:size(x,2));
    else
        syllabel(i).data=x(point(2*i-1)*frameshift+1:point(2*i)*frameshift+framelength);
    end
end
%remove short frame
k=1;
recordremove=[];
for i=1:size(syllabel,2)
    if size(syllabel(i).data,1)<=512
        recordremove(k)=i;
        k=k+1;
    end
end
if size(recordremove,1)~=0
    syllabel(recordremove)=[];
end
%get MFCC for each syllabel
for i=1:size(syllabel,2)
    mfcc(i).data=mfccfunction(syllabel(i).data,fs);
    mfcc(i).label=label(i);
end
for i=1:size(mfcc,2)
    if size(mfcc(i).data)==0
        mfcc(i).data=[];
    end
end


