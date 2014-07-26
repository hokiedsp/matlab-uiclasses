function val = get_autodetach(obj)
%HGWRAPPER/GET_AUTODETACH   Implements get.AutoDetach
%   VAL = GET_AUTODETACH(OBJ) returns the index to
%   OBJ.propopts.AutoDetach.OptionStrings that reflects current OBJ setting

% Assumes that OptionStrings is {'on' 'off'}
val = 2-obj.autodetach;
