function scanAxes(obj)
%UIZOOMCTRL/SCANAXES   Scan for the axes in the target figure
%   SCANAXES(OBJ) re-scans the target figure for its axes. Zoom states of
%   the axes are reset to the current limits.

obj.ax = traverse_tree(handle(obj.fig),handle([]));
obj.reset();

end

function ax = traverse_tree(p,ax)

if strcmp(p.Type,'axes')
   ax(end+1,1) = p;
elseif isprop(p,'Children')
   hc = handle(get(p,'Children'));
   for n = 1:numel(hc)
      ax = traverse_tree(hc(n),ax);
   end
end

end
