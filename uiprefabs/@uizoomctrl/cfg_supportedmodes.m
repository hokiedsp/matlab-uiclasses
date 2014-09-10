function cfg_supportedmodes(obj)
%ZOOMPANCTRL/CFG_SUPPORTEDMODE   Configure OBJ with new set of supported modes
%   CFG_SUPPORTEDMODES(OBJ) is called after obj.SupportedMode is updated in
%   set.SupportedMode

obj.cfg_supportedmodes@zoompanctrl();

% update DefaultMode if it is no longer available in supported modes
obj.propopts.DefaultMode.StringOptions = obj.SupportedModes;
if ~any(strcmp(obj.DefaultMode,obj.SupportedModes))
   obj.DefaultMode = obj.SupportedModes{1};
end
