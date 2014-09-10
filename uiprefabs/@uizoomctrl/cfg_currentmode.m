function cfg_currentmode(obj,newmode)
%UIZOOMCTRL/MODECHANGE   Changing CurrentMode
%   CFG_CURRENTMODE(OBJ,NEWMODE) is executed during OBJ.set.CurrentMode
%   after NEWMODE is validated but before OBJ.CurrentMode is updated.

% configure zoom & pan objects accordingly
obj.cfg_currentmode@zoompanctrl(newmode);

% pop previous button
if ~strcmp(obj.CurrentMode,'none')
   try
      obj.jbtns.(obj.CurrentMode).setSelected(false);
   catch
   end
end

% set current button
if ~strcmp(newmode,'none')
   try
      obj.jbtns.(newmode).setSelected(true);
   catch
   end
end
