function tf = isvisible(h)
%UIUTIL/ISVISIBLE   HG object visibility check
%   UIUTIL.ISVISIBLE(H) returns true if HG object H is visible

vis = get(h,'Visible');
h = get(h,'Parent');
while h>0 && strcmp(vis,'on')
   vis = get(h,'Visible');
   h = get(h,'Parent');
end
% if uizoomctrl is in visible
tf = h==0 && strcmp(vis,'on');
