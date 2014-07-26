function set_selected(obj,val)
%UIBUTTONGROUPEX/SET_SELECTED   Select a button
%   SET_SELECTED(OBJ,I)
%   SET_SELECTED(OBJ,NAME)

if isempty(val)
   set(obj.hg,'SelectedObject',[]);
else
   h = obj.Elements;
   if ischar(val)
      val = find(strcmpi(val,get(h,{'String'})),1);
   end
   set(obj.hg,'SelectedObject',h(val));
end
