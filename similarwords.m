function similarword = similarwords (wordindex)

global wordConceptNeuron;
global featureNeuronSOMconnection;

similarsyllable=[];
for i=1:size(wordConceptNeuron(wordindex).order,2)
    % find syllable field e.g., audible or ultrasonic
    tem=wordConceptNeuron(wordindex).order(i);    
    fieldname=findsyllablefield(tem);
    similarsyllable(i).data=find(featureNeuronSOMconnection.(fieldname)(tem,:)~=0);
    similarsyllable(i).data=[similarsyllable(i).data tem];
end
similarword=similarsyllable(1).data';
similarsyllable(1)=[];
similarword=getsimilarword(similarword, similarsyllable);