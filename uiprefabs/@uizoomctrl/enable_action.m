function mode = enable_action(obj)
%UIZOOMCTRL/ENABLE_ACTION   (protected) Set controls according to the new Enable state
%   MODE = ENABLE_ACTION(OBJ) is called when OBJ.Enable is changed. The
%   function returns the uint8 MODE indicating the new state:
%
%      0 - 'on'
%      1 - 'off'
%      2 - 'inactive'
%
%   MODE may be useful for an overriding subclass ENABLE_ACTION
%   functions.

mode = obj.enable_action@uipanelex();

ok = mode==0;

% set Enable properties of buttons
try
   obj.jbtns.pointer.setEnabled(ok && obj.btnstates.pointer);
   obj.jbtns.zoomin.setEnabled(ok && obj.btnstates.zoomin);
   obj.jbtns.zoomout.setEnabled(ok && obj.btnstates.zoomout);
   obj.jbtns.pan.setEnabled(ok && obj.btnstates.pan);
catch
end