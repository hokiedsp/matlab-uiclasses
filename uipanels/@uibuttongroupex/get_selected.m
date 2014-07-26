function [name,I] = get_selected(obj)
%UIBUTTONGROUPEX/GET_SELECTED   Get currently selected button index & name
%   [NAME,I] = GET_SELECTED(OBJ)

if obj.isattached()
   hsel = get(obj.hg,'SelectedObject');
   if isempty(hsel)
      name = '';
   else
      name = get(hsel,'String');
   end
elseif ~isempty(val)
   name = '';
end

if nargout>1
   if isempty(name)
      I = [];
   else
      h = obj.Elements;
      I = find(hsel==h,1);
   end
end
