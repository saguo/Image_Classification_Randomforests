%%% Author: Takeshi Kondoh, Zhaoming Zhang
function [PQ, entropyQ] = entropy(data, Qx, clmax)
    PQ=hist(data(Qx,end),1:clmax)+1e-6;
    PQ=PQ/sum(PQ);
    entropyQ=-1*sum(PQ.*log2(PQ));
end
    