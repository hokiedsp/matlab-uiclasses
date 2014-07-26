function layout_panel(obj)
%UIAXESARRAY/LAYOUT_PANEL   (protected) Layout panel components
%   LAYOUT_PANEL(OBJ) layouts the child objects of OBJ.hg according to the
%   current panel size.
%
%   After the UIFLOWGRIDCONTAINER layout engine completes its job, this
%   method adjusts its elements' Positions further so that the axis labels
%   (title, axis labels, and title) are within the grid cell.

obj.layout_panel@uiflowgridcontainer();

if ~(obj.inclabel && obj.isattached()) || isempty(obj.elem_h); return; end

h = obj.elem_h;
set(h,'Units','pixels'); % just in case

% evaluate group tightinsets along columns and rows of the grid
tightinsets = cell2mat(get(h,{'TightInset'}));
col_insets = eval_grpinsets(obj.map,tightinsets(:,[1 3]));
row_insets = eval_grpinsets(obj.map.',tightinsets(:,[2 4]));

% adjust axes positions according to the group tightinsets
IJ0 = obj.elem_subs;
IJ1 = IJ0 + obj.elem_span - 1;
x0inset = col_insets(IJ0(:,2),1);
y0inset = row_insets(IJ0(:,1),1);
x1inset = col_insets(IJ1(:,2),2);
y1inset = row_insets(IJ1(:,1),2);
pos = get(h,{'Position'});
pos(:) = cellfun(@(p,x0,y0,x1,y1)[p(1)+x0 p(2)+y0 p(3)-x0-x1 p(4)-y0-y1],...
   pos,x0inset,y0inset,x1inset,y1inset,'UniformOutput',false);
set(h,{'Position'},pos);

end

function grpinsets = eval_grpinsets(map,tightinsets)

sz = size(map,2);
grpinsets = cell(sz,2);

% min-end inset
I = map(:,1);
I(I==0) = []; % ignore unoccupied cell
grpinsets{1,1} = max(tightinsets(I,1));
for n = 2:sz
   I = map(:,n);
   I(I==map(:,n-1)) = []; % if spanned from left, no need to consider
   I(I==0) = []; % ignore unoccupied cell
   grpinsets{n,1} = max(tightinsets(I,1));
end

% max-end inset
for n = 1:sz-1
   I = map(:,n);
   I(I==map(:,n+1)) = []; % if spans to right, no need to consider
   I(I==0) = []; % ignore unoccupied cell
   grpinsets{n,2} = max(tightinsets(I,2));
end
I = map(:,end);
I(I==0) = []; % ignore unoccupied cell
grpinsets{end,2} = max(tightinsets(I,2));

end
