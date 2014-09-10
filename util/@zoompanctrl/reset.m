function reset(obj)
%UIZOOMCTRL/RESET   Reset zoom out point

% reset zoom out point
zoom(obj.TargetFigure,'RESET');

% update axes limits
obj.scanAxes();
obj.axlims = cell2mat(get(obj.ax,{'XLim','YLim'}));
