function newmode = cfg_currentmode(obj,newmode)
%UIZOOMCTRL/MODECHANGE   Changing CurrentMode
%   CFG_CURRENTMODE(OBJ,NEWMODE) 

% turn off the current mode
try
   switch obj.CurrentMode
      case {'zoomin','zoomout'}
         zoom(obj.TargetFigure,'off');
      case 'pan'
         pan(obj.TargetFigure,'off');
   end
catch
end

% turn on the new mode
try
   switch newmode
      case 'zoomin'
         obj.zoom.Direction = 'in';
         zoom(obj.TargetFigure,'on');
      case 'zoomout'
         obj.zoom.Direction = 'out';
         zoom(obj.TargetFigure,'on');
      case 'pan'
         pan(obj.TargetFigure,'on');
   end
catch
end
