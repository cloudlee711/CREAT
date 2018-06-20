clear all;

%% generate image data for TYPE I
load('E:\matlab\CRAET发布\datademon\image.mat');
for i=1:size(image,2)
    f=im2double(image(i).data);
    imageGray(i).data=f(:,:,1);
    imageGB(i).data=f(:,:,2:3);
    imageGB(i).data=f(:,:,2:3);
end

%% generate voice data for TYPE I
load('E:\matlab\CRAET发布\data\voice.mat');
for i=1:size(voice,2)
    for j=1:size(voice(i).label,2)
        voice(i).fs(j)=8000;
    end
end

%% generate ultrasonic data (syllable) for TYPE I
framelength=4096;
frameshift=4096;
noiseAltitude=1000;
%t=0:0.000001:0.1-0.000001;
t=0:0.0000001:0.01-0.0000001;
for round=1:35
    k=20000+(round-1)*3000;
    ultrasoniclib(round).data=2*sin(2*pi*k*t)+rand(1,length(t))/noiseAltitude;
    ultrasoniclib(round).data=ultrasoniclib(round).data/4;
    ultrasoniclib(round).fs=k;
    ultrasoniclib(round).label=['s' num2str(round)];
    fram=enframe(ultrasoniclib(round).data,4096,4096);
    for i=1:size(fram,1)
        z(i,:)=rceps(fram(i,:));
    end
    ultrasoniclib(round).feature=z;
end

% for i=1:size(ultrasoniclib,2)
%     for j=1:size(ultrasoniclib,2)
%         dis(i,j)=dtw(ultrasoniclib(i).feature,ultrasoniclib(j).feature);
%     end
% end

