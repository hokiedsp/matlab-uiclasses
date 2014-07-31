function set_elementsnames(obj,names)
%UIBUTTONGROUPEX/SET_ELEMENTSNAMES   Specify the button elements
%   SET_ELEMENTSNAMES(OBJ,NAMES) sets ElementsNames to the specified NAMES.
%   The GridSize is adjusted to match the size of NAMES, and the grid cells
%   with empty NAMES strings are left unoccupied. If the number of Elements
%   do not match, either more Elements are added according to
%   DefaultElementStyle or excess Elements are removed.

% defer layout
al = obj.autolayout;
obj.autolayout = false;

% set grid size
gridsize = size(names);

% figure out the # of controls needed
I = ~cellfun(@isempty,names(:));
N = sum(I); % # of elements needed
Nh = numel(obj.elem_h); % # of existing elements

% remove excess elements
obj.removeElement(obj.elem_h(N+1:Nh),'delete');

% get the grid location subscripts of the new elements
[subs(:,1),subs(:,2)] = ind2sub(gridsize,find(I));

% set existing buttons within the new grid size & set the grid size
obj.elem_span(:) = 1;
obj.elem_subs = subs(1:Nh,:);
obj.gridsize = gridsize;

% sort elem_h according to the Children order (just in case)
[obj.elem_h,~,I] = intersect(handle(get(obj.hg,'Children')),obj.elem_h,'stable');
obj.elem_subs = obj.elem_subs(I,:);
obj.elem_span = obj.elem_span(I,:);
obj.elem_wlims = obj.elem_wlims(I,:);
obj.elem_hlims = obj.elem_hlims(I,:);
obj.elem_halign = obj.elem_halign(I);
obj.elem_valign = obj.elem_valign(I);
Nh = numel(I);

% make sure they are all of the defaultbutton style
set(obj.elem_h,'Style',obj.defaultbutton);

% add (immediately triggers register_element())
try % for <R2014a, only uicontrol with double handle can be properly added to uibuttongroup
   p = double(obj.hg);
catch
   p = obj.hg;
end

for n = Nh+1:N
   uicontrol('Parent',p,'Style',obj.defaultbutton);
end

h = obj.elem_h;

% set the button names
set(h,{'String'},names(:));

% auto-adjust button sizes according to their text extents
pos = cell2mat(get(h,{'Extent'}));
if all(pos(:,3)~=0 & pos(:,4)~=0)
   if strcmp(obj.defaultbutton,'radiobutton')
      pos(:,3) = pos(:,3) + pos(:,4);
   else
      % common size, use the maximum size
      pos(:,3) = max(pos(:,3) + pos(:,4));
      pos(:,4) = max(pos(:,4) + pos(:,4));
   end
   set(h,{'Position'},mat2cell(pos,ones(N,1),4));
   obj.elem_wlims = pos(:,[3 3]);
   obj.elem_hlims = pos(:,[4 4]);
end

% revert auto-layoutmode
obj.autolayout = al;

% update the grid
obj.update_grid();

% fit the panel to the buttons
set(obj,'Units','pixels');
set(obj,'Position',obj.Extent);
