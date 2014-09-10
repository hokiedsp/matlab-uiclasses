function cfg_supportedmodes(obj)
%ZOOMPANCTRL/CFG_SUPPORTEDMODE   Configure OBJ with new set of supported modes
%   CFG_SUPPORTEDMODES(OBJ)

obj.propopts.CurrentMode.StringOptions = [{'none'},obj.SupportedModes];

try
   obj.CurrentMode = obj.CurrentMode;
catch
   obj.CurrentMode = 'none';
end
