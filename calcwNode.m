%%%Author Takeshi Kondoh
%%%This function calculate weighted number of node for node sampling
%%%This function might be used for RTSTQ
function wnNode = calcwNode(parent,depth0,wnNode)
   if isempty(parent.par)
       return;
   end
   wnNode = wnNode + 2*(parent.depth+2-depth0);
   wnNode = calcwNode(parent.BL,depth0,wnNode);
   wnNode = calcwNode(parent.BR,depth0,wnNode);
