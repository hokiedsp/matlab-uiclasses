function unpopulate_panel(obj)
%UIZOOMCTRL/UNPOPULATE_PANEL(OBJ)

delete(obj.el_btnstates);
obj.el_btnstates(:) = [];

delete(obj.el_axpos);
obj.el_axpos(:) = [];

if ~isempty(obj.btns.pointer)
   delete(obj.btns.pointer);
   obj.btns.pointer = [];
   obj.btns.zoomin = [];
   obj.btns.zoomout = [];
   obj.btns.pan = [];
   obj.jbtns.pointer = [];
   obj.jbtns.zoomin = [];
   obj.jbtns.zoomout = [];
   obj.jbtns.pan = [];
end
