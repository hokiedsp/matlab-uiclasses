function register_subpanel(obj,h,toRegister)
%UIPANELGROUP/REGISTER_SUBPANEL   ObjectChildAdded/ObjectChildRemoved event callback
%   REGISTER_SUBPANEL(OBJ,H,TOADD) registers a subpanel HG object H with
%   OBJ or unregisteres H from OBJ. H must be a scalar handle and H must
%   already be on OBJ.GraphicsHandle. This method is intended to be
%   utilized as the callback method for ObjectChildAdded and
%   ObjectChildRemoved events.

% currently registered panels
hlistened = get(obj.content_listeners,{'Container'}); % <- R2014b compatibility check
hlistened = [hlistened{:}];
hpanels = unique(hlistened); % registered panels

if toRegister
   hadd = setdiff(h,hpanels);
   if isempty(hadd), return; end % already in the system
   
   % make sure the object is a valid panel type
   if ~uipanelex.ispanel(hadd)
      warning('Attempted to add non-panel HG object to UIPANELGROUP.')
      return;
   end
   
   % setup the property listeners
   obj.set_subpanel_listeners(hadd); %<-derived class can override this function
   
else % toUnregister
   hremove = intersect(h,hpanels);
   
   % remove listeners
   [~,I] = intersect(hlistened,hremove);
   delete(obj.content_listeners(I,:));
   obj.content_listeners(I,:) = [];
end
