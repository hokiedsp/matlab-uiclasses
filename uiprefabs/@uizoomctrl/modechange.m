function modechange(obj,newmode)
%UIZOOMCTRL/MODECHANGE   Callback function executed when clicked on a button
% newmode = scalar value between 0-4

btnsready = ~isempty(obj.btns);

% pop the button for the previous mode
if obj.mode>0 && btnsready
   obj.jbtns(obj.mode).setSelected(false);
end

% turn off the current mode
switch obj.mode
   case {2 3}
      zoom(obj.fig,'off');
   case 4
      pan(obj.fig,'off');
end

% depress the button
if newmode>0 && btnsready
   obj.jbtns(newmode).setSelected(true);
end

% assign the new mode
obj.mode = newmode;

% turn on the new mode
switch newmode
   case 2
      obj.zoom.Direction = 'in';
      zoom(obj.fig,'on');
   case 3
      obj.zoom.Direction = 'out';
      zoom(obj.fig,'on');
   case 4
      pan(obj.fig,'on');
end
