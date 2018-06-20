clear all;

global sensefield;

global colorConceptNeuron;
global outlineConceptNeuron;
global viewConceptNeuron;

global voicefield;
global syllableConceptNeuron;
global wordConceptNeuron;


global basictastefield;
global basictasteConceptNeuron;
global tasteConceptNeuron;

global associatedNeuron;

global featureNeuronSOMconnection;
global connectionPSA2SAA;
global connectionSAA2HAA;
global associatedconnection;


sensefield={};
voicefield={};
basictastefield={};

featureNeuronSOMconnection.outline=[];
featureNeuronSOMconnection.color=[];
featureNeuronSOMconnection.Audible=[];
featureNeuronSOMconnection.Ultrasonic=[];

connectionPSA2SAA.outline2view=[];
connectionPSA2SAA.color2view=[];

connectionPSA2SAA.syllable2word=[];
connectionPSA2SAA.sweet2taste=[];
connectionPSA2SAA.sour2taste=[];
connectionPSA2SAA.salt2taste=[];
connectionPSA2SAA.bitter2taste=[];
connectionPSA2SAA.umami2taste=[];
connectionPSA2SAA.hot2taste=[];
for i=1:176
    label(i)=ceil(i/8);
end
%% CRATE Phase 1
sensefield{1}='view';
outlinethreshold=4;
load('E:\matlab\CRAET发布\data\imageGray.mat');
ptic('\n*** Network has GRAY channel to learn...\n');
for t=1:size(imageGray,2)
    inputimageGray=imageGray(t).data;
    tlabel=label(t);
    % extract outline feature
    [NFD FD bimage] = outlinecatch(inputimageGray);
    outline = outlinefeaturemap (NFD,FD,outlinethreshold,tlabel);
    viewPSAsignal.outline = outline;
    % construct visual primary concept
    OIDSconceptgenerate (viewPSAsignal,'view');
end
ptoc('*** GRAY channel learning finish ');

ptic('\n*** show the most response image for each viewConceptNeuron...\n');
figure(1);
NFD=[];
FD=[];
for t=1:size(imageGray,2)
    inputimageGray=imageGray(t).data;
    [NFD(t).data, FD(t).data] = outlinecatch(inputimageGray);
end
for i=1:size(viewConceptNeuron,2)
    for t=1:size(imageGray,2)
        dis(t)=norm(NFD(t).data(3:25)-outlineConceptNeuron(viewConceptNeuron(i).outline).data);
    end
    [~,index]=min(dis);
    subplot(ceil(size(viewConceptNeuron,2)/7),7,i);
    plot(ifft(FD(index).data),'color','k','linewidth',1);
end
ptoc('*** show the most response image for each viewConceptNeuro finish\n');

ptic('\n*** save learning result...\n');
save('E:\matlab\CRAET发布\LearningResultAtDiffernetStage\ResultPhase1.mat',...
    'outlineConceptNeuron', 'viewConceptNeuron',...
    'connectionPSA2SAA', 'featureNeuronSOMconnection');
ptoc('*** save learning result finish\n');


%% CRATE Phase 2
load('E:\matlab\CRAET发布\data\imageGB.mat');
colorthreshold=4;
containersize=0.05;
display('\n*** Network has GRAY+GB channel to learn...\n');
tic;
for t=1:size(imageGB,2)
    inputimageGray=imageGray(t).data;
    inputimageGB=imageGB(t).data;
    tlabel=label(t);
    % extract outline feature
    [NFD FD bimage] = outlinecatch(inputimageGray);
    outline = outlinefeaturemap (NFD,FD,outlinethreshold,tlabel);
    % extract color feature
    [CH gg image2]=colorhistogram(bimage,containersize,inputimageGB);
    [color disLspace disHspace]= colorfeaturemap (CH,colorthreshold,tlabel);
    % construct visual primary concept
    viewPSAsignal.outline = outline;
    viewPSAsignal.color = color;
    OIDSconceptgenerate (viewPSAsignal,'view');