%% generate ultrasonic data (words) for TYPE I
framelength=4096;
frameshift=4096;
backgroundAltitude=1000;
noiseAltitude=100;
t=0:0.0000001:0.01-0.0000001;
for j=1:8
   for round=1:35
    k=20000+(round-1)*3000;
    ultrasonic(round).data=2*sin(2*pi*k*t)+rand(1,length(t))/noiseAltitude;
    ultrasonic(round).data=ultrasonic(round).data/4;
    ultrasonic(round).fs=k;
    ultrasonic(round).label=['s' num2str(round)];
    fram=enframe(ultrasonic(round).data,framelength,frameshift);
    for g=1:size(fram,1)
        z(g,:)=rceps(fram(g,:));
    end
    ultrasonic(round).feature=z;
   end 
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(1,j).data=[ultrasonic(1).data,background,ultrasonic(2).data];
   Ultrasonic4learn(1,j).fs=[ultrasonic(1).fs,ultrasonic(2).fs];
   Ultrasonic4learn(1,j).label(1).pronunciation=ultrasonic(1).label;
   Ultrasonic4learn(1,j).label(2).pronunciation=ultrasonic(2).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(2,j).data=[ultrasonic(3).data,background,ultrasonic(4).data];
   Ultrasonic4learn(2,j).fs=[ultrasonic(3).fs,ultrasonic(4).fs];
   Ultrasonic4learn(2,j).label(1).pronunciation=ultrasonic(3).label;
   Ultrasonic4learn(2,j).label(2).pronunciation=ultrasonic(4).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(3,j).data=[ultrasonic(5).data,background,ultrasonic(6).data,background,ultrasonic(2).data];
   Ultrasonic4learn(3,j).fs=[ultrasonic(5).fs,ultrasonic(6).fs,ultrasonic(2).fs];
   Ultrasonic4learn(3,j).label(1).pronunciation=ultrasonic(5).label;
   Ultrasonic4learn(3,j).label(2).pronunciation=ultrasonic(6).label;
   Ultrasonic4learn(3,j).label(3).pronunciation=ultrasonic(2).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(4,j).data=[ultrasonic(7).data,background,ultrasonic(8).data];
   Ultrasonic4learn(4,j).fs=[ultrasonic(7).fs,ultrasonic(8).fs];
   Ultrasonic4learn(4,j).label(1).pronunciation=ultrasonic(7).label;
   Ultrasonic4learn(4,j).label(2).pronunciation=ultrasonic(8).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(5,j).data=[ultrasonic(9).data,background,ultrasonic(4).data];
   Ultrasonic4learn(5,j).fs=[ultrasonic(9).fs,ultrasonic(4).fs];
   Ultrasonic4learn(5,j).label(1).pronunciation=ultrasonic(9).label;
   Ultrasonic4learn(5,j).label(2).pronunciation=ultrasonic(4).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(6,j).data=[ultrasonic(10).data,background,ultrasonic(11).data];
   Ultrasonic4learn(6,j).fs=[ultrasonic(10).fs,ultrasonic(11).fs];
   Ultrasonic4learn(6,j).label(1).pronunciation=ultrasonic(10).label;
   Ultrasonic4learn(6,j).label(2).pronunciation=ultrasonic(11).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(7,j).data=[ultrasonic(12).data,background,ultrasonic(13).data];
   Ultrasonic4learn(7,j).fs=[ultrasonic(12).fs,ultrasonic(13).fs];
   Ultrasonic4learn(7,j).label(1).pronunciation=ultrasonic(12).label;
   Ultrasonic4learn(7,j).label(2).pronunciation=ultrasonic(13).label;
      
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(8,j).data=[ultrasonic(14).data,background,ultrasonic(15).data];
   Ultrasonic4learn(8,j).fs=[ultrasonic(14).fs,ultrasonic(15).fs];
   Ultrasonic4learn(8,j).label(1).pronunciation=ultrasonic(14).label;
   Ultrasonic4learn(8,j).label(2).pronunciation=ultrasonic(15).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(9,j).data=[ultrasonic(16).data,background,ultrasonic(17).data];
   Ultrasonic4learn(9,j).fs=[ultrasonic(16).fs,ultrasonic(17).fs];
   Ultrasonic4learn(9,j).label(1).pronunciation=ultrasonic(16).label;
   Ultrasonic4learn(9,j).label(2).pronunciation=ultrasonic(17).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(10,j).data=[ultrasonic(18).data,background,ultrasonic(19).data];
   Ultrasonic4learn(10,j).fs=[ultrasonic(18).fs,ultrasonic(19).fs];
   Ultrasonic4learn(10,j).label(1).pronunciation=ultrasonic(18).label;
   Ultrasonic4learn(10,j).label(2).pronunciation=ultrasonic(19).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(11,j).data=[ultrasonic(20).data,background,ultrasonic(2).data];
   Ultrasonic4learn(11,j).fs=[ultrasonic(20).fs,ultrasonic(2).fs];
   Ultrasonic4learn(11,j).label(1).pronunciation=ultrasonic(20).label;
   Ultrasonic4learn(11,j).label(2).pronunciation=ultrasonic(2).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(12,j).data=[ultrasonic(21).data,background,ultrasonic(22).data];
   Ultrasonic4learn(12,j).fs=[ultrasonic(21).fs,ultrasonic(22).fs];
   Ultrasonic4learn(12,j).label(1).pronunciation=ultrasonic(21).label;
   Ultrasonic4learn(12,j).label(2).pronunciation=ultrasonic(22).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(13,j).data=[ultrasonic(23).data,background,ultrasonic(24).data];
   Ultrasonic4learn(13,j).fs=[ultrasonic(23).fs,ultrasonic(24).fs];
   Ultrasonic4learn(13,j).label(1).pronunciation=ultrasonic(23).label;
   Ultrasonic4learn(13,j).label(2).pronunciation=ultrasonic(24).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(14,j).data=[ultrasonic(17).data];
   Ultrasonic4learn(14,j).fs=[ultrasonic(17).fs];
   Ultrasonic4learn(14,j).label(1).pronunciation=ultrasonic(17).label;

   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(15,j).data=[ultrasonic(17).data];
   Ultrasonic4learn(15,j).fs=[ultrasonic(17).fs];
   Ultrasonic4learn(15,j).label(1).pronunciation=ultrasonic(17).label;

   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(16,j).data=[ultrasonic(25).data,background,ultrasonic(17).data];
   Ultrasonic4learn(16,j).fs=[ultrasonic(25).fs,ultrasonic(17).fs];
   Ultrasonic4learn(16,j).label(1).pronunciation=ultrasonic(25).label;
   Ultrasonic4learn(16,j).label(2).pronunciation=ultrasonic(17).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(17,j).data=[ultrasonic(26).data,background,ultrasonic(27).data];
   Ultrasonic4learn(17,j).fs=[ultrasonic(26).fs,ultrasonic(27).fs];
   Ultrasonic4learn(17,j).label(1).pronunciation=ultrasonic(26).label;
   Ultrasonic4learn(17,j).label(2).pronunciation=ultrasonic(27).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(18,j).data=[ultrasonic(28).data,background,ultrasonic(29).data];
   Ultrasonic4learn(18,j).fs=[ultrasonic(28).fs,ultrasonic(29).fs];
   Ultrasonic4learn(18,j).label(1).pronunciation=ultrasonic(28).label;
   Ultrasonic4learn(18,j).label(2).pronunciation=ultrasonic(29).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(19,j).data=[ultrasonic(30).data,background,ultrasonic(31).data];
   Ultrasonic4learn(19,j).fs=[ultrasonic(30).fs,ultrasonic(31).fs];
   Ultrasonic4learn(19,j).label(1).pronunciation=ultrasonic(30).label;
   Ultrasonic4learn(19,j).label(2).pronunciation=ultrasonic(31).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(20,j).data=[ultrasonic(32).data,background,ultrasonic(33).data];
   Ultrasonic4learn(20,j).fs=[ultrasonic(32).fs,ultrasonic(33).fs];
   Ultrasonic4learn(20,j).label(1).pronunciation=ultrasonic(32).label;
   Ultrasonic4learn(20,j).label(2).pronunciation=ultrasonic(33).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(21,j).data=[ultrasonic(13).data,background,ultrasonic(12).data];
   Ultrasonic4learn(21,j).fs=[ultrasonic(13).fs,ultrasonic(12).fs];
   Ultrasonic4learn(21,j).label(1).pronunciation=ultrasonic(13).label;
   Ultrasonic4learn(21,j).label(2).pronunciation=ultrasonic(12).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   Ultrasonic4learn(22,j).data=[ultrasonic(34).data,background,ultrasonic(35).data,background, ultrasonic(2).data];
   Ultrasonic4learn(22,j).fs=[ultrasonic(34).fs,ultrasonic(35).fs,ultrasonic(2).fs];
   Ultrasonic4learn(22,j).label(1).pronunciation=ultrasonic(34).label;
   Ultrasonic4learn(22,j).label(2).pronunciation=ultrasonic(35).label;
   Ultrasonic4learn(22,j).label(3).pronunciation=ultrasonic(2).label;
