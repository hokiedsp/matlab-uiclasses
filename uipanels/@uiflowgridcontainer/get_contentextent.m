function val = get_contentextent(obj,h)
%UIFLOWGRIDCONTAINER/GET_CONTENTEXTENT   Returns size of panel content
%   POS = GET_CONTENTEXTENT(OBJ) returns a position rectangle indicating
%   the tightest rectangle encompassing panel's child objects. POS is a
%   four-element vector that defines the size and position, and has the
%   form:
% 
%      [x0,y0,width,height]
%
%   (x0,y0) is the location of the lower-left-hand corner of the lowest and
%   left-most child. width and height are the dimensions of the rectangle.
%   All measurements are in units specified by the panel's Units property.
%
%   POS = GET_CONTENTEXTENT(OBJ,H) finds the tightest rectangle
%   encompassing the objects in H.

full = nargin<2;

if isempty(obj.elem_h)
   val = [];
   return;
end

% determine the grid structure including object visibility
[col_wlims,row_hlims,Ivis,subs] = obj.format_grid();
if isempty(col_wlims)
   val = [0 0 0 0];
   return;
end

if full
   ncol = size(col_wlims,1);
   nrow = size(row_hlims,1);
else
   % determine which columns and rows h occupies
   [~,I] = intersect(obj.elem_h,h);
   I = intersect(I,Ivis);
   
   melem = subs(I,1); % rows
   m = [min(melem) max(melem)];
   row_hlims = row_hlims(m(1):m(2));
   nrow = diff(m)+1;

   nelem = subs(I,2); % columns
   n = [min(nelem) max(nelem)];
   col_wlims = col_wlims(n(1):n(2));
   ncol = diff(n)+1;
end

% set panel to the minimum size temporarily
rfcn = get(obj,'ResizeFcn');
set(obj,'ResizeFcn',[]);
set(obj.hg_listener,'Enabled','off');
al = obj.autolayout;
obj.autolayout = false;

% save the Position & Units
mout = obj.outmargin([1 3 2 4]) + uipanelex.get_bordermargins(obj.hg);

% get minimum pixels panel size to fit all subpanels
Wmin = sum(col_wlims(:,1)) + sum(mout([1 2])) + obj.inmargin(1)*(ncol-1);
Hmin = sum(row_hlims(:,1)) + sum(mout([3 4])) + obj.inmargin(2)*(nrow-1);

% set uiflowcontainer to the size and get the position
props = get(obj.hg,{'Units','Position'});
set(obj.hg,'Units','pixels','Position',[1 1 Wmin Hmin],'Units',props{1});
val = get(obj.hg,'Position');
set(obj.hg,'Position',props{2});
obj.autolayout = al;

% reenable listeners
obj.autolayout = al;
set(obj.hg_listener,'Enabled','on');
set(obj,'ResizeFcn',rfcn);

