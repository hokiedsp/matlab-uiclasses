function sync_subpanelunits(obj,h,val)
%UIPANELGROUP/SYNC_SUBPANELUNITS synchronize Units of obj.hpanels
%   SYNC_SUBPANELUNITS(OBJ,H,VAL) 

hpanels = handle(get(obj.hg,'Children'));
hothers = hpanels(hpanels~=h);
set(hothers,'Units',val);
