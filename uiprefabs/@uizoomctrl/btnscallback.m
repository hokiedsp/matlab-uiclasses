function btnscallback(obj,name)
%UIZOOMCTRL/BTNSCALLBACK   Callback function executed when clicked on a button
% both obj & idx are assumed to be scalar

if ~obj.jbtns.(name).isSelected() % released
   if obj.unsel % unselect allowed
      name = 'none';
   else % cannot be unselected, pick another
      name = obj.DefaultMode;
      obj.jbtns.(name).setSelected(true);
   end
end

% call user callback if mode is changed & callback is defined
changed = ~strcmp(obj.CurrentMode,name);
if changed
   obj.CurrentMode = name;
   notify(obj,'ModeChanged');
end