end
toc;
display('*** GRAY+GB channel learning finish');

display('\n*** show the viewConceptNeuron with GB color...\n');
tic;
figure(2);
NFD=[];
FD=[];
k=0;
plotindex=1;
for i=1:size(viewConceptNeuron,2)
    for j=1:size(viewConceptNeuron(i).color,2)
        k=k+1;
    end
end
for t=1:size(imageGray,2)
    inputimageGray=imageGray(t).data;
    inputimageGB=imageGB(t).data;
    [NFD(t).data, FD(t).data] = outlinecatch(inputimageGray);
end
for i=1:size(viewConceptNeuron,2)
    for t=1:size(imageGray,2)
        dis(t)=norm(NFD(t).data(3:25)-outlineConceptNeuron(viewConceptNeuron(i).outline).data);
    end
    [~,index]=min(dis);
    for j=1:size(viewConceptNeuron(i).color,2)
        colorRGB=colorhistogram2RGB (colorConceptNeuron(viewConceptNeuron(i).color(j)).data,containersize,'GB');
        subplot(ceil(k/10),10,plotindex);
        plot(ifft(FD(index).data),'color', colorRGB, 'linewidth',1);
        plotindex=plotindex+1;
    end
end
toc;
display('*** show the viewConceptNeuron with GB color finish\n');


display('\n*** save learning result...\n');
tic;
save('E:\matlab\CRAET发布\LearningResultAtDiffernetStage\ResultPhase2.mat',...
    'outlineConceptNeuron', 'colorConceptNeuron', 'viewConceptNeuron',...
    'connectionPSA2SAA', 'featureNeuronSOMconnection');
toc;
display('*** save learning result finish\n');

%% CRATE Phase 3
load('E:\matlab\CRAET发布\data\image.mat');
display('\n*** Network has GRAY+RGB channel to learn...\n');
tic;
for t=1:size(image,2)
    inputimageGray=imageGray(t).data;
    inputimageRGB=image(t).data;
    tlabel=label(t);
    % extract outline feature
    [NFD FD bimage] = outlinecatch(inputimageGray);
    outline = outlinefeaturemap (NFD,FD,outlinethreshold,tlabel);
    % extract color feature
    [CH gg image2]=colorhistogram(bimage,containersize,inputimageRGB);
    [color disLspace disHspace]= colorfeaturemap (CH,colorthreshold,tlabel);
    % construct visual primary concept
    viewPSAsignal.outline = outline;
    viewPSAsignal.color = color;
    OIDSconceptgenerate (viewPSAsignal,'view');
end
toc;
display('*** GRAY+RGB channel learning finish');

display('\n*** show the viewConceptNeuron with RGB color...\n');
tic;
figure(3);
NFD=[];
FD=[];
k=0;
plotindex=1;
for i=1:size(viewConceptNeuron,2)
    for j=1:size(viewConceptNeuron(i).color,2)
        k=k+1;
    end
end
for t=1:size(imageGray,2)
    inputimageGray=imageGray(t).data;
    inputimageGB=imageGB(t).data;
    [NFD(t).data, FD(t).data] = outlinecatch(inputimageGray);
end
for i=1:size(viewConceptNeuron,2)
    for t=1:size(imageGray,2)
        dis(t)=norm(NFD(t).data(3:25)-outlineConceptNeuron(viewConceptNeuron(i).outline).data);
    end
    [~,index]=min(dis);
    for j=1:size(viewConceptNeuron(i).color,2)
        color=colorhistogram2RGB (colorConceptNeuron(viewConceptNeuron(i).color(j)).data,containersize,'RGB');
        subplot(ceil(k/10),10,plotindex);
        %plot(ifft(outlineConceptNeuron(viewConceptNeuron(i).outline).FD),'color', color, 'linewidth',4);
        plot(ifft(FD(index).data),'color', color, 'linewidth',4);
        plotindex=plotindex+1;
    end
end
toc;
display('*** show the viewConceptNeuron with RGB color finish\n');

