function set_subpanels(obj,hnewpanels)
%UIPANELGROUP/SET_SUBPANELS   Implements set.Panels
%   SET_SUBPANELS(OBJ,Hpanels)

% currently registered subpanels
hlistened = get(obj.content_listeners,{'Container'});
hlistened = [hlistened{:}];
hpanels = unique(hlistened);
hnotready = setdiff(handle(get(obj.hg,'Children')),hpanels); % unregistered panels

% block layout until all subpanels are in
autol = obj.AutoLayout;
obj.autolayout = false;

% exclude subpanels that are staying
[~,Inew,Iold] = intersect(hnewpanels,hpanels);
hnewpanels(Inew) = [];
hpanels(Iold) = [];

% delete removed subpanels and let ObjectChildRemoved callback to take care of
% the registration
delete(hpanels);

% determine which ones of the new subpanels are already on the panel
[hneedreg,I] = intersect(hnewpanels,hnotready);
hnewpanels(I) = [];

% move new subpanels to the panelgroup, and let ObjectChildAdded callback
% to take care of the registeration
set(hnewpanels,'Parent',obj.GraphicsHandle);

% register existing subpanels
for n = 1:numel(hneedreg)
   obj.config_subpanels(hneedreg(n),true);
end

% restore AutoLayout setting (and call layout_panel if turned on)
obj.AutoLayout = autol;
