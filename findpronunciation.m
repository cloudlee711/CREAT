function name = findpronunciation (order)

global voicefield;
global syllableConceptNeuron;

name=[];
num(1)=0;
for i=2:size(voicefield,2)+1
    num(i)=num(i-1)+size(syllableConceptNeuron.(voicefield{i-1}),2);
end
for i=1:size(order,2)
    for j=1:size(voicefield,2)
        if num(j)<order(i)&&order(i)<=num(j+1)
            index=order(i)-num(j);
            name=[name syllableConceptNeuron.(voicefield{j})(index).label.pronunciation];
            break;
        end
    end
end