display('\n*** save learning result...\n');
tic;
save('E:\matlab\CRAET发布\LearningResultAtDiffernetStage\ResultPhase3.mat',...
    'outlineConceptNeuron', 'colorConceptNeuron', 'viewConceptNeuron',...
    'connectionPSA2SAA', 'featureNeuronSOMconnection');
toc;
display('*** save learning result finish\n');

%% CRATE Phase 4
load('E:\matlab\CRAET发布\data\syllable.mat');
load('E:\matlab\CRAET发布\data\voice.mat');
sensefield{2}='audition';
fs=8000;
syllablethreshold.Audible=200;
display('\n*** Network has VISION + AUDITION (audible) channel to learn...\n');
fprintf('\n Need your feedback...\n');
tic;
for t=1:size(voice,2)
    % vision channel
    inputimageRGB=image(t).data;
    inputimageGray=imageGray(t).data;
    tlabel=label(t);
    % extract outline feature
    [NFD FD bimage] = outlinecatch(inputimageGray);
    outline = outlinefeaturemap (NFD,FD,outlinethreshold,tlabel);
    % extract color feature
    [CH gg image2]=colorhistogram(bimage,containersize,inputimageRGB);  
    [color disLspace disHspace]= colorfeaturemap (CH,colorthreshold,tlabel);
    % construct visual primary concept
    viewPSAsignal.outline = outline;
    viewPSAsignal.color = color;
    viewfiringsigal = OIDSconceptgenerate (viewPSAsignal,'view');
    % package the visual channel data
    currentview.input=inputimageRGB;
    currentview.FD=FD;
    currentview.NFD=NFD;
    currentview.CH=CH;
    currentview.outline=outline;
    currentview.color=color;
    % audition channel
    inputvoice=voice(t);
    syllables=inputvoice2syllable (inputvoice,'Audible');
    [firingSyllables winnersyllable] = syllablefeaturemap (syllables, syllablethreshold);
    % package the visual channel data
    currentaudition.inputvoice=inputvoice;
    currentaudition.syllables=syllables;
    currentaudition.winnersyllable=winnersyllable;
    % construct auditory primary concept
    wordfiringsignal = ODSconceptgenerate (firingSyllables,'audition');
    % generate input signals to associated areas 
    combinesignals.view=viewfiringsigal;
    combinesignals.audition=wordfiringsignal;
    % associated
    associatedcortex (combinesignals, currentaudition, currentview);
    
end
toc;
display('*** VISION + AUDITION (audible) channel learning finish');

display('\n*** show the learning results after AUDITION (audible) channel added...\n');
tic;
figure(4);
NFD=[];
FD=[];
k=0;
plotindex=1;
for i=1:size(viewConceptNeuron,2)
    for j=1:size(viewConceptNeuron(i).color,2)
        k=k+1;
    end
end
for t=1:size(imageGray,2)
    inputimageGray=imageGray(t).data;
    inputimageGB=imageGB(t).data;
    [NFD(t).data, FD(t).data] = outlinecatch(inputimageGray);
end
for i=1:size(viewConceptNeuron,2)
    for t=1:size(imageGray,2)
        dis(t)=norm(NFD(t).data(3:25)-outlineConceptNeuron(viewConceptNeuron(i).outline).data);
    end
    [~,index(i)]=min(dis);
end

for i=1:size(associatedNeuron,2)
    subplot(ceil(size(associatedNeuron,2)/10),10,plotindex);
    p=1;
    for j=1:size(associatedNeuron(i).view,2)
        if ~isempty(viewConceptNeuron(associatedNeuron(i).view(j)).color)
            plot(ifft(FD(index(associatedNeuron(i).view(j))).data), 'color', ...
                colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron...
                (associatedNeuron(i).view(j)).color(1)).data,0.05,'RGB'),'linewidth',7);
            p=p+1;
        else
            plot(ifft(FD(index(associatedNeuron(i).view(j))).data), 'color','k','linewidth',7);
            p=p+1;
        end
        str=[];
