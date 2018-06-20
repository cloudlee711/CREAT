function tastedata = findtaste( tasteCNind )
global basictasteConceptNeuron;
global tasteConceptNeuron;

a=tasteConceptNeuron(tasteCNind);
fileds=fieldnames(basictasteConceptNeuron);
for i=1:size(fileds,1)
    tastedata(i)=basictasteConceptNeuron.(fileds{i})(a.(fileds{i})).data;
end