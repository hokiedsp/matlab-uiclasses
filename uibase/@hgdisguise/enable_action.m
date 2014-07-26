function mode = enable_action(obj)
%HGDISGUISE/ENABLE_ACTION   (protected) Set controls according to the new Enable state
%   MODE = ENABLE_ACTION(OBJ) is called when OBJ.Enable is changed. The
%   function returns the uint8 MODE indicating the new state:
%
%      0 - 'on'
%      1 - 'off'
%      2 - 'inactive'
%
%   MODE may be useful for an overriding subclass ENABLE_ACTION
%   functions.

if ~isempty(obj.hg)
   h = obj.hg;
   obj.hg = obj.hpanel;
end

mode = obj.enable_action@uipanelex();

if ~isempty(obj.hg)
   obj.hg = h;
end
