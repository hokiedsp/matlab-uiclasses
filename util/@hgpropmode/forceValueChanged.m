function forceValueChanged(obj)
%HGPROPMODE/FORCEVALUECHANGED   Manually set value changed flag
%   FORCEVALUECHANGED(OBJ) sets the internal value-changed flag so that the
%   subsequent OBJ.HASVALUECHANGED() method call will return true even if
%   the value has not been changed.

obj(~obj.hasTarget()) = []; % ignore objects without target
[obj.valchg] = deal(true);
