function register_element(obj,h,toRegister)
%UIFLOWGRIDCONTAINER/REGISTER_ELEMENT   ObjectChildAdded/ObjectChildRemoved event callback
%   REGISTER_ELEMENT(OBJ,H,TOADD) registers a subpanel HG object H with
%   OBJ or unregisteres H from OBJ. H must be a scalar handle and H must
%   already be on OBJ.GraphicsHandle. This method is intended to be
%   utilized as the callback method for ObjectChildAdded and
%   ObjectChildRemoved events.

if toRegister
   
   if any(h==obj.elem_h), return; end % already in the system (just in case)
   
   % Get cell indices for the new 
   try
      subs = obj.nextcellsubs(1);
   catch
      warning('Added children is excluded from the grid as it is already full.');
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

   % add listener to remove the element automatically from the grid
   % structure when it is destroyed
   obj.content_listeners(end+1) = addlistener(h,'ObjectBeingDestroyed',@(~,~)obj.register_element(h,false));
   
else % toUnregister
   obj.remove_elements(h);
end

if ~isempty(obj.elem_h)
   obj.update_grid();
end
