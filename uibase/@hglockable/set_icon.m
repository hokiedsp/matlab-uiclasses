function set_icon(obj,I,val)
%HGLOCKABLE/SET_ICON   Set lock icons
%   SET_ICON(OBJ,I,VAL) sets OBJ's lock icons to VAL in unlocked position
%   if I=1 and in locked position if I=2. If VAL is empty, icon is set to
%   the default.

if isempty(val)
   if I==1
      pngname = 'lock-unlock.png';
   else
      pngname = 'lock.png';
   end
	obj.icons{I} = uiutil.getDefaultToolbarIcon(pngname);
else
   obj.icons{I} = val;
end

% update the icon size
obj.aux_size(2) = max(cellfun(@(c)size(c,1),obj.icons))+4;
obj.aux_size(1) = max(cellfun(@(c)size(c,2),obj.icons))+4;

% re-layout
obj.layout_panel();
