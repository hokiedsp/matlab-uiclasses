function [y0,x0] = horizontal_layout(h,x0,y0,spc,valign)
% layout uicontrols H in parent handle P horizontally starting at [x0 y0]
% if h is label, its size is resized to its extent
% horizontal spacing of spc(n) is appended before each control
% valign: 'top','middle','bottom'

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

pos(:,1) = x0 + cumsum(spc(:)+[0;pos(1:end-1,3)]);

switch lower(valign)
   case 'bottom'
      pos(:,2) = y0;
   case 'middle'
      Hmid = pos(:,4)/2;
      y0 = y0 + max(Hmid);
      pos(:,2) = y0 - Hmid;
   case 'top'
      Htop = pos(:,4);
      y0 = y0 + max(Htop);
      pos(:,2) = y0 - Htop;
end

set(h,{'Position'},mat2cell(pos,ones(N,1),4));

y0 = max(pos(:,2)+pos(:,4));
x0 = pos(end,1)+pos(end,3);

end