end
for i=1:size(Ultrasonic4learn,1)
    for j=1:size(Ultrasonic4learn,2)
        UltrasonicWord((i-1)*8+j).data=Ultrasonic4learn(i,j).data';   
        UltrasonicWord((i-1)*8+j).fs=Ultrasonic4learn(i,j).fs; 
        UltrasonicWord((i-1)*8+j).label=Ultrasonic4learn(i,j).label; 
    end
end

%% generate ultrasonic data (mixwords) for TYPE I
load('E:\matlab\CRAET发布\data\syllable.mat');
%t=0:0.000001:0.1-0.000001;
t=0:0.0000001:0.01-0.0000001;
framelength=4096;
frameshift=4096;
Audiblefs=8000;
noiseAltitude=100;
backgroundAltitude=1000;
for j=1:8
   for round=1:35
    k=20000+(round-1)*3000;
    ultrasonic(round).data=2*sin(2*pi*k*t)+rand(1,length(t))/noiseAltitude;
    ultrasonic(round).data=ultrasonic(round).data/4;
    ultrasonic(round).label=['s' num2str(round)];
    ultrasonic(round).fs=k;
    fram=enframe(ultrasonic(round).data,framelength,frameshift);
    z=[];
    for g=1:size(fram,1)
        z(g,:)=rceps(fram(g,:));
    end
    ultrasonic(round).feature=z;
   end 
   
   for round=1:36
       NoiseSyllable(round).data=syllable(round).pronunciation+((rand(1,size(syllable(round).pronunciation,1))-1)/noiseAltitude)';
       NoiseSyllable(round).mfccfeature=mfccfunction(NoiseSyllable(round).data,8000);
       NoiseSyllable(round).label=syllable(round).label;
   end
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(1,j).data=[ultrasonic(1).data,background,NoiseSyllable(8).data'];
   UltrasonicAndPronounedMixData4learn(1,j).feature(1).data=ultrasonic(1).feature;
   UltrasonicAndPronounedMixData4learn(1,j).feature(2).data=NoiseSyllable(8).mfccfeature;
   UltrasonicAndPronounedMixData4learn(1,j).fs=[ultrasonic(1).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(1,j).label(1).pronunciation=ultrasonic(1).label;
   UltrasonicAndPronounedMixData4learn(1,j).label(2).pronunciation=NoiseSyllable(8).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(2,j).data=[ultrasonic(3).data,background,NoiseSyllable(12).data'];
   UltrasonicAndPronounedMixData4learn(2,j).feature(1).data=ultrasonic(3).feature;
   UltrasonicAndPronounedMixData4learn(2,j).feature(2).data=NoiseSyllable(12).mfccfeature;
   UltrasonicAndPronounedMixData4learn(2,j).fs=[ultrasonic(3).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(2,j).label(1).pronunciation=ultrasonic(3).label;
   UltrasonicAndPronounedMixData4learn(2,j).label(2).pronunciation=NoiseSyllable(12).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(3,j).data=[ultrasonic(5).data,background,ultrasonic(6).data,background,NoiseSyllable(8).data'];
   UltrasonicAndPronounedMixData4learn(3,j).feature(1).data=ultrasonic(5).feature;
   UltrasonicAndPronounedMixData4learn(3,j).feature(2).data=ultrasonic(6).feature;
   UltrasonicAndPronounedMixData4learn(3,j).feature(3).data=NoiseSyllable(8).mfccfeature;
   UltrasonicAndPronounedMixData4learn(3,j).fs=[ultrasonic(5).fs,ultrasonic(6).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(3,j).label(1).pronunciation=ultrasonic(5).label;
   UltrasonicAndPronounedMixData4learn(3,j).label(2).pronunciation=ultrasonic(6).label;
   UltrasonicAndPronounedMixData4learn(3,j).label(3).pronunciation=NoiseSyllable(8).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(4,j).data=[ultrasonic(7).data,background,NoiseSyllable(23).data'];
   UltrasonicAndPronounedMixData4learn(4,j).feature(1).data=ultrasonic(7).feature;
   UltrasonicAndPronounedMixData4learn(4,j).feature(2).data=NoiseSyllable(23).mfccfeature;
   UltrasonicAndPronounedMixData4learn(4,j).fs=[ultrasonic(7).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(4,j).label(1).pronunciation=ultrasonic(7).label;
   UltrasonicAndPronounedMixData4learn(4,j).label(2).pronunciation=NoiseSyllable(23).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(5,j).data=[ultrasonic(9).data,background,NoiseSyllable(5).data'];
   UltrasonicAndPronounedMixData4learn(5,j).feature(1).data=ultrasonic(9).feature;
   UltrasonicAndPronounedMixData4learn(5,j).feature(2).data=NoiseSyllable(5).mfccfeature;
   UltrasonicAndPronounedMixData4learn(5,j).fs=[ultrasonic(9).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(5,j).label(1).pronunciation=ultrasonic(9).label;
   UltrasonicAndPronounedMixData4learn(5,j).label(2).pronunciation=NoiseSyllable(5).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(6,j).data=[ultrasonic(10).data,background,NoiseSyllable(19).data'];
   UltrasonicAndPronounedMixData4learn(6,j).feature(1).data=ultrasonic(10).feature;
   UltrasonicAndPronounedMixData4learn(6,j).feature(2).data=NoiseSyllable(19).mfccfeature;
   UltrasonicAndPronounedMixData4learn(6,j).fs=[ultrasonic(10).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(6,j).label(1).pronunciation=ultrasonic(10).label;
   UltrasonicAndPronounedMixData4learn(6,j).label(2).pronunciation=NoiseSyllable(19).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(7,j).data=[ultrasonic(12).data,background,NoiseSyllable(17).data'];
   UltrasonicAndPronounedMixData4learn(7,j).feature(1).data=ultrasonic(12).feature;
   UltrasonicAndPronounedMixData4learn(7,j).feature(2).data=NoiseSyllable(17).mfccfeature;
   UltrasonicAndPronounedMixData4learn(7,j).fs=[ultrasonic(12).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(7,j).label(1).pronunciation=ultrasonic(12).label;
   UltrasonicAndPronounedMixData4learn(7,j).label(2).pronunciation=NoiseSyllable(17).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(8,j).data=[ultrasonic(14).data,background,NoiseSyllable(25).data'];
   UltrasonicAndPronounedMixData4learn(8,j).feature(1).data=ultrasonic(14).feature;
   UltrasonicAndPronounedMixData4learn(8,j).feature(2).data=NoiseSyllable(25).mfccfeature;
   UltrasonicAndPronounedMixData4learn(8,j).fs=[ultrasonic(14).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(8,j).label(1).pronunciation=ultrasonic(14).label;
   UltrasonicAndPronounedMixData4learn(8,j).label(2).pronunciation=NoiseSyllable(25).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(9,j).data=[ultrasonic(16).data,background,NoiseSyllable(6).data'];
   UltrasonicAndPronounedMixData4learn(9,j).feature(1).data=ultrasonic(16).feature;
   UltrasonicAndPronounedMixData4learn(9,j).feature(2).data=NoiseSyllable(6).mfccfeature;
   UltrasonicAndPronounedMixData4learn(9,j).fs=[ultrasonic(16).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(9,j).label(1).pronunciation=ultrasonic(16).label;
   UltrasonicAndPronounedMixData4learn(9,j).label(2).pronunciation=NoiseSyllable(6).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(10,j).data=[ultrasonic(18).data,background,NoiseSyllable(10).data'];
   UltrasonicAndPronounedMixData4learn(10,j).feature(1).data=ultrasonic(18).feature;
   UltrasonicAndPronounedMixData4learn(10,j).feature(2).data=NoiseSyllable(10).mfccfeature;
   UltrasonicAndPronounedMixData4learn(10,j).fs=[ultrasonic(18).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(10,j).label(1).pronunciation=ultrasonic(18).label;
   UltrasonicAndPronounedMixData4learn(10,j).label(2).pronunciation=NoiseSyllable(10).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(11,j).data=[ultrasonic(20).data,background,NoiseSyllable(8).data'];
   UltrasonicAndPronounedMixData4learn(11,j).feature(1).data=ultrasonic(20).feature;
   UltrasonicAndPronounedMixData4learn(11,j).feature(2).data=NoiseSyllable(8).mfccfeature;
   UltrasonicAndPronounedMixData4learn(11,j).fs=[ultrasonic(20).fs,Audiblefs];
   UltrasonicAndPronounedMixData4learn(11,j).label(1).pronunciation=ultrasonic(20).label;
   UltrasonicAndPronounedMixData4learn(11,j).label(2).pronunciation=NoiseSyllable(8).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(12,j).data=[NoiseSyllable(27).data', background, ultrasonic(22).data];
   UltrasonicAndPronounedMixData4learn(12,j).feature(1).data=NoiseSyllable(27).mfccfeature;
   UltrasonicAndPronounedMixData4learn(12,j).feature(2).data=ultrasonic(22).feature;
   UltrasonicAndPronounedMixData4learn(12,j).fs=[Audiblefs,ultrasonic(22).fs];
   UltrasonicAndPronounedMixData4learn(12,j).label(1).pronunciation=NoiseSyllable(27).label;
   UltrasonicAndPronounedMixData4learn(12,j).label(2).pronunciation=ultrasonic(22).label;
   
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(13,j).data=[NoiseSyllable(29).data', background, ultrasonic(24).data];
   UltrasonicAndPronounedMixData4learn(13,j).feature(1).data=NoiseSyllable(29).mfccfeature;
   UltrasonicAndPronounedMixData4learn(13,j).feature(2).data=ultrasonic(24).feature;
   UltrasonicAndPronounedMixData4learn(13,j).fs=[Audiblefs,ultrasonic(24).fs];
   UltrasonicAndPronounedMixData4learn(13,j).label(1).pronunciation=NoiseSyllable(29).label;
   UltrasonicAndPronounedMixData4learn(13,j).label(2).pronunciation=ultrasonic(24).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(14,j).data=[NoiseSyllable(6).data'];
   UltrasonicAndPronounedMixData4learn(14,j).feature(1).data=NoiseSyllable(6).mfccfeature;
   UltrasonicAndPronounedMixData4learn(14,j).fs=[Audiblefs];
   UltrasonicAndPronounedMixData4learn(14,j).label(1).pronunciation=NoiseSyllable(6).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(15,j).data=[ultrasonic(17).data];
   UltrasonicAndPronounedMixData4learn(15,j).feature(1).data=ultrasonic(17).feature;
   UltrasonicAndPronounedMixData4learn(15,j).fs=[ultrasonic(17).fs];
   UltrasonicAndPronounedMixData4learn(15,j).label(1).pronunciation=ultrasonic(17).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(16,j).data=[NoiseSyllable(15).data', background, ultrasonic(17).data];
   UltrasonicAndPronounedMixData4learn(16,j).feature(1).data=NoiseSyllable(15).mfccfeature;
   UltrasonicAndPronounedMixData4learn(16,j).feature(2).data=ultrasonic(17).feature;
   UltrasonicAndPronounedMixData4learn(16,j).fs=[Audiblefs,ultrasonic(17).fs];
   UltrasonicAndPronounedMixData4learn(16,j).label(1).pronunciation=NoiseSyllable(15).label;
   UltrasonicAndPronounedMixData4learn(16,j).label(2).pronunciation=ultrasonic(17).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(17,j).data=[NoiseSyllable(31).data', background, ultrasonic(27).data];
   UltrasonicAndPronounedMixData4learn(17,j).feature(1).data=NoiseSyllable(31).mfccfeature;
   UltrasonicAndPronounedMixData4learn(17,j).feature(2).data=ultrasonic(27).feature;
   UltrasonicAndPronounedMixData4learn(17,j).fs=[Audiblefs,ultrasonic(27).fs];
   UltrasonicAndPronounedMixData4learn(17,j).label(1).pronunciation=NoiseSyllable(31).label;
   UltrasonicAndPronounedMixData4learn(17,j).label(2).pronunciation=ultrasonic(27).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(18,j).data=[NoiseSyllable(33).data', background, ultrasonic(29).data];
   UltrasonicAndPronounedMixData4learn(18,j).feature(1).data=NoiseSyllable(33).mfccfeature;
   UltrasonicAndPronounedMixData4learn(18,j).feature(2).data=ultrasonic(29).feature;
   UltrasonicAndPronounedMixData4learn(18,j).fs=[Audiblefs,ultrasonic(29).fs];
   UltrasonicAndPronounedMixData4learn(18,j).label(1).pronunciation=NoiseSyllable(33).label;
   UltrasonicAndPronounedMixData4learn(18,j).label(2).pronunciation=ultrasonic(29).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(19,j).data=[NoiseSyllable(35).data', background, ultrasonic(31).data];
   UltrasonicAndPronounedMixData4learn(19,j).feature(1).data=NoiseSyllable(35).mfccfeature;
   UltrasonicAndPronounedMixData4learn(19,j).feature(2).data=ultrasonic(31).feature;
   UltrasonicAndPronounedMixData4learn(19,j).fs=[Audiblefs,ultrasonic(31).fs];
   UltrasonicAndPronounedMixData4learn(19,j).label(1).pronunciation=NoiseSyllable(35).label;
   UltrasonicAndPronounedMixData4learn(19,j).label(2).pronunciation=ultrasonic(31).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(20,j).data=[NoiseSyllable(2).data', background, ultrasonic(33).data];
   UltrasonicAndPronounedMixData4learn(20,j).feature(1).data=NoiseSyllable(2).mfccfeature;
   UltrasonicAndPronounedMixData4learn(20,j).feature(2).data=ultrasonic(33).feature;
   UltrasonicAndPronounedMixData4learn(20,j).fs=[Audiblefs,ultrasonic(33).fs];
   UltrasonicAndPronounedMixData4learn(20,j).label(1).pronunciation=NoiseSyllable(2).label;
   UltrasonicAndPronounedMixData4learn(20,j).label(2).pronunciation=ultrasonic(33).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(21,j).data=[NoiseSyllable(17).data', background, ultrasonic(12).data];
   UltrasonicAndPronounedMixData4learn(21,j).feature(1).data=NoiseSyllable(17).mfccfeature;
   UltrasonicAndPronounedMixData4learn(21,j).feature(2).data=ultrasonic(12).feature;
   UltrasonicAndPronounedMixData4learn(21,j).fs=[Audiblefs,ultrasonic(12).fs];
   UltrasonicAndPronounedMixData4learn(21,j).label(1).pronunciation=NoiseSyllable(17).label;
   UltrasonicAndPronounedMixData4learn(21,j).label(2).pronunciation=ultrasonic(12).label;
   
   background=(rand(1,framelength*2)*2-1)/backgroundAltitude*3;
   UltrasonicAndPronounedMixData4learn(22,j).data=[NoiseSyllable(13).data',background,ultrasonic(35).data,background, ultrasonic(2).data];
   UltrasonicAndPronounedMixData4learn(22,j).feature(1).data=NoiseSyllable(13).mfccfeature;
   UltrasonicAndPronounedMixData4learn(22,j).feature(2).data=ultrasonic(35).feature;
   UltrasonicAndPronounedMixData4learn(22,j).feature(3).data=ultrasonic(2).feature;
   UltrasonicAndPronounedMixData4learn(22,j).fs=[Audiblefs,ultrasonic(35).fs,ultrasonic(2).fs];
   UltrasonicAndPronounedMixData4learn(22,j).label(1).pronunciation=NoiseSyllable(13).label;
   UltrasonicAndPronounedMixData4learn(22,j).label(2).pronunciation=ultrasonic(35).label;
   UltrasonicAndPronounedMixData4learn(22,j).label(3).pronunciation=ultrasonic(2).label;
end
for i=1:size(UltrasonicAndPronounedMixData4learn,1)
    for j=1:size(UltrasonicAndPronounedMixData4learn,2)
        UltrasonicSyllableMixWord((i-1)*8+j).data=UltrasonicAndPronounedMixData4learn(i,j).data';
        UltrasonicSyllableMixWord((i-1)*8+j).fs=UltrasonicAndPronounedMixData4learn(i,j).fs;
        UltrasonicSyllableMixWord((i-1)*8+j).label=UltrasonicAndPronounedMixData4learn(i,j).label;
    end
end

%% generate taste data for TYPE II
clear;
a=8;
%[sweet, sour, salt, bitter, umami, hot]
%apple
sweet=unifrnd(0.5,0.6,[a,1]);
sour=unifrnd(0,0.1,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

apple=[sweet,sour,salt,bitter,umami,hot];

%banana
sweet=unifrnd(0.4,0.5,[a,1]);
sour=zeros(a,1);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

banana=[sweet,sour,salt,bitter,umami,hot];

%cherrytomato
sweet=unifrnd(0.3,0.4,[a,1]);
sour=unifrnd(0.2,0.3,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);
cherrytomato=[sweet,sour,salt,bitter,umami,hot];

%chestnut
sweet=unifrnd(0.2,0.3,[a,1]);
sour=zeros(a,1);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);
chestnut=[sweet,sour,salt,bitter,umami,hot];

%pepper
sweet=zeros(a,1);
sour=zeros(a,1);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=unifrnd(0.9,1,[a,1]);

pepper=[sweet,sour,salt,bitter,umami,hot];

%egg
sweet=zeros(a,1);
sour=unifrnd(0,0.1,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=unifrnd(0.5,0.6,[a,1]);
hot=zeros(a,1);
egg=[sweet,sour,salt,bitter,umami,hot];

%pineapple
sweet=unifrnd(0.6,0.7,[a,1]);
sour=unifrnd(0.3,0.4,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

pineapple=[sweet,sour,salt,bitter,umami,hot];

%groundnut
sweet=unifrnd(0,0.1,[a,1]);
sour=zeros(a,1);
salt=unifrnd(0,0.1,[a,1]);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);
groundnut=[sweet,sour,salt,bitter,umami,hot];

%huangli
sweet=unifrnd(0.6,0.7,[a,1]);
sour=unifrnd(0,0.1,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

huangli=[sweet,sour,salt,bitter,umami,hot];


%lemmon
sweet=unifrnd(0,0.1,[a,1]);
sour=unifrnd(0.8,0.9,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

lemmon=[sweet,sour,salt,bitter,umami,hot];

%mango
sweet=unifrnd(0.7,0.8,[a,1]);
sour=unifrnd(0,0.1,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

mango=[sweet,sour,salt,bitter,umami,hot];

%onion
sweet=zeros(a,1);
sour=zeros(a,1);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=unifrnd(0.4,0.5,[a,1]);

onion=[sweet,sour,salt,bitter,umami,hot];

%orange
sweet=unifrnd(0.8,0.9,[a,1]);
sour=unifrnd(0,0.1,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

orange=[sweet,sour,salt,bitter,umami,hot];

%pearG
sweet=unifrnd(0.6,0.7,[a,1]);
sour=unifrnd(0.1,0.2,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

pearG=[sweet,sour,salt,bitter,umami,hot];

%pearY
sweet=unifrnd(0.6,0.7,[a,1]);
sour=unifrnd(0.1,0.2,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

pearY=[sweet,sour,salt,bitter,umami,hot];

%pomegranate
sweet=unifrnd(0.6,0.7,[a,1]);
sour=unifrnd(0.2,0.3,[a,1]);
salt=zeros(a,1);
bitter=unifrnd(0,0.1,[a,1]);
umami=zeros(a,1);
hot=zeros(a,1);

pomegranate=[sweet,sour,salt,bitter,umami,hot];


%potato
sweet=unifrnd(0,0.1,[a,1]);
sour=zeros(a,1);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

potato=[sweet,sour,salt,bitter,umami,hot];


%strawberry
sweet=unifrnd(0.5,0.6,[a,1]);
sour=unifrnd(0.2,0.3,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

strawberry=[sweet,sour,salt,bitter,umami,hot];

%tomato
sweet=unifrnd(0.1,0.2,[a,1]);
sour=unifrnd(0.5,0.6,[a,1]);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=zeros(a,1);

tomato=[sweet,sour,salt,bitter,umami,hot];

%turnip
sweet=unifrnd(0.1,0.2,[a,1]);
sour=zeros(a,1);
salt=zeros(a,1);
bitter=zeros(a,1);
umami=zeros(a,1);
hot=unifrnd(0.2,0.3,[a,1]);

turnip=[sweet,sour,salt,bitter,umami,hot];

tastedata.data=[apple;banana;cherrytomato;chestnut;pepper;egg;pineapple;...
    groundnut;huangli;lemmon;mango;onion;orange;pearG;pearY;pineapple;...
    pomegranate;potato;strawberry;tomato;turnip;apple];
tastedata.field ={'sweet','sour','salt','bitter','umami','hot'};

%% generate embedding data for perception circuit reuse (ultra sound and taste data)
framelength=4096;
frameshift=4096;
backgroundAltitude=1000;
noiseAltitude=100;
t=0:0.0000001:0.01-0.0000001;
% for j=1:8
%     for round=1:35
%         k=20000+(round-1)*3000;
%         ultrasonic(round).data=2*sin(2*pi*k*t)+rand(1,length(t))/noiseAltitude;
%         ultrasonic(round).data=ultrasonic(round).data/4;
%         ultrasonic(round).fs=k;
%         ultrasonic(round).label=['s' num2str(round)];
%         fram=enframe(ultrasonic(round).data,framelength,frameshift);
%         for g=1:size(fram,1)
%             z(g,:)=rceps(fram(g,:));
%         end
%         ultrasonic(round).feature=z;
%     end
%     UltraEmbed(1,j).data=ultrasonic(1).data;
%     UltraEmbed(2,j).data=ultrasonic(2).data;
%     UltraEmbed(3,j).data=ultrasonic(3).data;
%     UltraEmbed(4,j).data=ultrasonic(4).data;
%     UltraEmbed(5,j).data=ultrasonic(5).data;
%     UltraEmbed(6,j).data=ultrasonic(6).data;
%     UltraEmbed(7,j).data=ultrasonic(7).data;
%     UltraEmbed(8,j).data=ultrasonic(8).data;
%     UltraEmbed(9,j).data=ultrasonic(9).data;
%     UltraEmbed(10,j).data=ultrasonic(10).data;
%     UltraEmbed(11,j).data=ultrasonic(11).data;
%     UltraEmbed(12,j).data=ultrasonic(12).data;
%     UltraEmbed(13,j).data=ultrasonic(13).data;
%     UltraEmbed(14,j).data=ultrasonic(14).data;
%     UltraEmbed(15,j).data=ultrasonic(15).data;
%     UltraEmbed(16,j).data=ultrasonic(16).data;
%     UltraEmbed(17,j).data=ultrasonic(17).data;
%     UltraEmbed(18,j).data=ultrasonic(18).data;
%     UltraEmbed(19,j).data=ultrasonic(19).data;
%     UltraEmbed(20,j).data=ultrasonic(20).data;
%     UltraEmbed(21,j).data=ultrasonic(21).data;
%     UltraEmbed(22,j).data=ultrasonic(22).data;
%     
%     UltraEmbed(1,j).label=ultrasonic(1).label;
%     UltraEmbed(2,j).label=ultrasonic(2).label;
%     UltraEmbed(3,j).label=ultrasonic(3).label;
%     UltraEmbed(4,j).label=ultrasonic(4).label;
%     UltraEmbed(5,j).label=ultrasonic(5).label;
%     UltraEmbed(6,j).label=ultrasonic(6).label;
%     UltraEmbed(7,j).label=ultrasonic(7).label;
%     UltraEmbed(8,j).label=ultrasonic(8).label;
%     UltraEmbed(9,j).label=ultrasonic(9).label;
%     UltraEmbed(10,j).label=ultrasonic(10).label;
%     UltraEmbed(11,j).label=ultrasonic(11).label;
%     UltraEmbed(12,j).label=ultrasonic(12).label;
%     UltraEmbed(13,j).label=ultrasonic(13).label;
%     UltraEmbed(14,j).label=ultrasonic(14).label;
%     UltraEmbed(15,j).label=ultrasonic(15).label;
%     UltraEmbed(16,j).label=ultrasonic(16).label;
%     UltraEmbed(17,j).label=ultrasonic(17).label;
%     UltraEmbed(18,j).label=ultrasonic(18).label;
%     UltraEmbed(19,j).label=ultrasonic(19).label;
%     UltraEmbed(20,j).label=ultrasonic(20).label;
%     UltraEmbed(21,j).label=ultrasonic(21).label;
%     UltraEmbed(22,j).label=ultrasonic(22).label;
%     
%     UltraEmbed(1,j).fs=ultrasonic(1).fs;
%     UltraEmbed(2,j).fs=ultrasonic(2).fs;
%     UltraEmbed(3,j).fs=ultrasonic(3).fs;
%     UltraEmbed(4,j).fs=ultrasonic(4).fs;
%     UltraEmbed(5,j).fs=ultrasonic(5).fs;
%     UltraEmbed(6,j).fs=ultrasonic(6).fs;
%     UltraEmbed(7,j).fs=ultrasonic(7).fs;
%     UltraEmbed(8,j).fs=ultrasonic(8).fs;
%     UltraEmbed(9,j).fs=ultrasonic(9).fs;
%     UltraEmbed(10,j).fs=ultrasonic(10).fs;
%     UltraEmbed(11,j).fs=ultrasonic(11).fs;
%     UltraEmbed(12,j).fs=ultrasonic(12).fs;
%     UltraEmbed(13,j).fs=ultrasonic(13).fs;
%     UltraEmbed(14,j).fs=ultrasonic(14).fs;
%     UltraEmbed(15,j).fs=ultrasonic(15).fs;
%     UltraEmbed(16,j).fs=ultrasonic(16).fs;
%     UltraEmbed(17,j).fs=ultrasonic(17).fs;
%     UltraEmbed(18,j).fs=ultrasonic(18).fs;
%     UltraEmbed(19,j).fs=ultrasonic(19).fs;
%     UltraEmbed(20,j).fs=ultrasonic(20).fs;
%     UltraEmbed(21,j).fs=ultrasonic(21).fs;
%     UltraEmbed(22,j).fs=ultrasonic(22).fs;
% end

for j=1:8
   for round=1:35
    k=20000+(round-1)*3000;
    ultrasonic(round).data=2*sin(2*pi*k*t)+rand(1,length(t))/noiseAltitude;
    ultrasonic(round).data=ultrasonic(round).data/4;
    ultrasonic(round).fs=k;
    ultrasonic(round).label=['s' num2str(round)];
    fram=enframe(ultrasonic(round).data,framelength,frameshift);
    for g=1:size(fram,1)
        z(g,:)=rceps(fram(g,:));
    end
    ultrasonic(round).feature=z;
   end 
   UltraEmbed(1,j).data=ultrasonic(1).data;
   UltraEmbed(2,j).data=ultrasonic(2).data;  
   UltraEmbed(3,j).data=ultrasonic(3).data;  
   UltraEmbed(4,j).data=ultrasonic(4).data;  
   UltraEmbed(5,j).data=ultrasonic(5).data;  
   UltraEmbed(6,j).data=ultrasonic(6).data;  
   UltraEmbed(7,j).data=ultrasonic(7).data;
   UltraEmbed(8,j).data=ultrasonic(8).data;  
   UltraEmbed(9,j).data=ultrasonic(9).data;  
   UltraEmbed(10,j).data=ultrasonic(10).data;  
   UltraEmbed(11,j).data=ultrasonic(11).data;
   UltraEmbed(12,j).data=ultrasonic(12).data;
   UltraEmbed(13,j).data=ultrasonic(13).data;
   UltraEmbed(14,j).data=ultrasonic(14).data;
   UltraEmbed(15,j).data=ultrasonic(14).data;
   UltraEmbed(16,j).data=ultrasonic(7).data;
   UltraEmbed(17,j).data=ultrasonic(15).data;
   UltraEmbed(18,j).data=ultrasonic(16).data;
   UltraEmbed(19,j).data=ultrasonic(17).data;
   UltraEmbed(20,j).data=ultrasonic(18).data;
   UltraEmbed(21,j).data=ultrasonic(19).data;
   UltraEmbed(22,j).data=ultrasonic(1).data;
   
   UltraEmbed(1,j).label=ultrasonic(1).label;
   UltraEmbed(2,j).label=ultrasonic(2).label;  
   UltraEmbed(3,j).label=ultrasonic(3).label;  
   UltraEmbed(4,j).label=ultrasonic(4).label;  
   UltraEmbed(5,j).label=ultrasonic(5).label;  
   UltraEmbed(6,j).label=ultrasonic(6).label;  
   UltraEmbed(7,j).label=ultrasonic(7).label;
   UltraEmbed(8,j).label=ultrasonic(8).label;  
   UltraEmbed(9,j).label=ultrasonic(9).label;  
   UltraEmbed(10,j).label=ultrasonic(10).label;  
   UltraEmbed(11,j).label=ultrasonic(11).label;
   UltraEmbed(12,j).label=ultrasonic(12).label;
   UltraEmbed(13,j).label=ultrasonic(13).label;
   UltraEmbed(14,j).label=ultrasonic(14).label;
   UltraEmbed(15,j).label=ultrasonic(14).label;
   UltraEmbed(16,j).label=ultrasonic(7).label;
   UltraEmbed(17,j).label=ultrasonic(15).label;
   UltraEmbed(18,j).label=ultrasonic(16).label;
   UltraEmbed(19,j).label=ultrasonic(17).label;
   UltraEmbed(20,j).label=ultrasonic(18).label;
   UltraEmbed(21,j).label=ultrasonic(19).label;
   UltraEmbed(22,j).label=ultrasonic(1).label;
   
   UltraEmbed(1,j).fs=ultrasonic(1).fs;
   UltraEmbed(2,j).fs=ultrasonic(2).fs;  
   UltraEmbed(3,j).fs=ultrasonic(3).fs;  
   UltraEmbed(4,j).fs=ultrasonic(4).fs;  
   UltraEmbed(5,j).fs=ultrasonic(5).fs;  
   UltraEmbed(6,j).fs=ultrasonic(6).fs;  
   UltraEmbed(7,j).fs=ultrasonic(7).fs;
   UltraEmbed(8,j).fs=ultrasonic(8).fs;  
   UltraEmbed(9,j).fs=ultrasonic(9).fs;  
   UltraEmbed(10,j).fs=ultrasonic(10).fs;  
   UltraEmbed(11,j).fs=ultrasonic(11).fs;
   UltraEmbed(12,j).fs=ultrasonic(12).fs;
   UltraEmbed(13,j).fs=ultrasonic(13).fs;
   UltraEmbed(14,j).fs=ultrasonic(14).fs;
   UltraEmbed(15,j).fs=ultrasonic(14).fs;
   UltraEmbed(16,j).fs=ultrasonic(7).fs;
   UltraEmbed(17,j).fs=ultrasonic(15).fs;
   UltraEmbed(18,j).fs=ultrasonic(16).fs;
   UltraEmbed(19,j).fs=ultrasonic(17).fs;
   UltraEmbed(20,j).fs=ultrasonic(18).fs;
   UltraEmbed(21,j).fs=ultrasonic(19).fs;
   UltraEmbed(22,j).fs=ultrasonic(1).fs;
end

for i=1:size(UltraEmbed,1)
    for j=1:size(UltraEmbed,2)
        UltraEmbedding((i-1)*8+j).data=UltraEmbed(i,j).data';   
        UltraEmbedding((i-1)*8+j).fs=UltraEmbed(i,j).fs; 
        UltraEmbedding((i-1)*8+j).label(1).pronunciation=UltraEmbed(i,j).label; 
    end
end




name={'ping guo';'xiang jiao';'sheng nv guo';'ban li';'la jiao';'ji dan'...
    ;'bo luo';'hua sheng';'huang li';'ning meng';'mang guo';'yang cong';'gan ju'...
    ;'li';'li';'feng li';'shi liu';'tu dou';'cao mei';'fan qie';'luo bo';'zhi hui guo'};

% 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
% 1 2 3 4 5 6 7 8 9 10 11 12 13 14 14 7  15 16 17 18 19 1
