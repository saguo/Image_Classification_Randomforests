function wnNode = calcwNode(parent,depth0,wnNode)
   if isempty(parent.par)
       return;
   end
   wnNode = wnNode + 2*(parent.depth+2-depth0);
   wnNode = calcwNode(parent.BL,depth0,wnNode);
   wnNode = calcwNode(parent.BR,depth0,wnNode);