%         if ~isempty(associatedNeuron(i).audition)
%             for k=1:size(wordConceptNeuron(associatedNeuron(i).audition(1)).order,2)
%                 str=[str syllableConceptNeuron.Audible(wordConceptNeuron...
%                     (associatedNeuron(i).audition(1)).order(k)).label.pronunciation];
%             end
%             title(str);
%         end
        
        if ~isempty(associatedNeuron(i).audition)
            for k=1:size(associatedNeuron(i).audition)
                for l=1:size(wordConceptNeuron(associatedNeuron(i).audition(k)).order,2)
                    if wordConceptNeuron(associatedNeuron(i).audition(k)).order(l)>size(syllableConceptNeuron.Audible,2)
                        break;
                    else
                        str=[str syllableConceptNeuron.Audible(wordConceptNeuron...
                            (associatedNeuron(i).audition(k)).order(l)).label.pronunciation];
                    end
                end
            end
            title(str);
        end
        
    end
    plotindex=plotindex+1;
end
toc;
display('*** show the learning results after AUDITION (audible) channel added finish\n');

display('\n*** save learning result...\n');
tic;
save('E:\matlab\CRAET发布\LearningResultAtDiffernetStage\ResultPhase4.mat',...
    'outlineConceptNeuron', 'colorConceptNeuron','syllableConceptNeuron', ...
    'viewConceptNeuron', 'wordConceptNeuron', 'associatedNeuron',...
    'featureNeuronSOMconnection', 'connectionPSA2SAA', 'connectionSAA2HAA',...
    'associatedconnection');
toc;
display('*** save learning result finish\n');
 
%% CRATE Phase 5
load('E:\matlab\CRAET发布\data\UltrasonicWord.mat');
display('\n*** Network has VISION + AUDITION (ultrasonic) channel to learn...\n');
fprintf('\n Need your feedback...\n');
tic;
syllablethreshold.Ultrasonic=9;
for t=1:size(UltrasonicWord,2)
    % vision channel
    inputimageRGB=image(t).data;
    inputimageGray=imageGray(t).data;
    tlabel=label(t);
    % extract outline feature
    [NFD FD bimage] = outlinecatch(inputimageGray);
    outline = outlinefeaturemap (NFD,FD,outlinethreshold,tlabel);
    % extract color feature
    [CH gg image2]=colorhistogram(bimage,containersize,inputimageRGB);  
    [color disLspace disHspace]= colorfeaturemap (CH,colorthreshold,tlabel);
    % construct visual primary concept
    viewPSAsignal.outline = outline;
    viewPSAsignal.color = color;
    viewfiringsigal = OIDSconceptgenerate (viewPSAsignal,'view');
    % package the visual channel data
    currentview.input=inputimageRGB;
    currentview.FD=FD;
    currentview.NFD=NFD;
    currentview.CH=CH;
    currentview.outline=outline;
    currentview.color=color;
    % audition channel
    inputvoice=UltrasonicWord(t);
    [syllables]=inputvoice2syllable (inputvoice,'Ultrasonic');
    [firingSyllables winnersyllable] = syllablefeaturemap (syllables, syllablethreshold);
    % package the visual channel data
    currentaudition.inputvoice=inputvoice;
    currentaudition.syllables=syllables;
    currentaudition.winnersyllable=winnersyllable;
    % construct auditory primary concept
    wordfiringsignal = ODSconceptgenerate (firingSyllables,'audition');
    % generate input signals to associated areas 
    combinesignals.view=viewfiringsigal;
    combinesignals.audition=wordfiringsignal;
    % associated
    associatedcortex (combinesignals, currentaudition, currentview);
end
toc;
display('*** VISION + AUDITION (ultrasonic) channel learning finish')

display('\n*** show the learning results after AUDITION (ultrasonic) channel added...\n');
tic;
figure(5);
NFD=[];
FD=[];
k=0;
plotindex=1;
for i=1:size(viewConceptNeuron,2)
    for j=1:size(viewConceptNeuron(i).color,2)
        k=k+1;
    end
