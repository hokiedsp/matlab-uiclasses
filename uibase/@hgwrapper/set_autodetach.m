function set_autodetach(obj,val)
%HGWRAPPER/SET_AUTODETACH   Implements set.AutoDetach
%   SET_AUTODETACH(OBJ,VAL) sets obj.autodetach according to the given
%   index to OBJ.propopts.AutoDetach.OptionStrings

% assume OBJ.propopts.AutoDetach.OptionStrings = {'on' 'off'}
obj.autodetach = logical(2-val);
