function validategridsize(obj,val)
%UIGRIDCONTAINEREX/VALIDATEGRIDSIZE   Validates new GridSize value
%   VALIDATEGRIDSIZE(OBJ,VAL)

validateattributes(val,{'numeric'},{'numel',2,'positive','integer'});

if ~isempty(obj.elem_h)
   val = val(:).';
   minsize = max(obj.elem_subs + obj.elem_span - 1);
   if any(val<minsize)
      error('GridSize is too small for existing elements. It must be at least [%d %d].',minsize(1),minsize(2));
   end
end
