function validate_selected(obj,val)
%UIBUTTONGROUPEX/VALIDATE_SELECTED   Validate selected button
%   VALIDATE_SELECTED(OBJ,INDEX)
%   VALIDATE_SELECTED(OBJ,NAME)

if ~isempty(val)
   if obj.isattached()
      h = obj.Elements;
      if ischar(val) % name
         validatestring(val,get(h,{'String'}));
      else % index
         validateattributes(val,{'numeric'},{'scalar','positive','<=',numel(h),'integer'});
      end
   else
      error('Selection cannot be made if UIBUTTONGROUP object is not attached.');
   end
end
