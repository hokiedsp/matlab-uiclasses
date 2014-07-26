function check_resizefcn(obj,val)
%UISCROLLPANEL/CHECK_RESIZEFCN   Check ResizeFcn value
%   CHECK_RESIZEFCN(OBJ,VAL) where VAL is EventData.NewValue from obj.hwindow's
%   ResizeFcn PostSet event.

if ~isequal(val,@(~,~)obj.layout_panel)
   obj.ResizeFcnMode = 'manual';
end
