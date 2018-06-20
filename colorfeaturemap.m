function [firingNeuron disLspace disHspace] = colorfeaturemap (CH,colorthreshold,tlabel)
global colorConceptNeuron;
global featureNeuronSOMconnection;
firingNeuron=0;
disLspace=[];
disHspace=[];
LspaceRec=[];
HspaceRec=[];
winnerLspace=0;
winnerHspace=0;
inputchannelnum=size(CH,2);
numConceptNeuron=size(colorConceptNeuron,2);
%initialize colorConceptNeuron map
if numConceptNeuron==0
    colorConceptNeuron(1).data=CH;
    colorConceptNeuron(1).threshold=norm(CH(:))/colorthreshold;
    colorConceptNeuron(1).activity=1;
    colorConceptNeuron(1).label=tlabel;
    firingNeuron=1;
    featureNeuronSOMconnection.color(1,1)=0;
else
    %computing distances
    for i=1:numConceptNeuron
        if size(colorConceptNeuron(i).data,2)<inputchannelnum % low dimension colorConceptNeuron
            tem=size(colorConceptNeuron(i).data,2);
            disLspace(i,:,:)=CH(:,(inputchannelnum-tem+1):inputchannelnum)-colorConceptNeuron(i).data;
            LspaceRec=[LspaceRec,i];
        else 
            if size(colorConceptNeuron(i).data,2)==inputchannelnum % high dimension colorConceptNeuron
                disHspace(i,:,:)=CH-colorConceptNeuron(i).data;
                HspaceRec=[HspaceRec,i];
            else
                %----------%
            end
        end
    end
    if isempty(LspaceRec) % no mix dimension feature cell
        %find winners
        tem=reshape(disHspace,size(disHspace,1),size(disHspace,2)*size(disHspace,3));
        disH=sum(abs(tem).^2,2).^(1/2);
        [valueH,winnerHspace]=min(disH);
        %update colorConceptNeuron map
        if valueH<colorConceptNeuron(winnerHspace).threshold
            colorConceptNeuron(winnerHspace).activity=colorConceptNeuron(winnerHspace).activity+1;
            colorConceptNeuron(winnerHspace).data=colorConceptNeuron(winnerHspace).data+...
                (1/colorConceptNeuron(winnerHspace).activity)*(CH-colorConceptNeuron(winnerHspace).data);
            colorConceptNeuron(winnerHspace).threshold=norm(colorConceptNeuron(winnerHspace).data(:))/colorthreshold;
            colorConceptNeuron(winnerHspace).label=[colorConceptNeuron(winnerHspace).label,tlabel];
            featureSOM(winnerHspace,disH);
