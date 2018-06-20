function addnewfeatureConceptNeuron(inutsignals,sensetype)

threshold=3;
global outlineConceptNeuron;
global featureNeuronSOMconnection;

if strcmp(sensetype,'view')
    tem=size(outlineConceptNeuron,2)+1;
    outlineConceptNeuron(tem).data=inutsignals.NFD(3:25);
    outlineConceptNeuron(tem).FD=inutsignals.FD;
    outlineConceptNeuron(tem).threshold=norm(inutsignals.NFD(3:25))/threshold;
    outlineConceptNeuron(tem).activity=1;
    featureNeuronSOMconnection.outline(tem,tem)=0;
end