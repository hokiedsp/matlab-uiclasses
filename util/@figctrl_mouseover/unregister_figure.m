function unregister_figure(obj)
%FIGCTRL_MOUSEOVER/UNREGISTER_FIGURE   (protected) Clear figure
%   UNREGISTER_FIGURE(OBJ) clears the registered figure's
%   WindowButtonMotionFcn and clears its mouseover callback list.

% remove all figmon callback functions from attached figure
fig = obj.wbmf_mode.GraphicsHandle;
if isequal(get(fig,'WindowButtonMotionFcn'),obj.wbmf_mode.DefaultValue)
   set(fig,'WindowButtonMotionFcn',{});
end
obj.wbmf_mode.clrTarget();

% delete all 
delete(obj.el);
obj.h(:) = [];
obj.el(:) = [];
obj.cbfcns(:) = [];
