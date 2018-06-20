function addnewword (syllables)

global connectionSAA2HAA;
global wordConceptNeuron;
global featureNeuronSOMconnection;
global syllableConceptNeuron;

% update syllableConceptNeuron
for i=1:size(syllables,2)
    num(i)=size(syllableConceptNeuron.(syllables(i).voicetype),2)+1;
    syllableConceptNeuron.(syllables(i).voicetype)(num(i)).data=syllables(i).data;
    syllableConceptNeuron.(syllables(i).voicetype)(num(i)).feature=syllables(i).feature;
    syllableConceptNeuron.(syllables(i).voicetype)(num(i)).label=syllables(i).label;
    syllableConceptNeuron.(syllables(i).voicetype)(num(i)).fs=syllables(i).fs;
    syllableConceptNeuron.(syllables(i).voicetype)(num(i)).activity=1;
    featureNeuronSOMconnection.(syllables(i).voicetype)(num(i),num(i))=0;
end

% update wordConceptNeuron
tem=size(wordConceptNeuron,2)+1;
wordConceptNeuron(tem).order=num;
wordConceptNeuron(tem).activity=1;
wordConceptNeuron(tem).check=1;

% update connectionSAA2HAA
connectionSAA2HAA.audition(num,tem)=1;