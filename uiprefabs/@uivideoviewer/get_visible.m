function val = get_visible(obj)
%UIVIDEOVIEWER/GET_VISIBLE
%   VAL = GET_VISIBLE(OBJ)

if obj.isopen()
   val = get(obj.im,'Visible');
else
   val = get(obj.hg,'Visible');
end
