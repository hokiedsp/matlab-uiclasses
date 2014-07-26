function layout_panel(obj,sz)
%UISCROLLPANEL/LAYOUT_PANEL   Set canvas position
%   LAYOUT_PANEL(OBJ) layouts the child objects of OBJ.hg according to the
%   current panel size. This includes determination of scrollbar
%   visibilities and positioning of scrollbars and canvas.
%
%   LAYOUT_PANEL(OBJ,SZ) assigns new canvas size.

% nothing to do if detached
if ~obj.isattached() || ~obj.autolayout, return; end

if nargin>1
   % Update the canvas size
   pos = get(obj.hcanvas,'Position');
   pos([3 4]) = sz;
   set(obj.hcanvas,'Position',pos);
end

% Set canvas Units to pixels
[pos_canvas,sz_shell] = obj.get_canvas_position();

[issmall,hide] = obj.is_canvas_small(pos_canvas([3 4]),sz_shell);

% configure scrollbars
pn = {'Visible','Enable'};
pv = cell(2);
pvals = {'on' 'off'};
pv(:,1) = pvals(1+hide);
pv(:,2) = pvals(1+issmall);
set(obj.hscrollbars,pn,pv);

pos = zeros(1,4);
[pos(1),pos(2),pos(3),pos(4)] = uiscrollpanel.get_scrollbar_position(obj.loclo(1),...
   sz_shell(1),obj.hscrollbars(2),obj.loclo(2),sz_shell(2),obj.thickness);
set(obj.hscrollbars(1),'Position',pos);

[pos(2),pos(1),pos(4),pos(3)] = uiscrollpanel.get_scrollbar_position(obj.loclo(2),...
   sz_shell(2),obj.hscrollbars(1),obj.loclo(1),sz_shell(1),obj.thickness);
set(obj.hscrollbars(2),'Position',pos);

% Configure horizontal dimension
if issmall(1)
   pos_canvas(1) = uiscrollpanel.get_small_canvas_origin(pos_canvas(3),...
      sz_shell(1),obj.align(1),~hide(2),obj.loclo(2),obj.thickness);
else
   pos_canvas(1) = uiscrollpanel.set_scrollbar_step(obj.hscrollbars(1),...
      obj.hscrollbars(2),obj.loclo(2),obj.step(1),sz_shell(1),pos_canvas(3),...
      obj.thickness);
end
   
% Configure vertical dimension
if issmall(2)
   pos_canvas(2) = uiscrollpanel.get_small_canvas_origin(pos_canvas(4),...
      sz_shell(2),obj.align(2),~hide(1),obj.loclo(1),obj.thickness);
else
   pos_canvas(2) = uiscrollpanel.set_scrollbar_step(obj.hscrollbars(2),...
      obj.hscrollbars(1),obj.loclo(1),obj.step(2),sz_shell(2),pos_canvas(4),...
      obj.thickness);
end

% Set new canvas location
obj.set_canvas_position(pos_canvas);
