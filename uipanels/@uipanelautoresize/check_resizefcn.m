function check_resizefcn(obj,val)
%UISCROLLPANEL/CHECK_RESIZEFCN   Check ResizeFcn value
%   CHECK_RESIZEFCN(OBJ,VAL) where VAL is EventData.NewValue from obj.hg's
%   ResizeFcn PostSet event.

%if ~strcmp(func2str(val),func2str(obj.defaultresizefcn))
if ~isequal(val,obj.defaultresizefcn)
   obj.ResizeFcnMode = 'manual';
end
