function unpopulate_panel(obj)
%UIZOOMCTRL/UNPOPULATE_PANEL(OBJ)

% delete all event listeners
delete(obj.el_figclose);
obj.el_figclose(:) = [];

delete(obj.el_axpos);
obj.el_axpos(:) = [];

if ~isempty(obj.btns)
   delete(obj.btns);
   obj.btns = [];
   obj.jbtns = [];
end
