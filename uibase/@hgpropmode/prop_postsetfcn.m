function prop_postsetfcn(obj)
%HGPROPMODE/PROP_POSTSETFCN   Property PostSet event callback
%   PROP_POSTSETFCN(OBJ) sets the value changed flag.

obj.valchg = true;