end
for t=1:size(imageGray,2)
    inputimageGray=imageGray(t).data;
    inputimageGB=imageGB(t).data;
    [NFD(t).data, FD(t).data] = outlinecatch(inputimageGray);
end
for i=1:size(viewConceptNeuron,2)
    for t=1:size(imageGray,2)
        dis(t)=norm(NFD(t).data(3:25)-outlineConceptNeuron(viewConceptNeuron(i).outline).data);
    end
    [~,index(i)]=min(dis);
end

for i=1:size(associatedNeuron,2)
    subplot(ceil(size(associatedNeuron,2)/10),10,plotindex);
    p=1;
    for j=1:size(associatedNeuron(i).view,2)
        if ~isempty(viewConceptNeuron(associatedNeuron(i).view(j)).color)
            plot(ifft(FD(index(associatedNeuron(i).view(j))).data), 'color', ...
                colorhistogram2RGB(colorConceptNeuron...
                (viewConceptNeuron(associatedNeuron(i).view(j)).color(1)).data,0.05,'RGB'),'linewidth',7);
            p=p+1;
        else
            plot(ifft(FD(index(associatedNeuron(i).view(j))).data), 'color','k','linewidth',7);
            p=p+1;
        end
        str=[];
        name=[];
        if ~isempty(associatedNeuron(i).audition)
            for k=1:size(associatedNeuron(i).audition,2)
                name{k}=findpronunciation(wordConceptNeuron(associatedNeuron(i).audition(k)).order);
            end
            str=unique(name);
            name=[];
            for k=1:size(str,2)
                name=[name ' ' str{k}];
            end
            title(name,'FontSize',7);
        end
    end
    plotindex=plotindex+1;
end
toc;
display('*** show the learning results after AUDITION (ultrasonic) channel added finish\n');

display('\n*** save learning result...\n');
tic;
save('E:\matlab\CRAET发布\LearningResultAtDiffernetStage\ResultPhase5.mat',...
    'outlineConceptNeuron', 'colorConceptNeuron','syllableConceptNeuron', ...
    'viewConceptNeuron', 'wordConceptNeuron', 'associatedNeuron',...
    'featureNeuronSOMconnection', 'connectionPSA2SAA', 'connectionSAA2HAA',...
    'associatedconnection');
toc;
display('*** save learning result finish\n');

%% CRATE Phase 6
load('E:\matlab\CRAET发布\data\UltrasonicSyllableMixWord.mat');
display('\n*** Network has VISION + AUDITION (audibal+ultrasonic) channel to learn...\n');
fprintf('\n Need your feedback...\n');
tic;
for t=1:size(UltrasonicSyllableMixWord,2)
    % vision channel
    inputimageRGB=image(t).data;
    inputimageGray=imageGray(t).data;
    tlabel=label(t);
    % extract outline feature
    [NFD FD bimage] = outlinecatch(inputimageGray);
    outline = outlinefeaturemap (NFD,FD,outlinethreshold,tlabel);
    % extract color feature
    [CH gg image2]=colorhistogram(bimage,containersize,inputimageRGB);  
    [color disLspace disHspace]= colorfeaturemap (CH,colorthreshold,tlabel);
    % construct visual primary concept
    viewPSAsignal.outline = outline;
    viewPSAsignal.color = color;
    viewfiringsigal = OIDSconceptgenerate (viewPSAsignal,'view');
    % package the visual channel data
    currentview.input=inputimageRGB;
    currentview.FD=FD;
    currentview.NFD=NFD;
    currentview.CH=CH;
    currentview.outline=outline;
    currentview.color=color;
    % audition channel
    inputvoice=UltrasonicSyllableMixWord(t);
    [syllables]=inputvoice2syllable (inputvoice,'mix');
    [firingSyllables winnersyllable] = syllablefeaturemap (syllables, syllablethreshold);
    % package the visual channel data
    currentaudition.inputvoice=inputvoice;
    currentaudition.syllables=syllables;
    currentaudition.winnersyllable=winnersyllable;
    % construct auditory primary concept
    wordfiringsignal = ODSconceptgenerate (firingSyllables,'audition');
    % generate input signals to associated areas 
    combinesignals.view=viewfiringsigal;
    combinesignals.audition=wordfiringsignal;
    % associated
    associatedcortex (combinesignals, currentaudition, currentview);
