function associate (inputsignal, feilds, firingAssociatedNeuron)

global associatedNeuron;
global connectionSAA2HAA;
global associatedconnection;

% find firingAssociatedNeuron set
firingANset=[];

for i=1:size(feilds,1)
    [~,firingCN(i)]=max(inputsignal.(feilds{i}).data);
    if ~isempty(firingAssociatedNeuron.(feilds{i}))&&(sum(firingAssociatedNeuron.(feilds{i}))~=0)
        %[~,tem]=max(firingAssociatedNeuron.(feilds{i}));
        tem=find(firingAssociatedNeuron.(feilds{i})==max(firingAssociatedNeuron.(feilds{i})));
        firingAN.(feilds{i})=tem;
        firingANset=union(firingANset,tem(1,:));
    else
        firingAN.(feilds{i})=[];
    end
end

if isempty(firingANset) % no firing Associated Neuron 
    % new Associated Neuron to combine the input signals
    tem=size(associatedNeuron,2)+1;
    for i=1:size(feilds,1)
        num=size(inputsignal.(feilds{i}).data,2);
        associatedNeuron(tem).(feilds{i})=firingCN(i);
        associatedNeuron(tem).activity=1;
        connectionSAA2HAA.(feilds{i})(num,tem)=0;
        connectionSAA2HAA.(feilds{i})(firingCN(i),tem)=1;
    end
    for i=1:size(feilds,1)-1
        for j=i+1:size(feilds,1)
            associatedconnection(tem).([feilds{i} 'and' feilds{j}])(firingCN(i),firingCN(j))=1;
        end
    end
else
    if size(firingANset,2)==1 % all senses fire one Associated Neuron 
        % enhance the combination 
        associatedNeuron(firingANset).activity=associatedNeuron(firingANset).activity+1;
        for i=1:size(feilds,1)
            if isempty(firingAssociatedNeuron.(feilds{i}))
                tem=size(associatedNeuron,2);
                associatedNeuron(firingANset).(feilds{i})=union(associatedNeuron(firingANset).(feilds{i}), firingCN(i));
                connectionSAA2HAA.(feilds{i})(1,tem)=0;
                connectionSAA2HAA.(feilds{i})(firingCN(i),firingANset)=1;
            end
        end
        for i=1:size(feilds,1)-1
            for j=i+1:size(feilds,1)
                if isfield(associatedconnection,[feilds{i} 'and' feilds{j}])
                    condition1=size(associatedconnection(firingANset).([feilds{i} 'and' feilds{j}]),1)<firingCN(i);
                    condition2=size(associatedconnection(firingANset).([feilds{i} 'and' feilds{j}]),2)<firingCN(j);
                    if condition1||condition2
                        associatedconnection(firingANset).([feilds{i} 'and' feilds{j}])(firingCN(i),firingCN(j))=1;
                    else
                        associatedconnection(firingANset).([feilds{i} 'and' feilds{j}])(firingCN(i),firingCN(j))=...
                            associatedconnection(firingANset).([feilds{i} 'and' feilds{j}])(firingCN(i),firingCN(j))+1;
                    end
                else
                    associatedconnection(firingANset).([feilds{i} 'and' feilds{j}])(firingCN(i),firingCN(j))=1;
                end
            end
        end
    else % senses fire different Associated Neurons 
       % add the Concept Neurons to all the fired different Associated Neurons 
       for i=1:size(feilds,1)
           if ~isempty(firingAN.(feilds{i}))
               for j=1:size(feilds,1)
                   if i~=j%&&i<j                      
                       for k=1:size(firingAN.(feilds{i}),2)
                           associatedNeuron(firingAN.(feilds{i})(k)).(feilds{j})=...
                               union(associatedNeuron(firingAN.(feilds{i})(k)).(feilds{j}),firingCN(j));
                           associatedNeuron(firingAN.(feilds{i})(k)).activity=...
                               associatedNeuron(firingAN.(feilds{i})(k)).activity+1;
                           
                           connectionSAA2HAA.(feilds{j})(firingCN(j),firingAN.(feilds{i})(k))=1; % added on 2017-7-24
                           if i<j
                               associatedconnection(firingAN.(feilds{i})(k)).([feilds{i} 'and' feilds{j}])...
                                   (firingCN(i),firingCN(j))=1;
                               associatedconnection(firingAN.(feilds{i})(k)).([feilds{i} 'and' feilds{j}])...
                                   (firingCN(j),firingCN(i))=1;
                           end
                       end
                   end
               end
           end
       end
    end
end

