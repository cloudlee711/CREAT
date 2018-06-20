function [output] = unconsciousimpulse (inputsignal,connection)
if isempty(inputsignal)||isempty(connection)
    output=[];
else
    output=repmat(inputsignal,size(connection,1),1).*connection;
end