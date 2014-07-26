function check_child(obj,h,newstyle)
%UIBUTTONGROUPEX/CHECK_CHILD   Monitor child uicontrols' Style property
%   CHECK_CHILD(OBJ,H,NEWSTYLE) is called by uicontrol Children's Style
%   PostSet events. Thus, H is always scalar.

% find which listeners listens to this object
if ~any(strcmp(newstyle,{'radiobutton','togglebutton'}))
   obj.register_element(h,false); % remove h from the grid
end
