function unlock_se(obj)
%HGLOCKABLE/UNLOCK_SE   Scalar-element lock
%   UNLOCK_SE(OBJ) unlocks an HGLOCKABLE object that is known valid and has
%   HG object attached.

set(obj.aux_h,'Value',0,'CData',obj.icons{1},'TooltipString',obj.ttstrs{1});
set(obj.hg,'Enable','on');
