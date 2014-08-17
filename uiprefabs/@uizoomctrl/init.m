function init(obj)
%UIZOOMCTRL/PROPOPTS   Returns set/get property attribute cell

obj.init@uipanelautoresize();

obj.mode = -1;
obj.panelsize = [0 0];

obj.propopts.AutoLayout.Default = 'on';

obj.propopts.AllowUnselect = struct(...
   'StringOptions',{{'on' 'off'}},...
   'Default','on');
obj.propopts.ButtonSize = struct(...
   'OtherTypeValidator',{{{'numeric'},{'scalar','positive','finite'}}},...
   'Default',18);
obj.propopts.CurrentMode = struct(...
   'StringOptions',{{'none','point' 'zoomin' 'zoomout' 'pan'}},...
   'Default','point');
obj.propopts.TargetFigure = struct(...
   'OtherTypeValidator',@(val)validatetargetfig(val));

obj.propopts.PanXBounded = struct(...
   'StringOptions',{{'on' 'off'}},...
   'Default','on');
obj.propopts.PanYBounded = struct(...
   'StringOptions',{{'on' 'off'}},...
   'Default','on');
obj.propopts.PointTooltipString = struct(...
   'OtherTypeValidator',{{{'char'},{'row'}}});
obj.propopts.UIReady = struct(...
   'StringOptions',{{'on','off'}});

obj.propopts.PointVisible = struct(...
   'StringOptions',{{'on' 'inactive' 'disable' 'off'}},...
   'Default','on');
obj.propopts.ZoomInVisible = struct(...
   'StringOptions',{{'on' 'inactive' 'disable' 'off'}},...
   'Default','on');
obj.propopts.ZoomOutVisible = struct(...
   'StringOptions',{{'on' 'inactive' 'disable' 'off'}},...
   'Default','on');
obj.propopts.PanVisible = struct(...
   'StringOptions',{{'on' 'inactive' 'disable' 'off'}},...
   'Default','on');

obj.propopts.ZoomButtonDownFilter = struct([]);
obj.propopts.ZoomMotion = struct([]);
obj.propopts.ZoomRightClickAction = struct([]);
obj.propopts.ZoomUIContextMenu = struct([]);
% obj.propopts.PreZoomCallback = struct([]);
% obj.propopts.PostZoomCallback = struct([]);
obj.propopts.PanButtonDownFilter = struct([]);
obj.propopts.PanMotion = struct([]);
obj.propopts.PanUIContextMenu = struct([]);
% obj.propopts.PrePanCallback = struct([]);
% obj.propopts.PostPanCallback = struct([]);

obj.sortpropopts([],false,false,true,true);

end

function tf = validatetargetfig(val)

if isa(val,'hgwrapper') && val.isattached()
   val = val.GraphicsHandle;
end

tf = ishghandle(val)&&strcmp(get(val,'Type'),'figure');

end
