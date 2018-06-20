function addindex = addnewConceptNeuron(inutsignals,sensetype)

global outlineConceptNeuron;
global viewConceptNeuron;
global connectionPSA2SAA;

if strcmp(sensetype,'view')
    tem1=size(outlineConceptNeuron,2);
    addindex=size(viewConceptNeuron,2)+1;
    viewConceptNeuron(addindex).outline=tem1;
    [~,colorindex]=max(inutsignals.color);
    viewConceptNeuron(addindex).color=colorindex;
    viewConceptNeuron(addindex).activity=1;
    viewConceptNeuron(addindex).area='outline';
    connectionPSA2SAA.outline2view(tem1,addindex)=1;
    connectionPSA2SAA.color2view(colorindex,addindex)=1;
end