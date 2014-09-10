function setpanelsize(obj) % set uipanel size
% fix panel size
u = get(obj.hg,'Units');
set(obj.hg,'Units','pixels');
pos = get(obj.hg,'Position');
set(obj.hg,'Position',[pos([1 2]) obj.panelsize],'Units',u);
