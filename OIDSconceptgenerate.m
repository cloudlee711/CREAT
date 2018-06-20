function varargout = OIDSconceptgenerate (varargin)

global viewConceptNeuron;
global tasteConceptNeuron;
global connectionPSA2SAA;

if nargin~=2
    error('OIDSconceptgenerate needs 2 input');
end
% get the input signal
inputsignal=varargin{1};

% get the areas of the signal
field=fieldnames(varargin{1});
fieldnum=size(field,1);
PSAfiring=[];
for i=1:fieldnum
    str(i).data=strcat(field{i},'2',varargin{2});
    [~,PSAfiring(i)]=max(varargin{1}.(field{i}));
end

if strcmp(varargin{2},'view')
    if isempty(viewConceptNeuron)
        viewConceptNeuron(1).outline=1;
        viewConceptNeuron(1).activity=1;
        viewConceptNeuron(1).area='outline';
        connectionPSA2SAA.outline2view=1;
        varargout{1}.data=1;
        varargout{1}.tag='view';
    else
        % calculate firing OID neurons by signal transmitted from each feature areas
        SAAfiring=[];
        for i=1:fieldnum
            if size(connectionPSA2SAA.(str(i).data),1)<size(varargin{1}.(field{i}),2)
                SAAfiring.(field{i})=size(varargin{1}.(field{i}),2);
            else
                [~, index] = max((varargin{1}.(field{i}))*connectionPSA2SAA.(str(i).data));
                SAAfiring.(field{i})=index;
            end
        end
        % update OIDSconcept according to the firing signals of each feature areas
        % now use shape centered coding strategy, in the future can add
        % other decisive feature e.g., texture etc.
        if SAAfiring.outline>size(viewConceptNeuron,2)
            tem=size(viewConceptNeuron,2)+1;
            SAAsignal(tem)=1;
            viewConceptNeuron(tem).outline=SAAfiring.outline;
            viewConceptNeuron(tem).activity=1;
            viewConceptNeuron(tem).area='outline';
            connectionPSA2SAA.outline2view(SAAfiring.outline,tem)=1;
            % update other feature areas
            if fieldnum>=2
                for i=2:fieldnum
                    viewConceptNeuron(tem).(field{i})=PSAfiring(i);
                    connectionPSA2SAA.(str(i).data)(PSAfiring(i),tem)=1;
                end
            end
            varargout{1}.data=SAAsignal;
            varargout{1}.tag='view';
        else
            viewConceptNeuron(SAAfiring.outline).activity=viewConceptNeuron(SAAfiring.outline).activity+1;
            % update other feature areas
            if fieldnum>=2
                for i=2:fieldnum
                    if ~isfield(viewConceptNeuron(SAAfiring.outline),field{i})
                        viewConceptNeuron(SAAfiring.outline).(field{i})=PSAfiring(i);
                    else
                        viewConceptNeuron(SAAfiring.outline).(field{i})=union(...
                            viewConceptNeuron(SAAfiring.outline).(field{i}),PSAfiring(i));
                    end
                    connectionPSA2SAA.(str(i).data)(PSAfiring(i),size(viewConceptNeuron,2))=0;
                    connectionPSA2SAA.(str(i).data)(PSAfiring(i),SAAfiring.outline)=1;
                end
            end
            tem=size(viewConceptNeuron,2);
            SAAsignal=zeros(1,tem);
            SAAsignal(SAAfiring.outline)=1;
            varargout{1}.data=SAAsignal;
            varargout{1}.tag='view';
        end
    end
end