%             [~,col]=find(featureNeuronSOMconnection.color(winnerHspace,:)~=0);
%             featureNeuronSOMconnection.color(winnerHspace,col)=featureNeuronSOMconnection.color(winnerHspace,col)+1;
%             featureNeuronSOMconnection.color(col,winnerHspace)=featureNeuronSOMconnection.color(col,winnerHspace)+1;
%             for i=1:numConceptNeuron
%                 if disH(i)<delta*colorConceptNeuron(i).threshold
%                     featureNeuronSOMconnection.color(winnerHspace,i)=1;
%                     featureNeuronSOMconnection.color(i,winnerHspace)=1;
%                 end
%             end
%             locate=find(featureNeuronSOMconnection.color(winnerHspace,:)>agedead);
%             featureNeuronSOMconnection.color(winnerHspace,locate)=0;
%             featureNeuronSOMconnection.color(locate,winnerHspace)=0;
            % generate firing signals
            firingNeuron=zeros(1,numConceptNeuron);
            firingNeuron(winnerHspace)=1;
        else
            tem=numConceptNeuron+1;
            colorConceptNeuron(tem).data=CH;
            colorConceptNeuron(tem).threshold=norm(CH(:))/colorthreshold;
            colorConceptNeuron(tem).activity=1;
            colorConceptNeuron(tem).label=tlabel;
            featureNeuronSOMconnection.color(tem,tem)=0;
            % generate firing signals
            firingNeuron(1,tem)=1;
        end
    else % mix dimension feature cells exist
        %find winners
        if isempty(disHspace) % first high dimension feature comes
            tem1=reshape(disLspace,size(disLspace,1),size(disLspace,2)*size(disLspace,3));
            disL=sum(abs(tem1).^2,2).^(1/2);
            [valueL,winnerLspace]=min(disL);
            if valueL<colorConceptNeuron(winnerLspace).threshold
                % up-dimension the low space winner
                colorConceptNeuron(winnerLspace).activity=colorConceptNeuron(winnerLspace).activity+1;
                colorConceptNeuron(winnerLspace).activityH=1;
                colorConceptNeuron(winnerLspace).data=colorConceptNeuron(winnerLspace).data+...
                    (1/colorConceptNeuron(winnerLspace).activity)*(CH(:,2:3)-colorConceptNeuron(winnerLspace).data);
                colorConceptNeuron(winnerLspace).data=[CH(:,1),colorConceptNeuron(winnerLspace).data];
                colorConceptNeuron(winnerLspace).threshold=norm(colorConceptNeuron(winnerLspace).data(:))/colorthreshold;
                colorConceptNeuron(winnerLspace).label=[colorConceptNeuron(winnerLspace).label,tlabel];
                % update colorConceptNeuron map
                featureSOM(winnerLspace,disL);
                % generate firing signals
                firingNeuron=zeros(1,numConceptNeuron);
                firingNeuron(winnerLspace)=1;
            else
                % add this new high dimension feature
                tem=numConceptNeuron+1;
                colorConceptNeuron(tem).data=CH;
                colorConceptNeuron(tem).threshold=norm(CH(:))/colorthreshold;
                colorConceptNeuron(tem).activity=1;
                colorConceptNeuron(tem).activityH=1;
                colorConceptNeuron(tem).label=tlabel;
                %update colorConceptNeuron map
                featureNeuronSOMconnection.color(tem,tem)=0;
                % generate firing signals
                firingNeuron(1,tem)=1;
            end
        else % not first high dimension feature comes
            disLspace(HspaceRec,:,:)=disHspace(HspaceRec,:,1:size(disLspace,3));
            disHspace(LspaceRec,:,:)=nan;
            tem1=reshape(disLspace,size(disLspace,1),size(disLspace,2)*size(disLspace,3));
            disL=sum(abs(tem1).^2,2).^(1/2);
            [valueL,winnerLspace]=min(disL);
            tem2=reshape(disHspace,size(disHspace,1),size(disHspace,2)*size(disHspace,3));
            disH=sum(abs(tem2).^2,2).^(1/2);
            [valueH,winnerHspace]=min(disH);
            condition1=valueL<colorConceptNeuron(winnerLspace).threshold;
            condition2=valueH<colorConceptNeuron(winnerHspace).threshold;
            if condition1&&condition2
                % update colorConceptNeuron winnerHspace
                colorConceptNeuron(winnerHspace).activity=colorConceptNeuron(winnerHspace).activity+1;
                colorConceptNeuron(winnerHspace).activityH=colorConceptNeuron(winnerHspace).activityH+1;
                colorConceptNeuron(winnerHspace).data(:,1)=colorConceptNeuron(winnerHspace).data(:,1)+...
                    (1/colorConceptNeuron(winnerHspace).activityH)*(CH(:,1)-colorConceptNeuron(winnerHspace).data(:,1));
                colorConceptNeuron(winnerHspace).data(:,2:3)=colorConceptNeuron(winnerHspace).data(:,2:3)+...
                    (1/colorConceptNeuron(winnerHspace).activity)*(CH(:,2:3)-colorConceptNeuron(winnerHspace).data(:,2:3));
                colorConceptNeuron(winnerHspace).threshold=norm(colorConceptNeuron(winnerHspace).data(:))/colorthreshold;
                colorConceptNeuron(winnerHspace).label=[colorConceptNeuron(winnerHspace).label,tlabel];
                if winnerLspace~=winnerHspace
                    if size(colorConceptNeuron(winnerLspace).data,2)<size(CH,2)
                        % up-dimension the low space winner
                        colorConceptNeuron(winnerLspace).activity=colorConceptNeuron(winnerLspace).activity+1;
                        colorConceptNeuron(winnerLspace).activityH=1;
                        colorConceptNeuron(winnerLspace).data=colorConceptNeuron(winnerLspace).data+...
                            (1/colorConceptNeuron(winnerLspace).activity)*(CH(:,2:3)-colorConceptNeuron(winnerLspace).data);
                        colorConceptNeuron(winnerLspace).data=[CH(:,1),colorConceptNeuron(winnerLspace).data];
                        colorConceptNeuron(winnerLspace).threshold=norm(colorConceptNeuron(winnerLspace).data(:))/colorthreshold;
                        colorConceptNeuron(winnerLspace).label=[colorConceptNeuron(winnerLspace).label,tlabel];
                        %update colorConceptNeuron map
                        featureSOM(winnerLspace,disH);
                    end
                end
                %update colorConceptNeuron map
                featureSOM(winnerHspace,disH);
                % generate firing signals
                firingNeuron=zeros(1,numConceptNeuron);
                firingNeuron(winnerHspace)=1;
            end
            if condition1&&~condition2
                if size(colorConceptNeuron(winnerLspace).data,2)<size(CH,2)
                    % up-dimension the low space winner
                    colorConceptNeuron(winnerLspace).activity=colorConceptNeuron(winnerLspace).activity+1;
                    colorConceptNeuron(winnerLspace).activityH=1;
                    colorConceptNeuron(winnerLspace).data=colorConceptNeuron(winnerLspace).data+...
                        (1/colorConceptNeuron(winnerLspace).activity)*(CH(:,2:3)-colorConceptNeuron(winnerLspace).data);
                    colorConceptNeuron(winnerLspace).data=[CH(:,1),colorConceptNeuron(winnerLspace).data];
                    colorConceptNeuron(winnerLspace).threshold=norm(colorConceptNeuron(winnerLspace).data(:))/colorthreshold;
                    colorConceptNeuron(winnerLspace).label=[colorConceptNeuron(winnerLspace).label,tlabel];
                    %update colorConceptNeuron map
                    featureSOM(winnerLspace,disH);
                    % generate firing signals
                    firingNeuron=zeros(1,numConceptNeuron);
                    firingNeuron(winnerLspace)=1;
                else
                    % add this new high dimension feature
                    tem=numConceptNeuron+1;
                    colorConceptNeuron(tem).data=CH;
                    colorConceptNeuron(tem).threshold=norm(CH(:))/colorthreshold;
                    colorConceptNeuron(tem).activity=1;
                    colorConceptNeuron(tem).activityH=1;
                    colorConceptNeuron(tem).label=tlabel;
                    %update colorConceptNeuron map
                    featureNeuronSOMconnection.color(tem,tem)=0;
                    % generate firing signals
                    firingNeuron(1,tem)=1;
                end
            end
            if ~condition1&&condition2
                % update colorConceptNeuron winnerHspace
                colorConceptNeuron(winnerHspace).activity=colorConceptNeuron(winnerHspace).activity+1;
                colorConceptNeuron(winnerHspace).activityH=colorConceptNeuron(winnerHspace).activityH+1;
                colorConceptNeuron(winnerHspace).data(:,1)=colorConceptNeuron(winnerHspace).data(:,1)+...
                    (1/colorConceptNeuron(winnerHspace).activityH)*(CH(:,1)-colorConceptNeuron(winnerHspace).data(:,1));
                colorConceptNeuron(winnerHspace).data(:,2:3)=colorConceptNeuron(winnerHspace).data(:,2:3)+...
                    (1/colorConceptNeuron(winnerHspace).activity)*(CH(:,2:3)-colorConceptNeuron(winnerHspace).data(:,2:3));
                colorConceptNeuron(winnerHspace).threshold=norm(colorConceptNeuron(winnerHspace).data(:))/colorthreshold;
                colorConceptNeuron(tem).label=[colorConceptNeuron(tem).label,tlabel];
                %update colorConceptNeuron map
                featureSOM(winnerHspace,disH);
                % generate firing signals
                firingNeuron=zeros(1,numConceptNeuron);
                firingNeuron(winnerHspace)=1;
            end
            if ~condition1&&~condition2
                % add this new high dimension feature 
                tem=numConceptNeuron+1;
                colorConceptNeuron(tem).data=CH;
                colorConceptNeuron(tem).threshold=norm(CH(:))/colorthreshold;
                colorConceptNeuron(tem).activity=1;
                colorConceptNeuron(tem).activityH=1;
                colorConceptNeuron(tem).label=tlabel;
                %update colorConceptNeuron map
                featureNeuronSOMconnection.color(tem,tem)=0;
                % generate firing signals
                firingNeuron(1,tem)=1;
            end
        end
    end
end

function featureSOM(winner,dis)
agedead=50;
delta=3;
global colorConceptNeuron;
global featureNeuronSOMconnection;
[~,col]=find(featureNeuronSOMconnection.color(winner,:)~=0);
featureNeuronSOMconnection.color(winner,col)=featureNeuronSOMconnection.color(winner,col)+1;
featureNeuronSOMconnection.color(col,winner)=featureNeuronSOMconnection.color(col,winner)+1;
for i=1:size(colorConceptNeuron,2)
    if dis(i)<delta*colorConceptNeuron(i).threshold
        featureNeuronSOMconnection.color(winner,i)=1;
        featureNeuronSOMconnection.color(i,winner)=1;
    end
end
locate=find(featureNeuronSOMconnection.color(winner,:)>agedead);
featureNeuronSOMconnection.color(winner,locate)=0;
featureNeuronSOMconnection.color(locate,winner)=0;
