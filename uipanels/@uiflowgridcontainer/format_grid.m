function [col_wlims,row_hlims,Ivis,subs] = format_grid(obj)

% determine object visibility
N = numel(obj.elem_h);
Ivis = false(N,1);
[hgw,I] = hgwrapper.findobj(obj.elem_h);
Ivis(I) = strcmp(get(hgw,'Visible'),'on');
I = setdiff(1:N,I);
Ivis(I) = strcmp(get(obj.elem_h(I),'Visible'),'on');
if ~any(Ivis)
   Ivis = [];
   col_wlims = [];
   row_hlims = [];
   subs = [];
   return;
end % if nothing visible, nothing to do
map = obj.map;
map(ismember(map,find(~Ivis))) = 0; % ignore hidden element

subs = obj.elem_subs;
subs(~Ivis,:) = 0;

if obj.elimempty
   % check and remove empty columns
   Icol = any(map,1);
   map(:,~Icol) = [];
   
   % check and remove empty rows
   Irow = any(map,2);
   map(~Irow,:) = [];
   
   % update element cell subscripts
   [~,subs(Ivis,1)] = ismember(subs(Ivis,1),find(Irow));
   [~,subs(Ivis,2)] = ismember(subs(Ivis,2),find(Icol));
end

% Recompute the grids' column width and row height limits
col_wlims = layout_gridlims(map,obj.elem_span(:,2),obj.elem_wlims,obj.inmargin(1));
row_hlims = layout_gridlims(map.',obj.elem_span(:,1),obj.elem_hlims,obj.inmargin(2));

Ivis = find(Ivis);

end

function dlim = layout_gridlims(map,elem_span,elem_lims,margin)
%layout_gridlims(map,elem_span,elem_lims,inmargin,outmargin)
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
   
   loc = find(any(map==I(n),1)); % return the column index of the cell
   dmin(loc) = max(dmin(loc),elem_lims(n,1));
   %dmax(loc) = min(dmax(loc),elem_lims(n,2));
   dmax(loc) = max(dmax(loc),elem_lims(n,2));
end
for n = i1:Nel % for each element with cell spanning
   
   % reduce the element limits by the total margin size between cells
   elem_lims(n,:) = elem_lims(n,:) - margin*(elem_span(n)-1);
   
   loc = find(any(map==I(n),1));
   dmin_n = dmin(loc); % current minimum size for the spanned columns/rows
   dspan_min = sum(dmin_n); % total minimum size spanned over the columns/rows
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
         dsum = sum(d); % minimum span w/o i-th row/col
         if dmax_n(i)+dsum < elem_lims(n,2) % more rooms available than required for the element
            dmax_n(i) = elem_lims(n,2)-dsum;
         end
      end
      dmax(loc) = min(dmax(loc),dmax_n);
   end
end

dmax(dmax==0) = inf; % zero means no element
dlim = [dmin(:) dmax(:)];

end