end
toc;
display('*** VISION + AUDITION (audibal+ultrasonic) channel learning finish');

display('\n*** show the learning results after AUDITION (audibal+ultrasonic) channel added...\n')
tic;
figure(6);
NFD=[];
FD=[];
k=0;
plotindex=1;
for i=1:size(viewConceptNeuron,2)
    for j=1:size(viewConceptNeuron(i).color,2)
        k=k+1;
    end
end
for t=1:size(imageGray,2)
    inputimageGray=imageGray(t).data;
    inputimageGB=imageGB(t).data;
    [NFD(t).data, FD(t).data] = outlinecatch(inputimageGray);
end
for i=1:size(viewConceptNeuron,2)
    for t=1:size(imageGray,2)
        dis(t)=norm(NFD(t).data(3:25)-outlineConceptNeuron(viewConceptNeuron(i).outline).data);
    end
    [~,index(i)]=min(dis);
end

for i=1:size(associatedNeuron,2)
    subplot(ceil(size(associatedNeuron,2)/10),10,plotindex);
    p=1;
    for j=1:size(associatedNeuron(i).view,2)
        if ~isempty(viewConceptNeuron(associatedNeuron(i).view(j)).color)
            plot(ifft(FD(index(associatedNeuron(i).view(j))).data), 'color', ...
                colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron...
                (associatedNeuron(i).view(j)).color(1)).data,0.05,'RGB'),'linewidth',7);
            p=p+1;
        else
            plot(ifft(FD(index(associatedNeuron(i).view(j))).data), 'color','k','linewidth',7);
            p=p+1;
        end
        str=[];
        name=[];
        if ~isempty(associatedNeuron(i).audition)
            for k=1:size(associatedNeuron(i).audition,2)
                name{k}=findpronunciation(wordConceptNeuron(associatedNeuron(i).audition(k)).order);
            end
            str=unique(name);
            name=[];
            for k=1:size(str,2)
                name=[name ' ' str{k}];
            end
            title(name,'FontSize',7);
        end
    end
    plotindex=plotindex+1;
end
toc;
display('*** show the learning results after AUDITION (audibal+ultrasonic) channel added finish\n');

display('\n*** save learning result...\n');
tic;
save('E:\matlab\CRAET发布\LearningResultAtDiffernetStage\ResultPhase6.mat',...
    'outlineConceptNeuron', 'colorConceptNeuron','syllableConceptNeuron', ...
    'viewConceptNeuron', 'wordConceptNeuron', 'associatedNeuron',...
    'featureNeuronSOMconnection', 'connectionPSA2SAA', 'connectionSAA2HAA',...
    'associatedconnection');
toc;
display('*** save learning result finish\n');
%% CRATE Phase 7
load('E:\matlab\CRAET发布\data\tastedata.mat');
display('\n*** Network has VISION + AUDITION + GUSTATION channel to learn...\n');
tic;
sensefield{3}='taste';
basictastethreshold=0.015;
for t=1:size(tastedata.data,1)
    % vision channel
    inputimageRGB=image(t).data;
    inputimageGray=imageGray(t).data;
    tlabel=label(t);
    % extract outline feature
    [NFD FD bimage] = outlinecatch(inputimageGray);
    outline = outlinefeaturemap (NFD,FD,outlinethreshold,tlabel);
    % extract color feature
    [CH gg image2]=colorhistogram(bimage,containersize,inputimageRGB);  
    [color disLspace disHspace]= colorfeaturemap (CH,colorthreshold,tlabel);
    % construct visual primary concept
    viewPSAsignal.outline = outline;
    viewPSAsignal.color = color;
    viewfiringsigal = OIDSconceptgenerate (viewPSAsignal,'view');
    % gustation channel
    inputtaste=tastedata.data(t,:);
    inputtastefield=tastedata.field;
    tastePSAsignal=basictastefeaturemap(inputtaste,inputtastefield,basictastethreshold);
    tastefiringsigal = OIDSconceptgenerate (tastePSAsignal,'taste');
    % generate input signals to associated areas 
    combinesignals=[];
    combinesignals.view=viewfiringsigal;
    combinesignals.taste=tastefiringsigal;
    % associated
    associatedcortex (combinesignals);
