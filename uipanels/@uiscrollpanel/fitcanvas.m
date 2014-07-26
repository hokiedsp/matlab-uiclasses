function fitcanvas(obj,dolayout)
%UISCROLLPANEL/FITCANVAS   Set canvas to fit the panel
%   FITCANVAS(OBJ) fits the canvas to the panel without activating the
%   scrollbars.

if nargin<2 || isempty(dolayout), dolayout = true; end

% the largest canvas size w/out activating scrollbar
[~,sz] = obj.get_canvas_position(true);

% save the current canvas units
u = get(obj.hcanvas,'Units');
set(obj.hcanvas,'Units','pixels');

% apply the new size
if dolayout
   obj.layout_panel(sz);
end

% revert the canvas units
set(obj.hcanvas,'Units',u);
