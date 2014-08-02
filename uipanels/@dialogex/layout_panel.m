function layout_panel(obj)
%UIPANELEX/LAYOUT_PANEL   (protected) Layout panel components
%   LAYOUT_PANEL(OBJ) layouts the child objects of OBJ.hg according to the
%   current panel size.

if isempty(obj.hg) || ~obj.autolayout, return; end

% make sure the MinimumPanelSize is met
obj.layout_panel@uipanelautoresize(); 

set(obj.hg,'Units','pixels');
set(obj.ContentPanel,'Units','pixels');
set(obj.pnButtonBox,'Units','pixels');

% figure size
pos = get(obj.hg,'Position');

if strcmp(get(obj.pnButtonBox,'Visible'),'off')
   pos([1 2]) = 1; % contentbox covers the entire figure
else
   % set the button box (horizontali alignment handled by the uiflowgridcontainer
   sz = get(obj.pnButtonBox,'Position'); sz([1 2]) = [];
   align = obj.ButtonBoxAlignment(1); % 'l','c','r'
   if any(align=='cr')
      x0 = (pos(3)-sz(1));
      if align=='c'
         x0 = x0/2;
      end
      x0 = x0 + 1;
   else
      x0 = 1;
   end
   set(obj.pnButtonBox,'Position',[x0 1 sz]);
   
   % get the contentbox position
   pos(1) = 1;
   pos(2) = 1+sz(2);
   pos(4) = pos(4)-sz(2);
end

% set the contentbox position
pos([3 4]) = max(pos([3 4]),[1 1]);
set(obj.ContentPanel,'Position',pos);
