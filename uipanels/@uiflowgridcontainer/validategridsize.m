function validategridsize(obj,val)
%UIGRIDCONTAINEREX/VALIDATEGRIDSIZE   Validates new GridSize value
%   VALIDATEGRIDSIZE(OBJ,VAL)

validateattributes(val,{'numeric'},{'numel',2,'positive','integer'});

% if no elements, any grid size is fine
if isempty(obj.elem_h), return; end

% if elements won't reflow when gridsize is changed, new gridsize must
% contain all the elements
if obj.reflow
   if ~obj.autoexpand && prod(val) < obj.NumberOfElements
      error('New GridSize must have more grids than the number of existing elements.');
   end
else
   val = val(:).';
   minsize = max(obj.elem_subs + obj.elem_span - 1);
   if any(val<minsize)
      error('GridSize is too small for existing elements. It must be at least [%d %d].',minsize(1),minsize(2));
   end
end
