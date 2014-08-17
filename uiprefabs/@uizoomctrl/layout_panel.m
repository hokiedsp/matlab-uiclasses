function layout_panel(obj)
%UIZOOMCTRL/LAYOUTUI
%   LAYOUTUI(OBJ)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~obj.isattached(), return; end

if isempty(obj.btns)   % one-time initialization
   obj.javainit(); % calls layoutui again within if success
   if isempty(obj.btns), return; end % exit if buttons are not yet constructed
end

% Check visible condition of the buttons
vis = strcmp(get(obj.btns,'Visible'),'on');

% compute the horizontal button positions and the minimum width of the uipanel
Nbtns = sum(vis);
sz = obj.panelsize(2);
x0 = cumsum([0;repmat(sz,Nbtns,1)]);
pos = mat2cell([x0(1:end-1) repmat([0 sz sz],Nbtns,1)],ones(Nbtns,1),4);
if x0(end)==0
   obj.panelsize(1) = sz;
else
   obj.panelsize(1) = x0(end);
end

% set buttons
set(obj.btns(vis),{'Position'},pos);

% fix panel size
obj.setpanelsize();
