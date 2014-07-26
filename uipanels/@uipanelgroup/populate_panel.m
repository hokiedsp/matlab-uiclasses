function populate_panel(obj)
%UIPANELGROUP/POPULATE_PANEL   (protected) Populate panel with its content
%
% Format both shell (obj.hg) and canvas (obj.hc) containers

% nothing to do if detached
if ~obj.isattached(), return; end

% configure base panel & its listeners
obj.populate_panel@uipanelex();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Configure uicontainer subpanels
obj.set_subpanels(get(obj.hg,'Children'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Listen to ObjectChildAdded and ObjectChildRemoved on obj.hg for direct
% addition/removal of panels
obj.hg_listener(end+1) = addlistener(obj.hg,'ObjectChildAdded',...
   @(~,event)obj.register_subpanel(event.Child,true));
obj.hg_listener(end+1) = addlistener(obj.hg,'ObjectChildRemoved',...
   @(~,event)obj.register_subpanel(event.Child,false));
