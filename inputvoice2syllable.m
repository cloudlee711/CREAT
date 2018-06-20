function syllable = inputvoice2syllable (inputvoice,voicetype)
framelength=256;
frameshift=128;
if strcmp(voicetype,'Audible')
    energythreshold=0.5;
    zero_crossingthreshold=100;
    fs=8000;
    %first order high pass filter
    x1 = filter([1-0.9375],1,inputvoice.data);
    %amplitude normalization
    x1=x1/max(abs(x1));
    %framing
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
    index1=find(energy>=energythreshold);
    index0=find(zero_crossing>zero_crossingthreshold);
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
        if (point(2*i)*frameshift+framelength)>size(inputvoice.data,1)
            syllable(i).data=inputvoice.data(point(2*i-1)*frameshift+1:size(inputvoice.data,2));
        else
            syllable(i).data=inputvoice.data(point(2*i-1)*frameshift+1:point(2*i)*frameshift+framelength);
        end
    end
    %remove short frame
    k=1;
    recordremove=[];
    for i=1:size(syllable,2)
        if size(syllable(i).data,1)<=2*framelength
            recordremove(k)=i;
            k=k+1;
        end
    end
    if size(recordremove,1)~=0
        syllable(recordremove)=[];
    end
    %get MFCC for each syllable
    for i=1:size(syllable,2)
        syllable(i).feature=mfccfunction(syllable(i).data,fs);
        syllable(i).label=inputvoice.label(i);
        syllable(i).fs=inputvoice.fs(i);
        syllable(i).voicetype='Audible';
    end
end

if strcmp(voicetype,'Ultrasonic')
    energythreshold=0.001;
    zero_crossingthreshold=100;
    %framing
    frame=enframe(inputvoice.data,framelength,frameshift);
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
    index=find(energy>=energythreshold);
    index0=find(zero_crossing<zero_crossingthreshold);
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
    for i=1:size(point,2)/2
        if (point(2*i)*frameshift+framelength)>size(inputvoice.data,1)
            syllable(i).data=inputvoice.data(point(2*i-1)*frameshift+1:size(inputvoice.data,1));
        else
            syllable(i).data=inputvoice.data(point(2*i-1)*frameshift+1:point(2*i)*frameshift+framelength);
        end
    end
    
    %remove short frame
    k=1;
    recordremove=[];
    for i=1:size(syllable,2)
        if size(syllable(i).data,1)<=2*framelength
            recordremove(k)=i;
            k=k+1;
        end
    end

    if size(recordremove,1)~=0
        syllable(recordremove)=[];
    end
    %get rceps for each syllable
    for i=1:size(syllable,2)
        fram=enframe(syllable(i).data,4096,4096);
        for j=1:size(fram,1)
            zz(j,:)=rceps(fram(j,:));
        end
        syllable(i).feature=zz;
        syllable(i).label=inputvoice.label(i);
        syllable(i).fs=inputvoice.fs(i);
        syllable(i).voicetype='Ultrasonic';
    end
end

if strcmp(voicetype,'mix')
    energythreshold=0.001;
    zero_crossingthreshold=100;
    %framing
    frame=enframe(inputvoice.data,framelength,frameshift);
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
    index=find(energy>=energythreshold);
    index0=find(zero_crossing<zero_crossingthreshold);
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
    for i=1:size(point,2)/2
        if (point(2*i)*frameshift+framelength)>size(inputvoice.data,1)
            syllable(i).data=inputvoice.data(point(2*i-1)*frameshift+1:size(inputvoice.data,1));
        else
            syllable(i).data=inputvoice.data(point(2*i-1)*frameshift+1:point(2*i)*frameshift+framelength);
        end
    end
    %remove short frame
    k=1;
    recordremove=[];
    for i=1:size(syllable,2)
        if size(syllable(i).data,1)<=2*framelength
            recordremove(k)=i;
            k=k+1;
        end
    end

    if size(recordremove,1)~=0
        syllable(recordremove)=[];
    end
    %get MFCC or rceps for each syllable
    for i=1:size(syllable,2)
        if inputvoice.fs(i)>=20000
            fram=enframe(syllable(i).data,4096,4096);
            for j=1:size(fram,1)
                zz(j,:)=rceps(fram(j,:));
            end
            syllable(i).feature=zz;
            syllable(i).label=inputvoice.label(i);
            syllable(i).fs=inputvoice.fs(i);
            syllable(i).voicetype='Ultrasonic';
        else
            syllable(i).data = filter([1-0.9375],1,syllable(i).data);
            syllable(i).data=syllable(i).data/max(abs(syllable(i).data));
            syllable(i).feature=mfccfunction(syllable(i).data,8000);
            syllable(i).label=inputvoice.label(i);
            syllable(i).fs=inputvoice.fs(i);
            syllable(i).voicetype='Audible';
        end
    end
end

