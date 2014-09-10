function hg_resizefcn(obj)
%UISCROLLBAR/HG_RESIZEFCN   ResizeFcn Callback for obj.hg
%   HG_RESIZEFCN(OBJ)

% momentarily clear canvas resizefcn
canvas_rszfcn = obj.hcanvas.ResizeFcn;
obj.hcanvas.ResizeFcn = {};

obj.layout_panel();

% reset canvas resizefcn & call it (if in pixels)
if ~isempty(canvas_rszfcn)
   h = obj.hcanvas;
   try
      h = double(h);
   catch
   end
   canvas_rszfcn(h,[]);
end
obj.hcanvas.ResizeFcn = canvas_rszfcn;
