function [firingSyllables winnersyllable] = syllablefeaturemap (syllables,syllablethreshold)

% global syllableConceptNeuronAudible;
% global syllableConceptNeuronUltrasonic;
global voicefield;
global syllableConceptNeuron;
global featureNeuronSOMconnection;
firingSyllables=[];
delta=2;
winnersyllable=[];
if isempty(syllableConceptNeuron)
    for i=1:size(syllables,2)
        index=strmatch(syllables(i).voicetype,voicefield)-1;
        num=0;
        if index>0
            for j=1:index
                num=num+size(syllableConceptNeuron.(voicefield{j}),2);
            end
        end
        if ~isfield(syllableConceptNeuron,syllables(i).voicetype)
            voicefield=[voicefield syllables(i).voicetype];
            syllableConceptNeuron.(syllables(i).voicetype)(1).data=syllables(i).data;
            syllableConceptNeuron.(syllables(i).voicetype)(1).feature=syllables(i).feature;
            syllableConceptNeuron.(syllables(i).voicetype)(1).label=syllables(i).label;
            syllableConceptNeuron.(syllables(i).voicetype)(1).fs=syllables(i).fs;
            syllableConceptNeuron.(syllables(i).voicetype)(1).activity=1;
            featureNeuronSOMconnection.(syllables(i).voicetype)(1,1)=0;
            num=num+1;
            firingSyllables.data(i,num)=1;
            firingSyllables.type(i).data=syllables(i).voicetype;
            firingSyllables.type(i).newadd=1;
        else
            length=size(syllableConceptNeuron.(syllables(i).voicetype),2)+1;
            syllableConceptNeuron.(syllables(i).voicetype)(length).data=syllables(i).data;
            syllableConceptNeuron.(syllables(i).voicetype)(length).feature=syllables(i).feature;
            syllableConceptNeuron.(syllables(i).voicetype)(length).label=syllables(i).label;
            syllableConceptNeuron.(syllables(i).voicetype)(length).fs=syllables(i).fs;
            syllableConceptNeuron.(syllables(i).voicetype)(length).activity=1;
            featureNeuronSOMconnection.(syllables(i).voicetype)(length,length)=0;
            num=num+length;
            firingSyllables.data(i,num)=1;
            firingSyllables.type(i).data=syllables(i).voicetype;
            firingSyllables.type(i).newadd=1;
        end
    end
else
    dist=[];
    for i=1:size(syllables,2)
        if ~isfield(syllableConceptNeuron,syllables(i).voicetype)
            voicefield=[voicefield syllables(i).voicetype];
            syllableConceptNeuron.(syllables(i).voicetype)(1).data=syllables(i).data;
            syllableConceptNeuron.(syllables(i).voicetype)(1).feature=syllables(i).feature;
            syllableConceptNeuron.(syllables(i).voicetype)(1).label=syllables(i).label;
            syllableConceptNeuron.(syllables(i).voicetype)(1).fs=syllables(i).fs;
            syllableConceptNeuron.(syllables(i).voicetype)(1).activity=1;
            index=strmatch(syllables(i).voicetype,voicefield)-1;
            num=0;
            for j=1:index
                num=num+size(syllableConceptNeuron.(voicefield{j}),2);
            end
            num=num+1;
            firingSyllables.data(i,num)=1;
            firingSyllables.type(i).data=syllables(i).voicetype;
            firingSyllables.type(i).newadd=1;
        else
            
            for j=1:size(syllableConceptNeuron.(syllables(i).voicetype),2)
                [dist(i).data(j)]=dtw(syllables(i).feature,syllableConceptNeuron.(syllables(i).voicetype)(j).feature);
            end
            % [a b]=min(dist(i,:));
            [value, position] = sort(dist(i).data);
            index=strmatch(syllables(i).voicetype,voicefield)-1;
            num=0;
            for j=1:index
                num=num+size(syllableConceptNeuron.(voicefield{j}),2);
            end
            position=position+num;
            winnersyllable(i)=position(1);
            if value(1)>syllablethreshold.(syllables(i).voicetype)
                length=size(syllableConceptNeuron.(syllables(i).voicetype),2)+1;
                syllableConceptNeuron.(syllables(i).voicetype)(length).data=syllables(i).data;
                syllableConceptNeuron.(syllables(i).voicetype)(length).feature=syllables(i).feature;
                syllableConceptNeuron.(syllables(i).voicetype)(length).label=syllables(i).label;
                syllableConceptNeuron.(syllables(i).voicetype)(length).activity=1;
                syllableConceptNeuron.(syllables(i).voicetype)(length).fs=syllables(i).fs;
                tem=num+length;
                featureNeuronSOMconnection.(syllables(i).voicetype)(tem,tem)=0;
                firingSyllables.data(i,tem)=1;
                firingSyllables.type(i).data=syllables(i).voicetype;
                firingSyllables.type(i).newadd=1;
                % add firingSyllables after this type of sound
                for k=1:i-1
                    indexk=strmatch(syllables(k).voicetype,voicefield)-1;
                    if indexk>index
                        [~,indextem]=find(firingSyllables.data(k,:)==1);
                        firingSyllables.data(k,indextem)=0;
                        firingSyllables.data(k,indextem+1)=1;
                    end
                end
                if value(1)<delta*syllablethreshold.(syllables(i).voicetype)
                    featureNeuronSOMconnection.(syllables(i).voicetype)(position(1),tem)=1;
                    featureNeuronSOMconnection.(syllables(i).voicetype)(tem,position(1))=1;
                end
            else
                firingSyllables.data(i,position(1))=1;
                firingSyllables.type(i).data=syllables(i).voicetype;
                firingSyllables.type(i).newadd=0;
                syllableConceptNeuron.(syllables(i).voicetype)(position(1)-num).activity=...
                    syllableConceptNeuron.(syllables(i).voicetype)(position(1)-num).activity+1;
                % update connection
                %[~, index] = sort(dist(i,:));
            end
            for k=2:size(position,2)
                if dist(i).data(position(k)-num)<delta*syllablethreshold.(syllables(i).voicetype)
                    featureNeuronSOMconnection.(syllables(i).voicetype)(position(1),position(k))=1;
                    featureNeuronSOMconnection.(syllables(i).voicetype)(position(k),position(1))=1;
                end
            end
        end
    end
    % completion firingSyllables
    num=0;
    for i=1:size(voicefield,2)
        num=num+size(syllableConceptNeuron.(voicefield{i}),2);
    end
    if size(firingSyllables.data,2)<num
        firingSyllables.data(:,num)=0;
    end
end
