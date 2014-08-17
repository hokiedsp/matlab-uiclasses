function reset(obj)
%UIZOOMCTRL/RESET   Reset zoom out point

% reset zoom out point
zoom(obj.fig,'RESET');

% update axes limits
obj.axlims = cell2mat(get(obj.ax,{'XLim','YLim'}));
