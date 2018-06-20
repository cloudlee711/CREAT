function firingNeuron = basictastefeaturemap(inputtaste, inputtastefield, basictastethreshold)

global basictasteConceptNeuron;
global basictastefield;
global featureNeuronSOMconnection;
agedead=25;
delta=2;
for i=1:size(inputtastefield,2)
    if ~isfield(basictasteConceptNeuron, inputtastefield{i})
        basictasteConceptNeuron.(inputtastefield{i})(1).data=inputtaste(i);
        basictasteConceptNeuron.(inputtastefield{i})(1).activity=1;
        basictastefield=[basictastefield, inputtastefield{i}];
        featureNeuronSOMconnection.(inputtastefield{i})=0;
        firingNeuron.(inputtastefield{i})=1;
    else
        dis=[];
        for j=1:size(basictasteConceptNeuron.(inputtastefield{i}),2)
            dis(j)=norm(inputtaste(i)-basictasteConceptNeuron.(inputtastefield{i})(j).data);        
        end
        [val, ind]=sort(dis);
        if val(1)>basictastethreshold
            tem=size(basictasteConceptNeuron.(inputtastefield{i}),2)+1;
            basictasteConceptNeuron.(inputtastefield{i})(tem).data=inputtaste(i);
            basictasteConceptNeuron.(inputtastefield{i})(tem).activity=1;
            featureNeuronSOMconnection.(inputtastefield{i})(tem,tem)=0;
            firingNeuron.(inputtastefield{i})(tem)=1;
        else
            basictasteConceptNeuron.(inputtastefield{i})(ind(1)).activity=...
                basictasteConceptNeuron.(inputtastefield{i})(ind(1)).activity+1;
            basictasteConceptNeuron.(inputtastefield{i})(ind(1)).data=...
                basictasteConceptNeuron.(inputtastefield{i})(ind(1)).data+...
                (inputtaste(i)-basictasteConceptNeuron.(inputtastefield{i})(ind(1)).data)/...
                basictasteConceptNeuron.(inputtastefield{i})(ind(1)).activity;
            tem=size(basictasteConceptNeuron.(inputtastefield{i}),2);
            firingNeuron.(inputtastefield{i})(tem)=0;
            firingNeuron.(inputtastefield{i})(ind(1))=1;
            [~,col]=find(featureNeuronSOMconnection.(inputtastefield{i})(ind(1),:)~=0);
            featureNeuronSOMconnection.(inputtastefield{i})(ind(1),col)=...
                featureNeuronSOMconnection.(inputtastefield{i})(ind(1),col)+1;
            featureNeuronSOMconnection.(inputtastefield{i})(col,ind(1))=...
                featureNeuronSOMconnection.(inputtastefield{i})(col,ind(1))+1;
            for k=1:size(basictasteConceptNeuron.(inputtastefield{i}),2)
                if dis(k)<delta*basictastethreshold && k~=ind(1)
                    featureNeuronSOMconnection.(inputtastefield{i})(ind(1),k)=1;
                    featureNeuronSOMconnection.(inputtastefield{i})(k,ind(1))=1;
                end
            end
            locate=find(featureNeuronSOMconnection.(inputtastefield{i})(ind(1),:)>agedead);
            featureNeuronSOMconnection.(inputtastefield{i})(ind(1),locate)=0;
            featureNeuronSOMconnection.(inputtastefield{i})(locate,ind(1))=0;
        end
    end
end




