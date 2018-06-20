function deletewrongtonameconcept (firingtonameindex, data, sensetype)

global connectionPSA2SAA;
global viewConceptNeuron;

if strcmp(sensetype, 'view')
    [~, color]=max(data.color);
    viewConceptNeuron(firingtonameindex).color=setdiff(viewConceptNeuron(firingtonameindex).color,color);
    connectionPSA2SAA.color2view(color, firingtonameindex)=0;
end
