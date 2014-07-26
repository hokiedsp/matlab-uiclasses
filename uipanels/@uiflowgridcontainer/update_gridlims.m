function update_gridlims(obj)
%UIFLOWGRIDCONTAINER/UPDATE_GRIDLIMS
%   UPDATE_GRIDLIMS(OBJ) shall be called from UPDATE_GRID(OBJ) and also
%   when the ElementsWidthLimits or ElementsHeightLimits property is
%   changed. UPDATE_GRIDLIMS updates OBJ.col_wlims and OBJ.row_hlims
%   private property, which carries the minimum and maximum widths and
%   heights of columns and rows of the grid, respectively.

if isempty(obj.elem_h), return; end

% Recompute the grids' column width and row height limits
obj.col_wlims = layout_grid(obj.map,obj.elem_span(:,2),obj.elem_wlims,obj.inmargin(1));
obj.row_hlims = layout_grid(obj.map.',obj.elem_span(:,1),obj.elem_hlims,obj.inmargin(2));

% done, now run layout
obj.layout_panel();

end

function dlim = layout_grid(map,elem_span,elem_lims,margin)
%layout_grid(map,elem_span,elem_lims,inmargin,outmargin)
%   map - size==gridsize, cell occupied by indexed element
%   elem_span - number of cells
%   elem_lims - [min max]
%   inmargin - margin among elements
%   outmargin - margin between elements & borders

N = size(map,2); % # of cells
Nel = size(elem_span,1); % # of elements

% determine the minimum & maximum margins of the non-spanning cells
dmin = zeros(1,N); % maximum minimum length
dmax = zeros(1,N);   % minimum maximum length

% reorder elements in the increasing # of spans
[elem_span,I] = sort(elem_span);
elem_lims(:) = elem_lims(I,:);

i1 = find(elem_span>1,1,'first');
if isempty(i1), i1 = Nel+1; end
for n = 1:i1-1 % for each element without spanning
   
   loc = find(any(map==n,1));
   dmin(loc) = max(dmin(loc),elem_lims(n,1));
   %dmax(loc) = min(dmax(loc),elem_lims(n,2));
   dmax(loc) = max(dmax(loc),elem_lims(n,2));
end
for n = i1:Nel % for each element with cell spanning
   
   % reduce the element limits by the total margin size between cells
   elem_lims(n,:) = elem_lims(n,:) - margin*(elem_span(n)-1);
   
   loc = find(any(map==n,1));
   dmin_n = dmin(loc);
   dspan_min = sum(dmin_n);
   if elem_lims(n,1) > dspan_min % takes more length than current minimum
      
      for i = loc % for each grid position
         % check if min of the current position + max of the other
         % positions is still more than the spanned minimum.
         d = dmin_n;
         d(i) = [];
         dsum = sum(d);
         if dmin_n(i)+dsum<elem_lims(n,1)
            dmin_n(i) = elem_lims(n,1)-dsum; % if so, record the element min - sum of other maxes
         end
      end
      dmin(loc) = dmin_n;
   end
   
   dmax_n = dmax(loc);
   dspan_max = sum(dmax_n);
   if elem_lims(n,2) < dspan_max % takes less length than current maximum
      % check the condition for each grid
      for i = loc % for each grid position (over which the cell element spans)
         d = dmin_n;
         d(i) = [];
         dsum = sum(d);
         if dmax_n(i)+dsum>elem_lims(n,2)
            dmax_n(i) = elem_lims(n,2)-dsum;
         end
      end
      dmax(loc) = dmax_n;
   end
end

dlim = [dmin(:) dmax(:)];

end
