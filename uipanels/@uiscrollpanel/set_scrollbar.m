function set_scrollbar(obj,I,val)
%UISCROLLPANEL/SET_SCROLLBAR   Update scrollbar value (protected)
%   UPDATE_SCROLLBAR(OBJ,I)

% only proceed if minor step value has changed
if val==obj.step(I), return; end
obj.step(I) = val;

% update the HG object if currently attached
if ~obj.isattached(), return; end

Iother = mod(I,2)+1;

% Set canvas Units to pixels
[pos_canvas,size_shell] = obj.get_canvas_position();

uiscrollpanel.set_scrollbar_step(obj.hscrollbars(I),obj.hscrollbars(Iother),obj.step(I),size_shell(I),pos_canvas(I+2),obj.thickness);
