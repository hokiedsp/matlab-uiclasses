function set_txloc(obj,newtxloc)
%UIVIDEOVIEWER/SET_TXLOC   Set CounterLocation
%   SET_TXLOC(OBJ)
%   SET_TXLOC(OBJ,NEWTXLOC) - NEWTXLOC given in 1-base index
%
%   TXLOC value translation sheet
%   code location     x=txloc-3y  y=floor(txloc/3)
%   ----------------------------------------------
%     0  'northwest'  0/'west'    0/'north'
%     1  'north'      1/'center'  0/'north'
%     2  'northeast'  2/'east'    0/'north'
%     3  'west'       0/'west'    1/'middle'
%     4  'none'       1/'center'  1/'middle'
%     5  'east'       2/'east'    1/'middle'
%     6  'southwest'  0/'west'    2/'south'
%     7  'south'      1/'center'  2/'south'
%     8  'southeast'  2/'east'    2/'south'

if nargin>1
   obj.txloc = newtxloc;
end

if obj.txloc==4
   set(obj.tx,'Visible','off');
else
   y = floor(obj.txloc/3);
   x = obj.txloc-3*y;
   pos = zeros(1,2);
   switch x
      case 0 % east
         pos(1) = 0.01;
         ha = 'left';
      case 1 % middle
         pos(1) = 0.5;
         ha = 'center';
      case 2 % west
         pos(1) = 0.99;
         ha = 'right';
   end
   switch y
      case 0 % north
         pos(2) = 0.99;
         va = 'top';
      case 1 % middle
         pos(2) = 0.5;
         va = 'middle';
      case 2 % south
         pos(2) = 0.01;
         va = 'bottom';
   end
   set(obj.tx,'Visible','on','Position',pos,'HorizontalAlignment',ha,...
      'VerticalAlignment',va);
end
