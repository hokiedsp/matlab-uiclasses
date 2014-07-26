function attach_se(obj,h)
%HGDISGUISE/ATTACH_SE   Attaches a HG object
%   ATTACH_SE(OBJ,H) associates the HG object, specified by its handle given
%   in H, with the HGDISGUISE object OBJ. If OBJ is an array of
%   HGDISGUISE objects, the number of elements in OBJ and H must agree.
%
%   If OBJ.AutoDetach = 'off' (default) deleting OBJ or H also deletes the
%   other as well. Set OBJ.AutoDetach = 'on' to avoid this behavior.
%
%   See also HGDISGUISE, HGDISGUISE/HGDISGUISE, HGDISGUISE/DETACH.

% create uicontainers at the same positions as H
panelpropnames = {'Units','Position','Parent','Visible'};
panelpropvalues = get(h,panelpropnames);
hpanel = handle(obj.create_panel_fcn('Parent',ancestor(h,'figure'),'Visible','off',...
   panelpropnames(1:2),panelpropvalues(1:2)));

% get properties to be transferred to the panel
panelpropvalues = get(h,panelpropnames);

% adjust the location of H and place it in the panels
pos = panelpropvalues{2};
if strcmp(panelpropvalues{1},'pixels')
   pos([1 2]) = 1;
else
   pos([1 2]) = 0;
end
set(h,'Parent',hpanel,'Position',pos);

% place the panel back to where h was
set(hpanel,panelpropnames(3:4),panelpropvalues(3:4));

% attach the hpanel to OBJ which will subsequently call 
% populate_panel & layout_panel to finalize the panel layout
obj.attach_se@uipanelex(hpanel);
