function num = findsyllableindex (syllable)

global voicefield;
global syllableConceptNeuron;

index=strmatch(syllable.voicetype,voicefield)-1;
num=0;
if index>0
    for j=1:index
        num=num+size(syllableConceptNeuron.(voicefield{j}),2);
    end
end
num=num+1;