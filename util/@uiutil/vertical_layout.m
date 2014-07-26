function [x0,y0] = vertical_layout(h,x0,y0,spc,halign)
% layout uicontrols H in parent handle P vertically with h(end) placed at [x0 y0]
% if h is label, its size is resized to its extent
% horizontal spacing of spc(n) is appended before each control
% halign: 'left','right','middle'. h(1) is placed atop.

N = numel(h);
if numel(spc)==1
   spc = repmat(spc,1,N);
end

set(h,'Units','pixels');
pos = cell2mat(get(h,{'Position'}));

hctrl = findobj(h,'flat','Type','uicontrol');
hlab = findobj(hctrl,'flat','Style','text');
[~,islabel] = ismember(hlab,h);
if ~isempty(islabel)
   ext = cell2mat(get(hlab,{'Extent'}));
   pos(islabel,3) = ext(:,3); % adjust text Style widths to its String extent
end

hchk = findobj(hctrl,'flat','Style','checkbox','-or','Style','radiobutton');
[~,ischeckbox] = ismember(hchk,h);
if ~isempty(ischeckbox)
   ext = cell2mat(get(hchk,{'Extent'}));
   pos(ischeckbox,3) = pos(ischeckbox,2) + ext(:,3); % adjust text Style widths to its String extent
end

% set positions up side down 
pos(:) = flipud(pos);

% set vertical locations
pos(:,2) = y0 + cumsum(spc(:)+[0;pos(1:end-1,4)]);

switch lower(halign)
   case 'left'
      pos(:,1) = x0;
   case 'center'
      Wctr = pos(:,3)/2;
      x0 = x0 + max(Wctr);
      pos(:,1) = x0 - Wctr;
   case 'right'
      Wrgt = pos(:,3);
      x0 = x0 + max(Wrgt);
      pos(:,1) = x0 - Wrgt;
end

set(h,{'Position'},mat2cell(flipud(pos),ones(N,1),4));

x0 = max(pos(:,1)+pos(:,3));
y0 = pos(end,2)+pos(end,4);

end
