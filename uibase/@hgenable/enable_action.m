function mode = enable_action(obj)
%HGENABLE/ENABLE_ACTION   (protected) Set controls according to the new Enable state
%   MODE = ENABLE_ACTION(OBJ) is called when OBJ.Enable is changed. The
%   function returns the uint8 MODE indicating the new state:
%
%      0 - 'on'
%      1 - 'off'
%      2 - 'inactive'
%
%   MODE may be useful for an overriding subclass ENABLE_ACTION
%   functions.

% Evaluate the enable state codes
val = obj.Enable;
mode = 2*uint8(val(1)=='i') + uint8(val(2)=='f');

if ~isempty(obj.hg) && obj.natively_supported
   set(obj.hg,'Enable',val);
end
