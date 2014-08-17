function set_targetfigure(obj,h)
%UIZOOMCTRL/FIGRESET   Target Figure BeingDestroyed callback
%   FIGRESET(OBJ)

% if target figure is closed, reset target to the figure containing OBJ
f = ancestor(h,'figure');
if isequal(obj.fig,f) || strcmp(get(f,'BeingDeleted'),'on'), return; end

% update the internal properties
obj.fig = f;
delete(obj.zoom);
obj.zoom = zoom(f);
delete(obj.pan);
obj.pan = pan(f);

% set pan callback for enforcing the boundary condition
set(obj.pan,'ActionPostCallback',@(h,evt)obj.panactionpostfcn(h,evt));

% set new figure listener
delete(obj.el_figclose);
if isequal(f,ancestor(obj.hg,'figure'))
   obj.el_figclose = [];
else
   obj.el_figclose = addlistener(handle(obj.fig),'ObjectBeingDestroyed',@(~,~)obj.set_targetfigure(obj.hg));
end

% initialize figure monitor listeners
obj.scanAxes();

% set the mode on the new figure
obj.modechange(obj.mode);