end
toc;
display('*** VISION + AUDITION + GUSTATION channel learning finish');

display('\n*** show the learning results after GUSTATION channel added...\n');
tic;
figure(7);
NFD=[];
FD=[];
k=0;
plotindex=1;
for i=1:size(viewConceptNeuron,2)
    for j=1:size(viewConceptNeuron(i).color,2)
        k=k+1;
    end
end
for t=1:size(imageGray,2)
    inputimageGray=imageGray(t).data;
    inputimageGB=imageGB(t).data;
    [NFD(t).data, FD(t).data] = outlinecatch(inputimageGray);
end
for i=1:size(viewConceptNeuron,2)
    for t=1:size(imageGray,2)
        dis(t)=norm(NFD(t).data(3:25)-outlineConceptNeuron(viewConceptNeuron(i).outline).data);
    end
    [~,index(i)]=min(dis);
end

for i=1:size(associatedNeuron,2)
    subplot(ceil(size(associatedNeuron,2)/10),10,plotindex);
    p=1;
    for j=1:size(associatedNeuron(i).view,2)
        if ~isempty(viewConceptNeuron(associatedNeuron(i).view(j)).color)
            plot(ifft(FD(index(associatedNeuron(i).view(j))).data), 'color', ...
                colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron...
                (associatedNeuron(i).view(j)).color(1)).data,0.05,'RGB'),'linewidth',7);
            p=p+1;
        else
            plot(ifft(FD(index(associatedNeuron(i).view(j))).data), 'color','k','linewidth',7);
            p=p+1;
        end
        str=[];
        name=[];
        if ~isempty(associatedNeuron(i).audition)
            for k=1:size(associatedNeuron(i).audition,2)
                name{k}=findpronunciation(wordConceptNeuron...
                    (associatedNeuron(i).audition(k)).order);
            end
            str=unique(name);
            name=[];
            for k=1:size(str,2)
                name=[name ' ' str{k}];
            end
        end
        tas=[];
        if ~isempty(associatedNeuron(i).taste)
            for k=1:size(associatedNeuron(i).taste,2)
                tas(k,:)=findtaste(associatedNeuron(i).taste(k));
            end
            tas=unique(tas,'rows');
            tas(1,:)=(roundn(tas(1,:),-2));
        end
        str=num2str(i);
        for k=1:size(tas,2)
            str=[str ' ' num2str(tas(1,k))];
        end
        tit{1}=name;
        tit{2}=str;
        title(tit,'FontSize',7);
    end
    plotindex=plotindex+1;
end
toc;
display('*** show the learning results after GUSTATION channel added finish\n');

display('\n*** save learning result...\n');
tic;
save('E:\matlab\CRAET发布\LearningResultAtDiffernetStage\ResultPhase7.mat',...
    'outlineConceptNeuron', 'colorConceptNeuron','syllableConceptNeuron', 'basictasteConceptNeuron', ...
    'viewConceptNeuron', 'wordConceptNeuron', 'tasteConceptNeuron', 'associatedNeuron', ...
    'featureNeuronSOMconnection', 'connectionPSA2SAA', 'connectionSAA2HAA',...
    'associatedconnection');
toc;
display('*** save learning result finish\n');
