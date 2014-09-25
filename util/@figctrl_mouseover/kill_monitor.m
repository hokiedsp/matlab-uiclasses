function kill_monitor(obj,h)
%FIGCTRL_MOUSEOVER/KILL_MONITOR   Event callback when mouseover object is
%deleted.

% if FIGCTRL_MOUSEOVER OBJ is already destroyed, nothing to do
if ~isvalid(obj), return; end

% kill & remove the listener
l = findobj(obj.el,'flat','Container',h,'Callback',obj.killfcn);
I = obj.el==handle(l);
delete(obj.el(I));

% kill the callback entry
obj.h(I) = [];
obj.el(I) = [];
obj.cbfcns(I) = [];
