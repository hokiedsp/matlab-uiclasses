function monitor_btnsstate(obj,type,newstate,otherisena)
%ZOOMPANCTRL/MONITOR_BTNSTATE   Called whenever button state is changed
%   MONITOR_BTNSTATE(OBJ,TYPE,NEWSTATE,OTHERPROP) is called when either
%   Enable or Visible property of the button which is specified by
%   OBJ.btns(TYPE) is changed. NEWSTATE

% only act during object is enabled
if ~strcmp(obj.Enable,'on'), return; end
   
% button is active if both visible & enabled
if otherisena
   otherstate = obj.jbtns.(type).isEnabled();
else
   otherstate = strcmp(get(obj.btns.(type),'Visible'),'on');
end
newstate = newstate && otherstate;

% update the current button state (true = active)
obj.btnstates.(type) = newstate;

% if the current mode is disabled by the button state change, mode has to change
if ~strcmp(obj.CurrentMode,'none') && ~obj.btnstates.(obj.CurrentMode)
   if obj.unsel % if AllowUnselect='on', set mode to 'none'
      obj.CurrentMode = 'none';
   else
      obj.CurrentMode = obj.DefaultMode;
   end
end
