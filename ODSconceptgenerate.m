function wordfiringsignal = ODSconceptgenerate (firingSyllables, type)

global wordConceptNeuron;
global connectionPSA2SAA;
global voicefield;
if strcmp(type,'audition')
    wordfiringsignal=[];
    order=[];
    firingtransmit=zeros(1,size(firingSyllables.data,2));
    firingact=zeros(1,size(firingSyllables.data,2));
    for i=1:size(firingSyllables.data,1)
        order(i)=find(firingSyllables.data(i,:)==1);
        firingtransmit(1,order(i))=1;
        firingact(order(i))=firingact(order(i))+1;
    end
    if size(wordConceptNeuron,2)==0
        wordConceptNeuron(1).order=order;
        wordConceptNeuron(1).activity=1;
        wordConceptNeuron(1).check=0;
        connectionPSA2SAA.syllable2word=firingtransmit';
        connectionPSA2SAA.syllable2wordact=firingact';
        wordfiringsignal.data=1;
        wordfiringsignal.tag='word';
    else
        if size(firingSyllables.data,2)>size(connectionPSA2SAA.syllable2word,1)
            tem1=size(firingSyllables.data,2);
            tem2=size(wordConceptNeuron,2)+1;
            wordConceptNeuron(tem2).order=order;
            wordConceptNeuron(tem2).activity=1;
            wordConceptNeuron(tem2).check=0;
            % update the connection
            connectionPSA2SAA.syllable2word(:,tem2)=0;
            connectionPSA2SAA.syllable2wordact(:,tem2)=0;
            for i=1:size(firingSyllables.data,1)
                index=find(firingSyllables.data(i,:)~=0);
                if firingSyllables.type(i).newadd  
                    insert=zeros(1,tem2);
                    insert(tem2)=1;
                    connectionPSA2SAA.syllable2word=[connectionPSA2SAA.syllable2word(1:index-1,:); ...
                       insert ;connectionPSA2SAA.syllable2word(index:end,:)];
                   connectionPSA2SAA.syllable2wordact=[connectionPSA2SAA.syllable2wordact(1:index-1,:); ...
                       insert ;connectionPSA2SAA.syllable2wordact(index:end,:)];
                   for j=1:size(wordConceptNeuron,2)-1
                       for k=1:size(wordConceptNeuron(j).order,2)
                           if wordConceptNeuron(j).order(k)>=index
                               wordConceptNeuron(j).order(k)=wordConceptNeuron(j).order(k)+1;
                           end
                       end
                   end
                else
                    connectionPSA2SAA.syllable2word(index,tem2)=1;
                    connectionPSA2SAA.syllable2wordact(index,tem2)=1;
                end
            end
%             connectionPSA2SAA.syllable2word(tem1,tem2)=0;
%             connectionPSA2SAA.syllable2word(:,tem2)=firingtransmit';
%             connectionPSA2SAA.syllable2wordact(tem1,tem2)=0;
%             connectionPSA2SAA.syllable2wordact(:,tem2)=firingact';
            wordfiringsignal.data(tem2)=1;
            wordfiringsignal.tag='word';
        else
            %using neuron thread to improve this part
            firing=firingword(firingSyllables,wordConceptNeuron,connectionPSA2SAA.syllable2word);
            if firing
                wordConceptNeuron(firing).activity=wordConceptNeuron(firing).activity+1;
                connectionPSA2SAA.syllable2wordact(find(connectionPSA2SAA.syllable2wordact(:,firing)~=0))+1;
                tem1=size(wordConceptNeuron,2);
                wordfiringsignal.data(tem1)=0;
                wordfiringsignal.data(firing)=1;
                wordfiringsignal.tag='word';
            else
                tem1=size(firingSyllables.data,1);
                tem2=size(wordConceptNeuron,2)+1;
                wordConceptNeuron(tem2).order=order;
                wordConceptNeuron(tem2).activity=1;
                wordConceptNeuron(tem2).check=0;
                % update the connection
                connectionPSA2SAA.syllable2word(:,tem2)=0;
                connectionPSA2SAA.syllable2wordact(:,tem2)=0;
                for i=1:size(firingSyllables.data,1)
                    index=find(firingSyllables.data(i,:)~=0);
                    if firingSyllables.type(i).newadd
                        insert=zeros(1,tem2);
                        insert(tem2)=1;
                        connectionPSA2SAA.syllable2word=[connectionPSA2SAA.syllable2word(1:index-1,:); ...
                            insert ;connectionPSA2SAA.syllable2word(index:end,:)];
                        connectionPSA2SAA.syllable2wordact=[connectionPSA2SAA.syllable2wordact(1:index-1,:); ...
                            insert ;connectionPSA2SAA.syllable2wordact(index:end,:)];
                        for j=1:size(wordConceptNeuron,2)-1
                            for k=1:size(wordConceptNeuron(j).order,2)
                                if wordConceptNeuron(j).order(k)>=index
                                    wordConceptNeuron(j).order(k)=wordConceptNeuron(j).order(k)+1;
                                end
                            end
                        end
                    else
                        connectionPSA2SAA.syllable2word(index,tem2)=1;
                        connectionPSA2SAA.syllable2wordact(index,tem2)=1;
                    end
                end
%                 connectionPSA2SAA.syllable2word(tem1,tem2)=0;
%                 connectionPSA2SAA.syllable2word(:,tem2)=firingtransmit';
%                 connectionPSA2SAA.syllable2wordact(tem1,tem2)=0;
%                 connectionPSA2SAA.syllable2wordact(:,tem2)=firingact';
                wordfiringsignal.data(tem2)=1;
                wordfiringsignal.tag='word';
            end
        end
    end
end