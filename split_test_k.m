function output = split_test_k(branch, data, index, output)
% output consists of mmax cells. each cell corresponds to class. each cell
% containes the index of data, which are classified into that class.
% "split" based classifer
   if  isempty(branch.BL) % if the node is terminal
       [~,ind] = max(branch.PQ); % the data classified into ind
       output{ind} = [output{ind}; index];
   else
       par = branch.par;
       L = index(data(index,par(1)) < par(2)); % the index of the data which goes to left node
       R = index(data(index,par(1)) >= par(2)); 
       output = split_test_k(branch.BL, data, L, output);
       output = split_test_k(branch.BR, data, R, output);
   end
