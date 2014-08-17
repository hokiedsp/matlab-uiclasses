function btnscallback(obj,idx)
%UIZOOMCTRL/BTNSCALLBACK   Callback function executed when clicked on a button
% both obj & idx are assumed to be scalar

state = get(obj.jbtns(idx),'Selected');

if state % depressed
   newmode = idx;
else % released
   if obj.unsel % unselect allowed
      newmode = 0;
   else % cannot be unselected
      newmode = obj.mode;
      %set(h,'Value',~state); % depress
      obj.jbtns(newmode).setSelected(~state);
   end
end

changed = obj.mode~=newmode;

% update the mode accordingly
obj.modechange(newmode);

% call user callback if mode is changed & callback is defined
if changed
   notify(obj,'ModeChanged');
end
