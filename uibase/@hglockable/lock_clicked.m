function lock_clicked(obj)
%HGLOCKABLE/LOCK_CLICKED   Callback function on lock checkbox
%   LOCK_CLICKED(OBJ)

if get(obj.aux_h,'Value')
   obj.lock_se();
   obj.notify('HgIsLocked');
else
   obj.unlock_se();
   obj.notify('HgIsUnlocked');
end
