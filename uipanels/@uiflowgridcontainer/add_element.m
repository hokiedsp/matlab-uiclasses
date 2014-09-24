function added = add_element(obj,h)
%UIFLOWGRIDCONTAINER/ADD_ELEMENT   Add new element to the grid
%   ADD_ELEMENT(OBJ,H) adds an HG object H to the grid. H must be a scalar
%   handle and H must already be on OBJ.GraphicsHandle. This method is
%   intended to be utilized by register_element() and addElement () and it
%   DOES NOT call update_grid() in the end.

added = all(h~=obj.elem_h);
if ~added, return; end % already in the system (just in case)

% Get cell indices for the new
try
   subs = obj.nextcellsubs(1);
catch
   warning('uiflowgridcontainer:GridFull','Added children is excluded from the grid as it is already full.');
   added = false;
   return;
end

% append new handles to elem_h
Inew = size(obj.elem_h,1)+1;
obj.elem_h(Inew,1) = handle(h);
obj.elem_subs(Inew,:) = subs;

% set span to the default value
obj.elem_span(Inew,:) = 1;    % elements' sizes in cells

% set wlims & hlims tight
set(obj.content_listeners,'Enabled','off') % just in case
u = get(h,{'Units'});
if ~strcmp(u,'normalized') % if not normalized, set width & height limits to the current size
   set(h,'Units','pixels');
   pos = cell2mat(get(h,{'Position'})); % get element positions
   set(obj.content_listeners,'Enabled','on') % just in case
   
   wlims = pos(3);
   hlims = pos(4);
else
   wlims = [2 inf];
   hlims = [2 inf];
end
obj.elem_wlims(Inew,:) = wlims;
obj.elem_hlims(Inew,:) = hlims;

% set halign & valign to default
obj.elem_halign(Inew,1) = 1; % 'left'
obj.elem_valign(Inew,1) = 2; % 'middle'

% set hfixed & vfixed to default
obj.elem_hfixed(Inew,1) = false; % 'dynamic'
obj.elem_vfixed(Inew,1) = false; % 'dynamic'

% add listener to remove the element automatically from the grid
% structure when it is destroyed
obj.content_listeners(end+1) = addlistener(h,'ObjectBeingDestroyed',@(~,~)obj.unregister_element(h));
