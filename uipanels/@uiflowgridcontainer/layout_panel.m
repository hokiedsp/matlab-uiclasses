function layout_panel(obj)
%UIFLOWGRIDCONTAINER/LAYOUT_PANEL   (protected) Layout panel components
%   LAYOUT_PANEL(OBJ) layouts the child objects of OBJ.hg according to the
%   current panel size.

h = obj.elem_h;
if isempty(h) || ~obj.autolayout, return; end

% make sure the panel size is larger than the minimum
obj.layout_panel@uipanelautoresize();

% put all units in pixels
lisena = get(obj.content_listeners,{'Enabled'});
set(obj.content_listeners,'Enabled','off');
hg_units = get(obj.hg,'Units');
set(obj.hg,'Units','pixels');
set(h,'Units','pixels');

% adjust the top and bottom margins for uipanel's Border thickness
bmargin = uipanelex.get_bordermargins(obj.hg);
mout = obj.outmargin([1 3 2 4]);
mout(2) = mout(2) + sum(bmargin([1 2]));
mout(4) = mout(4) + sum(bmargin([3 4]));

% determine the grid structure including object visibility
[col_wlims,row_hlims,Ivis,subs] = obj.format_grid();

try
   % compute the column widths and row heights
   pos = get(obj.hg,'Position');
   [X0,Wcol] = layout_grid(size(col_wlims,1),col_wlims,obj.hweight,pos(3),obj.inmargin(1),mout([1 2]));
   [Y0,Hrow] = layout_grid(size(row_hlims,1),row_hlims,obj.vweight,pos(4),obj.inmargin(2),mout([4 3]));
   
   % record the excess space on the panel
   dX = (pos(3) - X0(end));
   dY = (pos(4) - Y0(end));
   
   % flip y-axis up-side down
   X0 = X0(1:end-1) + 1;
   Y0 = Y0(end)-Y0(1:end-1)-Hrow + 1; % reverse for the difference in indexing (bottomup vs topdown)
   
   switch obj.halign
      case 2 % center
         X0(:) = X0 + dX/2;
      case 3 % right
         X0(:) = X0 + dX;
   end
   
   switch obj.valign
      case 2 % middle
         Y0(:) = Y0 + dY/2;
      case 3 % top
         Y0(:) = Y0 + dY;
   end
      
   % set positions of each element
   for n = Ivis.'
      subs0 = subs(n,:);
      span = obj.elem_span(n,:)-1;
      subs1 = subs0 + span;
      
      x0 = X0(subs0(2)); % default left aligned
      y0 = Y0(subs0(1)+span(1)); % default bottom aligned
      
      wcol = sum(Wcol(subs0(2):subs1(2)))+obj.inmargin(1)*span(2);
      hrow = sum(Hrow(subs0(1):subs1(1)))+obj.inmargin(2)*span(1);
      wd = min(wcol,obj.elem_wlims(n,2));
      ht = min(hrow,obj.elem_hlims(n,2));
      
      switch obj.elem_halign(n)
         case 1 %'left'
            pos(1) = x0;
         case 2 %'center'
            pos(1) = x0 + (wcol-wd)/2;
         otherwise %'right'
            pos(1) = x0 + wcol - wd;
      end

      switch obj.elem_valign(n)
         case 1 %'bottom'
            pos(2) = y0;
         case 2 %'middle'
            pos(2) = y0 + (hrow-ht)/2;
         otherwise %'top'
            pos(2) = y0 + hrow-ht;
      end
      pos(3) = wd;
      pos(4) = ht;
      
      set(h(n),'Position',pos);
   end
   
catch ME
   % revert the units to their original
   set(obj.hg,'Units','pixels');
   set(h,'Units','pixels');
   set(obj.content_listeners,{'Enabled'},lisena);
   ME.rethrow();
end

% revert the units to their original
set(obj.hg,'Units',hg_units);
set(obj.content_listeners,{'Enabled'},lisena);

end

function [d_origin,d_size] = layout_grid(N,lims,weight,total,inmargin,outmargin)
%layout_grid(map,elem_lims,total,margin,autosize)
%   map - size==gridsize, cell occupied by indexed element
%   lims - [min max] of each grid cell
%   total - total available space
%   margin - margin between elements & borders
%   autosize - true if distribute cells

total = total - (N-1)*inmargin - sum(outmargin);
if sum(lims(:,1))>=total % panel too small, let it overflow
   d_size = lims(:,1);
elseif sum(lims(:,2))<=total % too much room, max size
   d_size = lims(:,2);
else % somewhere in between
   d_size = total*weight/sum(weight);
   I2small = d_size<lims(:,1);
   I2big = d_size>lims(:,2); % check if any cell is larger than its max
   I = (I2small|I2big);
   while any(I)
      % violating member to their max
      d_size(I2small) = lims(I2small,1);
      d_size(I2big) = lims(I2big,2);
      total = total - sum(d_size(I));
      
      % distribute the excess among the non-violating members
      I(:) = ~I;
      w = weight(I);
      d_size(I) = total*w/sum(w);
      
      I2small = d_size<lims(:,1);
      I2big = d_size>lims(:,2); % check if any cell is larger than its max
      I = I2small|I2big;
   end
end

d_origin = cumsum([0;d_size+inmargin])+outmargin(1);
d_origin(end) = d_origin(end)-(inmargin-outmargin(2));

end
