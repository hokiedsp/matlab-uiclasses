function lock_se(obj)
%HGLOCKABLE/LOCK_SE   Scalar-element lock
%   LOCK_SE(OBJ) locks an HGLOCKABLE object that is known valid and has HG
%   object attached.

set(obj.aux_h,'Value',1','CData',obj.icons{2},'TooltipString',obj.ttstrs{2});
if ~isempty(obj.ena_mode)
   set(obj.hg,'Enable',obj.ena_mode);
end
   
