function similarword = getsimilarword(similarword, set)
% return the index of the syllables of the similar words
if size(set,2)~=0
    tem=[];
     for i=1:size(similarword,1)
         temp=repmat(similarword(i,:),size(set(1).data,2),1);
         tem=[tem; temp set(1).data'];
     end
     similarword=tem;
     set(1)=[];
     similarword=getsimilarword(similarword, set);
else
    return
end