if strcmp(varargin{2},'taste')
    if isempty(tasteConceptNeuron)
        for i=1:fieldnum
            tasteConceptNeuron(1).(field{i})=inputsignal.(field{i});
            connectionPSA2SAA.(str(i).data)=1;
        end
        tasteConceptNeuron(1).activity=1;
        varargout{1}.data=1;
        varargout{1}.tag='taste';
    else
        indexL=[];
        indexH=[];
        for i=1:size(tasteConceptNeuron,2)
            if fieldnum==(size(fieldnames(tasteConceptNeuron(i)),1)-1)
                indexL=[indexL, i];
                fieldnumL=size(fieldnames(tasteConceptNeuron(i)),1)-1;
            else
                if fieldnum>(size(fieldnames(tasteConceptNeuron(i)),1)-1)
                    indexH=[indexH, i];
                end
            end
        end
        % find winner in the LOW SPACE
        for i=1:fieldnumL
            if size(connectionPSA2SAA.(str(i).data),1)<size(varargin{1}.(field{i}),2)
                SAAfiringL.(field{i})=[];
            else
                firingL.(field{i})= (varargin{1}.(field{i}))*connectionPSA2SAA.(str(i).data);
                SAAfiringL.(field{i})= find(firingL.(field{i})==max(firingL.(field{i})));
            end
        end
        setL=SAAfiringL.(field{1});
        for i=2:fieldnumL
            setL=intersect(setL,SAAfiringL.(field{i}));
        end
        if ~isempty(indexH)
            % find winner in the HIGH SPACE
            for i=1:fieldnum
                temCon=connectionPSA2SAA.(str(i).data);
                temCon(:,indexL)=nan;
                if size(connectionPSA2SAA.(str(i).data),1)<size(varargin{1}.(field{i}),2)
                    tem(1,size(varargin{1}.(field{i}),2))=1;
                    firingH.(field{i})=tem;
                    SAAfiringH.(field{i})=size(varargin{1}.(field{i}),2);
                else
                    firingH.(field{i}) = varargin{1}.(field{i})*temCon;
                    SAAfiringH.(field{i})= find(firingH.(field{i})==max(firingH.(field{i})));
                end
            end
            % update in the HIGH SPACE
            setH=SAAfiringH.(field{1});
            for i=2:fieldnum
                setH=intersect(setH,SAAfiringH.(field{i}));
            end
            if isempty(setH)&&isempty(setL)
                % add a new tasteConceptNeuron
                tem=size(tasteConceptNeuron,2)+1;
                for i=1:fieldnum
                    [~, ind]=max(inputsignal.(field{i}));
                    tasteConceptNeuron(tem).(field{i})=ind;
                    connectionPSA2SAA.(str(i).data)(ind,tem)=1;
                end
                tasteConceptNeuron(tem).activity=1;
                SAAsignal(1,tem)=1;
                varargout{1}.data=SAAsignal;
                varargout{1}.tag='taste';
            end
            if isempty(setH)&&~isempty(setL)
                % up-dimensioned the low space tasteConceptNeuron
                for i=fieldnumL+1:fieldnum
                    [~, ind]=max(inputsignal.(field{i}));
                    tasteConceptNeuron(setL).(field{i})=ind;
                    connectionPSA2SAA.(str(i).data)(ind,setL)=1;
                end
                tasteConceptNeuron(setL).activity=...
                    tasteConceptNeuron(setL).activity+1;
                tem=size(tasteConceptNeuron,2);
                SAAsignal=zeros(1,tem);
                SAAsignal(setL)=1;
                varargout{1}.data=SAAsignal;
                varargout{1}.tag='taste';
            end
            if ~isempty(setH)&&isempty(setL)
                tasteConceptNeuron(setH).activity=...
                    tasteConceptNeuron(setH).activity+1;
                tem=size(tasteConceptNeuron,2);
                SAAsignal=zeros(1,tem);
                SAAsignal(setH)=1;
                varargout{1}.data=SAAsignal;
                varargout{1}.tag='taste';
                
            end
            if ~isempty(setH)&&~isempty(setL)
                if setH==setL
                    tasteConceptNeuron(setH).activity=...
                        tasteConceptNeuron(setH).activity+1;
                    tem=size(tasteConceptNeuron,2);
                    SAAsignal=zeros(1,tem);
                    SAAsignal(setH)=1;
                    varargout{1}.data=SAAsignal;
                    varargout{1}.tag='taste';
                else
                    % setH inhibits setL
                    tasteConceptNeuron(setH).activity=...
                        tasteConceptNeuron(setH).activity+1;
                    tem=size(tasteConceptNeuron,2);
                    SAAsignal=zeros(1,tem);
                    SAAsignal(setH)=1;
                    varargout{1}.data=SAAsignal;
                    varargout{1}.tag='taste';
                end
            end
        else
            % update in the LOW SPACE
            if isempty(setL)
                % add a new tasteConceptNeuron
                tem=size(tasteConceptNeuron,2)+1;
                for i=1:fieldnumL
                    [~, ind]=max(inputsignal.(field{i}));
                    tasteConceptNeuron(tem).(field{i})=ind;
                    connectionPSA2SAA.(str(i).data)(ind,tem)=1;
                end
                tasteConceptNeuron(tem).activity=1;
                SAAsignal(1,tem)=1;
                varargout{1}.data=SAAsignal;
                varargout{1}.tag='taste';
            else
                tasteConceptNeuron(setL).activity=...
                    tasteConceptNeuron(setL).activity+1;
                tem=size(tasteConceptNeuron,2);
                SAAsignal=zeros(1,tem);
                SAAsignal(setL)=1;
                varargout{1}.data=SAAsignal;
                varargout{1}.tag='taste';
            end
        end
    end
end
