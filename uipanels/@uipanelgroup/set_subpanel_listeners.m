function set_subpanel_listeners(obj,h)
%UIPANELGROUP/SET_SUBPANEL_LISTENERS   Add subpanel property listeners

% monitor Units to sync'ing Units of all subpanels
obj.content_listeners(end+1) ...
   = addlistener(h,'Units','PostSet',@(~,event)obj.sync_subpanelunits(h,event.NewValue));
