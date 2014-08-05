function [pval,doresize] = set_weight(obj,private_prop,I,val)
%UIFLOWCONTAINER/SET_WEIGHT   Set column/row weighting
%   SET_WEIGHT(OBJ,PUBLIC_PROP,PRIVATE_PROP,I,VAL)

N = numel(val);
val = val(:).';

% If weight vector does not match the grid size, expand one or the other
doresize = N>obj.gridsize(I);
if doresize % weight vector is longer, expand the grid
   obj.gridsize(I) = N;
elseif N<obj.gridsize(I) % grid is larger, expand the weight with NaN
   val(N+1:obj.gridsize(I)) = nan;
end
pval = val; % set public property

% Convert public property to private counterpart
idx = isnan(val);
if all(idx)
   val = ones(1,N); % if all nan, all the same weights
elseif any(idx)
   val(idx) = mean(val(~idx)); % if selected rows/columns are nan, set them to the average of non-nan values
end
obj.(private_prop) = val(:);
