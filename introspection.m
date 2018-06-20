function introspection(inputsignal, feilds, firingAssociatedNeuron, varargin)

global sensefield;
global associatedNeuron;
global connectionSAA2HAA;
global associatedconnection;
global wordConceptNeuron;
global voicefield;
global featureNeuronSOMconnection;
global syllableConceptNeuron;
strange=0;
UI=varargin{1};
if ~isempty(find(strcmp(feilds,'audition'), 1))
    % exist audition input, attention one word for one concept, so
    % currently only one channel is permitted besides audition channel for
    % conception learning.
    inputname=[];
    syllables=varargin{2}.syllables;
    winnersyllable=varargin{2}.winnersyllable;
    input2show=varargin{3}.input;

    
    for i=1:size(syllables,2)
        inputname=[inputname ' ' syllables(i).label.pronunciation];
    end
    fieldtoName=feilds(find(strcmp(feilds,'audition')==0));
    [~,firingwordindex]=max(inputsignal.audition.data);
    [~,firingtonameindex]=max(inputsignal.(fieldtoName{1}).data);
    if sum(firingAssociatedNeuron.audition(:))~=0
        [~, firingANindexbyword]=max(firingAssociatedNeuron.audition);
    else
        firingANindexbyword=[];
    end
    if sum(firingAssociatedNeuron.(fieldtoName{1})(:))~=0
        [~, firingANindexbytoname]=max(firingAssociatedNeuron.(fieldtoName{1}));
    else
        firingANindexbytoname=[];
    end
    if find(strcmp(feilds,fieldtoName), 1)<find(strcmp(feilds,'audition'), 1)
        flag=1;
    else
        flag=2;
    end
    % condition one, new name and new view (or other sense) to the system
    if isempty(firingANindexbytoname)&&isempty(firingANindexbyword)
        % create a new associated neuron to bind the two concepts
        tem=size(associatedNeuron,2)+1;
        associatedNeuron(tem).(fieldtoName{1})=firingtonameindex;
        associatedNeuron(tem).audition=firingwordindex;
        associatedNeuron(tem).activity=1;
        % update connection 
        % connectionSAA2HAA
        connectionSAA2HAA.audition(firingwordindex,tem)=1;
        connectionSAA2HAA.(fieldtoName{1})(firingtonameindex,tem)=1;
        % associatedconnection
        if flag==1
            associatedconnection(tem).([fieldtoName{1} 'andaudition'])(firingtonameindex,firingwordindex)=1;
        else
            associatedconnection(tem).(['auditionand' fieldtoName{1}])(firingwordindex,firingtonameindex)=1;
        end
    end
    % end of condition one
    % condition two, old name and new view (or other sense) to the system
    if isempty(firingANindexbytoname)&&~isempty(firingANindexbyword) 
        if sum(UI.(['auditioncall' fieldtoName{1}])(:))==0 % no UI to name concept neuron is associated 
            % add this new view to the fired associated neuron directly
            associatedNeuron(firingANindexbyword).(fieldtoName{1})=...
                union(associatedNeuron(firingANindexbyword).(fieldtoName{1}), firingtonameindex);
            % update connections
            connectionSAA2HAA.(fieldtoName{1})(firingtonameindex,firingANindexbyword)=1;
            if flag==1
                associatedconnection(firingANindexbyword).([fieldtoName{1} 'andaudition'])(firingtonameindex, firingwordindex)=1;
            else
                associatedconnection(firingANindexbyword).(['auditionand' fieldtoName{1}])(firingwordindex, firingtonameindex)=1;
            end
        else
            [UI2name,~]=find(UI.(['auditioncall' fieldtoName{1}])==max(UI.(['auditioncall' fieldtoName{1}])(:)));
            if wordConceptNeuron(firingwordindex).check==0 % fired word without check
                question1=['Is it a correct word ' findpronunciation(wordConceptNeuron(firingwordindex).order) ' that I recognize? y/n '];
                answer1=input(question1,'s');
                if answer1=='n' %the word is wrong
                    question2=['Do you mean this concept by what you said? y/n '];
                    showsense(fieldtoName,2,input2show,UI2name);
                    answer2=input(question2,'s');
                    if answer2=='y'
                        % delete wrong word
                        deletewrongword(firingwordindex, fieldtoName, flag);
                        % add this new word
                        addnewword(syllables);
                        % add this word to the fired associated neuron
                        newwordindex=size(wordConceptNeuron,2);
                        associatedNeuron(firingANindexbyword).audition=union(associatedNeuron(firingANindexbyword).audition, newwordindex);
                        associatedNeuron(firingANindexbyword).activity=associatedNeuron(firingANindexbyword).activity+1;
                        % update connection of the new word
                        connectionSAA2HAA.audition(newwordindex, firingANindexbyword)=1;
                        if flag==1
                            associatedconnection(firingANindexbyword).([fieldtoName{1} 'andaudition'])(firingtonameindex, newwordindex)=1;
                        else
                            associatedconnection(firingANindexbyword).(['auditionand' fieldtoName{1}])(newwordindex, firingtonameindex)=1;
                        end
                    else
                        % delete wrong word
                        deletewrongword(firingwordindex, fieldtoName, flag);
                        % add this new word
                        addnewword(syllables);
                        % add new associated neuron to learn this two current input
                        tem=size(associatedNeuron,2)+1;
                        newwordindex=size(wordConceptNeuron,2);
                        associatedNeuron(tem).(fieldtoName{1})=firingtonameindex;
                        associatedNeuron(tem).audition=newwordindex;
                        associatedNeuron(tem).activity=1;
                        % update connection of the new combination
                        connectionSAA2HAA.audition(newwordindex, tem)=1;
                        connectionSAA2HAA.(fieldtoName{1})(firingtonameindex, tem)=1;
                        if flag==1
                            associatedconnection(tem).([fieldtoName{1} 'andaudition'])(firingtonameindex, newwordindex)=1;
                        else
                            associatedconnection(tem).(['auditionand' fieldtoName{1}])(newwordindex, firingtonameindex)=1;
                        end
                    end
                else %the word is correct
                    wordConceptNeuron(firingwordindex).check=1;
                    question2=['Do you mean this concept by what you said [' findpronunciation(wordConceptNeuron(firingwordindex).order) '] ? y/n '];
                    showsense(fieldtoName,2,input2show,UI2name);
                    answer2=input(question2,'s');
                    if answer2=='y'
                        % add this view to the fired associated neuron by audition
                        associatedNeuron(firingANindexbyword).(fieldtoName{1})=...
                            union(associatedNeuron(firingANindexbyword).(fieldtoName{1}), firingtonameindex);
                        % update connections
                        connectionSAA2HAA.(fieldtoName{1})(firingtonameindex,firingANindexbyword)=1;
                        if flag==1
                            associatedconnection(firingANindexbyword).([fieldtoName{1} 'andaudition'])(firingtonameindex, firingwordindex)=1;
                        else
                            associatedconnection(firingANindexbyword).(['auditionand' fieldtoName{1}])(firingwordindex, firingtonameindex)=1;
                        end
                    else
                        % add this new word
                        addnewword(syllables);
                        % add new associated neuron to learn this two current input
                        tem=size(associatedNeuron,2)+1;
                        newwordindex=size(wordConceptNeuron,2);
                        associatedNeuron(tem).(fieldtoName{1})=firingtonameindex;
                        associatedNeuron(tem).audition=newwordindex;
                        associatedNeuron(tem).activity=1;
                        % update connection of the new combination
                        connectionSAA2HAA.audition(newwordindex, tem)=1;
                        connectionSAA2HAA.(fieldtoName{1})(firingtonameindex, tem)=1;
                        if flag==1
                            associatedconnection(tem).([fieldtoName{1} 'andaudition'])(firingtonameindex, newwordindex)=1;
                        else
                            associatedconnection(tem).(['auditionand' fieldtoName{1}])(newwordindex, firingtonameindex)=1;
                        end
                    end
                end
            else % fired word already be checked
                question2=['Do you mean this concept by what you said [' findpronunciation(wordConceptNeuron(firingwordindex).order) '] ? y/n '];
                showsense(fieldtoName,2,input2show,UI2name);
                answer2=input(question2,'s');
                if answer2=='y'
                    % add this view to the fired associated neuron by audition
                    associatedNeuron(firingANindexbyword).(fieldtoName{1})=...
                        union(associatedNeuron(firingANindexbyword).(fieldtoName{1}), firingtonameindex);
                    % update connections
                    connectionSAA2HAA.(fieldtoName{1})(firingtonameindex,firingANindexbyword)=1;
                    if flag==1
                        associatedconnection(firingANindexbyword).([fieldtoName{1} 'andaudition'])(firingtonameindex, firingwordindex)=1;
                    else
                        associatedconnection(firingANindexbyword).(['auditionand' fieldtoName{1}])(firingwordindex, firingtonameindex)=1;
                    end
                else
                    % add this new word
                    addnewword(syllables);
                    % add new associated neuron to learn this two current input
                    tem=size(associatedNeuron,2)+1;
                    newwordindex=size(wordConceptNeuron,2);
                    associatedNeuron(tem).(fieldtoName{1})=firingtonameindex;
                    associatedNeuron(tem).audition=newwordindex;
                    associatedNeuron(tem).activity=1;
                    % update connection of the new combination
                    connectionSAA2HAA.audition(newwordindex, tem)=1;
                    connectionSAA2HAA.(fieldtoName{1})(firingtonameindex, tem)=1;
                    if flag==1
                        associatedconnection(tem).([fieldtoName{1} 'andaudition'])(firingtonameindex, newwordindex)=1;
                    else
                        associatedconnection(tem).(['auditionand' fieldtoName{1}])(newwordindex, firingtonameindex)=1;
                    end
                end
            end
        end
    end
    % end of condition two
    
    % condition three, new name and old view (or other sense) to the system
    if ~isempty(firingANindexbytoname)&&isempty(firingANindexbyword)
        if sum(UI.([fieldtoName{1} 'callaudition'])(:))==0 % no UItoname concept neuron is associated
            question1=['Is Fig.2 right I recognize from current input in' fieldtoName{1} '? y/n '];
            showsense(fieldtoName,3,input2show,firingtonameindex);
            answer1=input(question1,'s');
            if answer1=='y'
                % add the new name to the associated neuron directly
                associatedNeuron(firingANindexbytoname).audition=union(associatedNeuron(firingANindexbytoname).audition, firingwordindex);
                associatedNeuron(firingANindexbytoname).activity=...
                    associatedNeuron(firingANindexbytoname).activity+1;
                % update connections
                connectionSAA2HAA.audition(firingwordindex,firingANindexbytoname)=1;
                if flag==1
                    associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                        (firingtonameindex, firingwordindex)=1;
                else
                    associatedconnection(firingANindexbytoname).(['auditionand' fieldtoName{1}])...
                        (firingwordindex, firingtonameindex)=1;
                end
            else
                % add new associated neuron to learn this two current input
                tem=size(associatedNeuron,2)+1;
                associatedNeuron(tem).(fieldtoName{1})=firingtonameindex;
                associatedNeuron(tem).audition=firingwordindex;
                associatedNeuron(tem).activity=1;
                % update connection connectionSAA2HAA
                connectionSAA2HAA.audition(firingwordindex,tem)=1;
                connectionSAA2HAA.(fieldtoName{1})(firingtonameindex,tem)=1;
                % associatedconnection
                if flag==1
                    associatedconnection(tem).([fieldtoName{1} 'andaudition'])=1;
                else
                    associatedconnection(tem).(['auditionand' fieldtoName{1}])=1;
                end
            end
        else % UItoname concept neuron is associated
            question1=['Is Fig.2 right I recognize from current input in' fieldtoName{1} '? y/n '];
            showsense(fieldtoName,3,input2show,firingtonameindex); 
            answer1=input(question1,'s');
            if answer1=='n'
                % drop the wrong view concept neuron
                deletewrongtonameconcept(firingtonameindex, varargin{3} ,fieldtoName{1});
                % add new outlineConceptNeuron to system
                addnewfeatureConceptNeuron(varargin{3},fieldtoName{1});
                % add new viewConceptNeuron to syste
                addindex=addnewConceptNeuron(varargin{3},fieldtoName{1});
                % add new associated neuron  
                tem=size(associatedNeuron,2)+1;
                associatedNeuron(tem).(fieldtoName{1})=addindex;
                associatedNeuron(tem).audition=firingwordindex;
                associatedNeuron(tem).activity=1;
                % update connection connectionSAA2HAA
                connectionSAA2HAA.audition(firingwordindex,tem)=1;
                connectionSAA2HAA.(fieldtoName{1})(addindex,tem)=1;
                % associatedconnection
                if flag==1
                    associatedconnection(tem).([fieldtoName{1} 'andaudition'])=1;
                else
                    associatedconnection(tem).(['auditionand' fieldtoName{1}])=1;
                end
            else
                [UIword,~]=find(UI.([fieldtoName{1} 'callaudition'])==max(UI.([fieldtoName{1} 'callaudition'])(:)));
                % jugde the word
                % judge the length of the words
                issamelengthword=0;
                existsimilarword=0;
                for j=1:size(UIword,2)
                    if size(wordConceptNeuron(firingwordindex).order,2) == size(wordConceptNeuron(UIword(j)).order,2)
                        issamelengthword=1;
                        break;
                    end
                end
                if issamelengthword
                    % find similar words with UItoname concept neuron
                    UIsimilarwords=[];
                    for j=1:size(UIword,2)
                        if size(wordConceptNeuron(firingwordindex).order,2) == size(wordConceptNeuron(UIword(j)).order,2)
                            tem=similarwords(UIword(j));
                            UIsimilarwords=[UIsimilarwords;tem];
                        end
                    end
                    % find similar words with current input name
                    firingwordsimilarwords=similarwords(firingwordindex);
                    [a, b, c]=intersect(UIsimilarwords,firingwordsimilarwords,'rows');
                    if ~isempty(a)
                        existsimilarword=1;
                    end
                end
                % end of jugde the word
                if issamelengthword==0 % new word
                    tem=unidrnd(size(UIword,2));
                    question2=['The current input in field' fieldtoName{1} ' is called [' ...
                        findpronunciation(wordConceptNeuron(UIword(tem)).order) '] before? y/n '];
                    answer2=input(question2,'s');
                    if answer2=='n'% The current input in field is not called before.
                        %drop this learned UIword(tem)
                        % delete wrong word
                        deletewrongword(UIword(tem), fieldtoName, flag);
                        question3=['Now you call it [' findpronunciation(wordConceptNeuron(firingwordindex).order)  '] ? y/n '];
                        answer3=input(question3,'s');
                        if answer3=='y'
                            % add the new name to the associated neuron directly
                            associatedNeuron(firingANindexbytoname).audition=union(associatedNeuron(firingANindexbytoname).audition, firingwordindex);
                            associatedNeuron(firingANindexbytoname).activity=...
                                associatedNeuron(firingANindexbytoname).activity+1;
                            % update connections
                            connectionSAA2HAA.audition(firingwordindex,firingANindexbytoname)=1;
                            if flag==1
                                associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                                    (firingtonameindex, firingwordindex)=1;
                            else
                                associatedconnection(firingANindexbytoname).(['auditionand' fieldtoName{1}])...
                                    (firingwordindex, firingtonameindex)=1;
                            end
                        else
                            % add new associated neuron to learn this two current input
                            tem=size(associatedNeuron,2)+1;
                            associatedNeuron(tem).(fieldtoName{1})=firingtonameindex;
                            associatedNeuron(tem).audition=firingwordindex;
                            associatedNeuron(tem).activity=1;
                            % update connection connectionSAA2HAA
                            connectionSAA2HAA.audition(firingwordindex,tem)=1;
                            connectionSAA2HAA.(fieldtoName{1})(firingtonameindex,tem)=1;
                            % associatedconnection
                            if flag==1
                                associatedconnection(tem).([fieldtoName{1} 'andaudition'])=1;
                            else
                                associatedconnection(tem).(['auditionand' fieldtoName{1}])=1;
                            end
                        end
                    else
                        question3=['You want to call it another name [' findpronunciation(wordConceptNeuron(firingwordindex).order)  '] ? y/n '];
                        answer3=input(question3,'s');
                        if answer3=='y'
                            % add the new name to the associated neuron directly
                            associatedNeuron(firingANindexbytoname).audition=union(associatedNeuron(firingANindexbytoname).audition, firingwordindex);
                            associatedNeuron(firingANindexbytoname).activity=...
                                associatedNeuron(firingANindexbytoname).activity+1;
                            % update connections
                            connectionSAA2HAA.audition(firingwordindex,firingANindexbytoname)=1;
                            if flag==1
                                associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                                    (firingtonameindex, firingwordindex)=1;
                            else
                                associatedconnection(firingANindexbytoname).(['auditionand' fieldtoName{1}])...
                                    (firingwordindex, firingtonameindex)=1;
                            end
                            wordConceptNeuron(firingwordindex).check=1;
                        else
                            %drop this learned new word
                            deletewrongword(firingwordindex, fieldtoName, flag);
                        end
                    end
                else % issamelengthword=1, the word is same length
                    if existsimilarword % existsimilarword exists
                        % no question, record the accent?
                        % add the new name to the associated neuron directly
                        associatedNeuron(firingANindexbytoname).audition=union(associatedNeuron(firingANindexbytoname).audition, firingwordindex);
                        associatedNeuron(firingANindexbytoname).activity=...
                            associatedNeuron(firingANindexbytoname).activity+1;
                        % update connections
                        connectionSAA2HAA.audition(firingwordindex,firingANindexbytoname)=1;
                        if flag==1
                            associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                                (firingtonameindex, firingwordindex)=1;
                        else
                            associatedconnection(firingANindexbytoname).(['auditionand' fieldtoName{1}])...
                                (firingwordindex, firingtonameindex)=1;
                        end
                    else % existsimilarword does not exist
                        question2 = ['Now you call it as ' findpronunciation(wordConceptNeuron(firingwordindex).order) ...
                            ' a bit different as before, do I remember it? y/n '];
                        answer2=input(question2,'s');
                        if answer2=='y'
                            % add the new name to the associated neuron
                            associatedNeuron(firingANindexbytoname).audition=union(associatedNeuron(firingANindexbytoname).audition, firingwordindex);
                            associatedNeuron(firingANindexbytoname).activity=...
                                associatedNeuron(firingANindexbytoname).activity+1;
                            % update connections
                            connectionSAA2HAA.audition(firingwordindex,firingANindexbytoname)=1;
                            if flag==1
                                associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                                    (firingtonameindex, firingwordindex)=1;
                            else
                                associatedconnection(firingANindexbytoname).(['auditionand' fieldtoName{1}])...
                                    (firingwordindex, firingtonameindex)=1;
                            end
                            wordConceptNeuron(firingwordindex).check=1;
                        else
                            deletewrongword(firingwordindex, fieldtoName, flag);
                        end
                    end
                end
            end
        end
    end
    % end of condition three
    % condition four, old name and old view (or other sense) to the system
    if ~isempty(firingANindexbytoname)&&~isempty(firingANindexbyword)
        if firingANindexbytoname==firingANindexbyword
            %update connection
            if flag==1
                associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                    (firingtonameindex, firingwordindex)=...
                    associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                    (firingtonameindex, firingwordindex)+1;
            else
                associatedconnection(firingANindexbytoname).(['auditionand' fieldtoName{1}])...
                    (firingtonameindex, firingwordindex)=...
                    associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                    (firingtonameindex, firingwordindex)+1;
            end
            associatedNeuron(firingANindexbytoname).activity=...
                associatedNeuron(firingANindexbytoname).activity+1;
        else
            condition1=sum(UI.(['auditioncall' fieldtoName{1}])(:))==0; % no UIAcall concept neuron is associated
            condition2=sum(UI.([fieldtoName{1} 'callaudition'])(:))==0; % no UIFcall concept neuron is associated
            if condition1&&condition2 % does this condition exist?
                % current input name does not have view (or other sense) associated,
                % current input view (or other sense) does not have name
            end
            if condition1&&~condition2 % does this condition exist?
                % current input view (or other sense) has name,
                % current input name does not have view (or other sense) associated
                
            end
            if ~condition1&&condition2
                % current input name has view (or other sense) associated,
                % current input view (or other sense) does not have name
                
                
            end
            if ~condition1&&~condition2
                % current input name has view (or other sense) associated,
                % current input view (or other sense) has name
                question1=['Is it a correct word ' ...
                    findpronunciation(wordConceptNeuron(firingwordindex).order) ' that I recognize? y/n '];
                answer1=input(question1,'s');
                if answer1=='n'
                    deletewrongword(firingwordindex, fieldtoName, flag);
                else
                    question2=['I have a problem, tell me which fig is right or both or none. Type 2/3/b/n. '];
                    showsense(fieldtoName,4,input2show,firingtonameindex,UI);
                    answer2=input(question2,'s');
                    if answer2=='2' % enhance 2 and drop 3
                        associatedNeuron(firingANindexbytoname).audition=union(associatedNeuron(firingANindexbytoname).audition, firingwordindex);
                        associatedNeuron(firingANindexbytoname).activity=...
                            associatedNeuron(firingANindexbytoname).activity+1;
                        % update connections
                        connectionSAA2HAA.audition(firingwordindex,firingANindexbytoname)=1;
                        if flag==1
                            associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                                (firingtonameindex, firingwordindex)=1;
                        else
                            associatedconnection(firingANindexbytoname).(['auditionand' fieldtoName{1}])...
                                (firingwordindex, firingtonameindex)=1;
                        end
                        deletewrongword(firingwordindex, fieldtoName, flag);
                    end
                    if answer2=='3' % enhance 3 and drop 2
                        associatedNeuron(firingANindexbyword).(fieldtoName{1})=...
                            union(associatedNeuron(firingANindexbyword).(fieldtoName{1}), firingtonameindex);
                        % update connections
                        connectionSAA2HAA.(fieldtoName{1})(firingtonameindex,firingANindexbyword)=1;
                        if flag==1
                            associatedconnection(firingANindexbyword).([fieldtoName{1} 'andaudition'])(firingtonameindex, firingwordindex)=1;
                        else
                            associatedconnection(firingANindexbyword).(['auditionand' fieldtoName{1}])(firingwordindex, firingtonameindex)=1;
                        end
                        % drop the wrong view concept neuron
                        deletewrongtonameconcept(firingtonameindex, varargin{3} ,fieldtoName{1});
                    end
                    if answer2=='b' % enhance both
                        associatedNeuron(firingANindexbytoname).audition=union(associatedNeuron(firingANindexbytoname).audition, firingwordindex);
                        associatedNeuron(firingANindexbytoname).activity=...
                            associatedNeuron(firingANindexbytoname).activity+1;
                        % update connections
                        connectionSAA2HAA.audition(firingwordindex,firingANindexbytoname)=1;
                        if flag==1
                            associatedconnection(firingANindexbytoname).([fieldtoName{1} 'andaudition'])...
                                (firingtonameindex, firingwordindex)=1;
                        else
                            associatedconnection(firingANindexbytoname).(['auditionand' fieldtoName{1}])...
                                (firingwordindex, firingtonameindex)=1;
                        end
                        associatedNeuron(firingANindexbyword).(fieldtoName{1})=...
                            union(associatedNeuron(firingANindexbyword).(fieldtoName{1}), firingtonameindex);
                        % update connections
                        connectionSAA2HAA.(fieldtoName{1})(firingtonameindex,firingANindexbyword)=1;
                        if flag==1
                            associatedconnection(firingANindexbyword).([fieldtoName{1} 'andaudition'])(firingtonameindex, firingwordindex)=1;
                        else
                            associatedconnection(firingANindexbyword).(['auditionand' fieldtoName{1}])(firingwordindex, firingtonameindex)=1;
                        end
                    end
                    
                    if answer2=='n' %drop this learning result
                        deletewrongword(firingwordindex, fieldtoName, flag);
                        deletewrongtonameconcept(firingtonameindex, varargin{3} ,fieldtoName{1});
                    end
                end
            end
        end
    end
    % end of condition four
else % begin of no audition input
    % no audition input, no channel limit.
    
end


