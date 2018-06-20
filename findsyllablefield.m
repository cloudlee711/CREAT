function fieldname = findsyllablefield (order)

global voicefield;
global syllableConceptNeuron;

fieldname=[];
num(1)=0;
for i=2:size(voicefield,2)+1
    num(i)=num(i-1)+size(syllableConceptNeuron.(voicefield{i-1}),2);
end
for i=1:size(voicefield,2)
    if num(i)<order&&order<=num(i+1)
        fieldname=voicefield{i};
        break;
    end
end
