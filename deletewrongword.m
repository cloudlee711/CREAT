function deletewrongword (firingwordindex, fieldtoName, flag)

global wordConceptNeuron;
global associatedNeuron;
global connectionSAA2HAA;
global associatedconnection;
global connectionPSA2SAA
firingwordindex
wordConceptNeuron(firingwordindex)=[];
if size(connectionSAA2HAA.audition,1)>=firingwordindex
    connectionSAA2HAA.audition(firingwordindex,:)=[];
end
connectionPSA2SAA.syllable2word(:,firingwordindex)=[];
connectionPSA2SAA.syllable2wordact(:,firingwordindex)=[];

for i=1:size(associatedNeuron,2)
    associatedNeuron(i).audition=setdiff(associatedNeuron(i).audition,firingwordindex); 
    associatedNeuron(i).audition(find(associatedNeuron(i).audition>firingwordindex))=...
        associatedNeuron(i).audition(find(associatedNeuron(i).audition>firingwordindex))-1;
end



if flag==1
    for i=1:size(associatedconnection,2)
        if size(associatedconnection(i).([fieldtoName{1} 'andaudition']),2)>firingwordindex
            associatedconnection(i).([fieldtoName{1} 'andaudition'])(:,firingwordindex)=[];
        end
    end
else
    for i=1:size(associatedconnection,2)
        if size(associatedconnection(i).(['auditionand' fieldtoName{1}]),1)>firingwordindex
            associatedconnection(i).(['auditionand' fieldtoName{1}])(firingwordindex,:)=[];
        end
    end
end



