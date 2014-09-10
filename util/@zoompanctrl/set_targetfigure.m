function f = set_targetfigure(obj,h)
%UIZOOMCTRL/FIGRESET   Target Figure BeingDestroyed callback
%   FIG = SET_TARGETFIGURE(OBJ,FIG) configures OBJ's zoom and pan
%   properties to work with the figure handle given in FIG.
%
%   FIG = SET_TARGETFIGURE(OBJ,H) configures with the ancestral figure
%   handle of H.

% if object is not valid, just exit
if ~isvalid(obj), return; end

% get target figure
f = ancestor(h,'figure');

% if target figure is being deleted, clear TargetFigure
if strcmp(get(f,'BeingDeleted'),'on')
   f = [];
elseif isequal(obj.TargetFigure,f)
   return; % same figure, everything is already setup
end

% clear existing configuration
obj.CurrentMode = 'none';
if isa(obj.zoom,'graphics.zoom')
   set(obj.zoom,'Enable','off');
end
obj.zoom = [];
if isa(obj.pan,'graphics.pan')
   set(obj.pan,'ActionPostCallback',[]);
end
obj.pan = [];

delete(obj.el_figclose);
obj.el_figclose = [];

% if figure not assigned, set mode to 'none' and get out
if isempty(f)
   return;
end

% associate obj with the new figure
obj.zoom = zoom(f);
obj.pan = pan(f);

% set pan callback for enforcing the boundary condition
set(obj.pan,'ActionPostCallback',@(h,evt)obj.panactionpostfcn(h,evt));

% set new figure listener
obj.el_figclose = addlistener(f,'ObjectBeingDestroyed',@(~,~)clear_targetfigure(obj));

end

function clear_targetfigure(obj)
if isvalid(obj)
   obj.TargetFigure = [];
end
end
