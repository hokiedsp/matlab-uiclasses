function setFigureFocus(h)
%UIUTIL/SETFIGUREFOCUS

% get the figure containing the handle h
hFig = ancestor(h,'figure');

figName = get(hFig,'name');
if strcmpi(get(hFig,'number'),'on')
   figName = regexprep(['Figure ' num2str(hFig) ': ' figName],': $','');
end
mde = com.mathworks.mde.desk.MLDesktop.getInstance;
jFigPanel = mde.getClient(figName);
% If invalid RootPane - try another method...
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');  % R2008b compatibility
jFrame = get(hFig,'JavaFrame');
jAxisComponent = get(jFrame,'AxisComponent');
jRootPane = jAxisComponent.getParent.getParent.getRootPane;
% If invalid RootPane, retry up to N times
tries = 10;
while isempty(jRootPane) && tries>0  % might happen if figure is still undergoing rendering...
   drawnow; pause(0.001);
   tries = tries - 1;
   jRootPane = jFigPanel.getComponent(0).getRootPane;
end

% If still invalid, use FigurePanelContainer which is good enough in 99% of cases... (menu/tool bars won't be accessible, though)
if isempty(jRootPane)
   jRootPane = jFigPanel;
end

% Try to get the ancestor FigureFrame
jRootPane.getTopLevelAncestor.requestFocus();

end
