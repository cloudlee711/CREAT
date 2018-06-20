function associatedcortex(inputsignal, varargin)

global sensefield;
global associatedNeuron;
global connectionSAA2HAA;
global associatedconnection;


feilds=fieldnames(inputsignal);
% initialization
if isempty(associatedNeuron)
    for i=1:size(feilds,1)
        [~,index]=max(inputsignal.(feilds{i}).data);
        num=size(inputsignal.(feilds{i}).data,2);
        associatedNeuron(1).(feilds{i})=index;
        associatedNeuron(1).activity=1;   
        connectionSAA2HAA.(feilds{i})(num,1)=0;
        connectionSAA2HAA.(feilds{i})(index,1)=1;
    end
    for i=1:size(feilds,1)-1
        for j=i+1:size(feilds,1)
            associatedconnection(1).([feilds{i} 'and' feilds{j}])=1;
        end
    end
else
    existfields=fieldnames(associatedNeuron);
    existfields(find(strcmp(existfields,'activity')==1))=[];
    diffields=setdiff(feilds,existfields);
    if ~isempty(diffields)
        % add this new area to the associatedNeuron
        for i=1:size(diffields,1)
            associatedNeuron(1).(diffields{i})=[];
            connectionSAA2HAA.(diffields{i})=[];
            for j=1:size(existfields,1)
                associatedconnection(1).([existfields{j} 'and' diffields{i}])=[];
            end
        end
    end
    
    
    % firing associatedNeuron
    for i=1:size(feilds,1)
        if size(inputsignal.(feilds{i}).data,2)>size(connectionSAA2HAA.(feilds{i}),1) % channel has a new thing
            firingAssociatedNeuron.(feilds{i})=[];
        else
            firingAssociatedNeuron.(feilds{i})=inputsignal.(feilds{i}).data*connectionSAA2HAA.(feilds{i}); % 1 x n vector, n means n associated neurons
        end
    end
    
%     % connect without UI, for test
%     associate (inputsignal, feilds, firingAssociatedNeuron)

    % unconscious impulse process
    for i=1:size(feilds,1)
        for j=1:size(sensefield,2)
            if ~strcmp(feilds{i},sensefield{j})
                UI.([feilds{i} 'call' sensefield{j}]) = unconsciousimpulse(firingAssociatedNeuron.(feilds{i}),connectionSAA2HAA.(sensefield{j})); 
                % m x n matrix, n means n associated neurons, m means m primary concept neurons.
            end
        end
    end
    % introspection process
    if ~isempty(find(strcmp(feilds,'audition'), 1))
        % get current$sense$ information, first varargin is audition, sencond is toname
        currentaudition=varargin{1};
        currenttoname=varargin{2};
        % introspection process with audition
        introspection(inputsignal, feilds, firingAssociatedNeuron, UI, currentaudition, currenttoname);
    else
        % introspection process without audition
        % introspection(inputsignal, feilds, firingAssociatedNeuron, UI, syllables, inputimageRGB);
        associate (inputsignal, feilds, firingAssociatedNeuron);
    end
    close(figure(8));
end


