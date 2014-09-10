function V = getAxesZoomOutPoint(obj,axes)

if ~(ishghandle(axes) && isscalar(axes))
   error('AXES is not a valid HG object.');
end
[tf,I] = ismember(axes,obj.ax);
if ~tf
   error('AXES is not a descendent of TargetFigure.');
end
V = obj.axlims(I,:);
