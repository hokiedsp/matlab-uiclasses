function layout_panel(obj)
%HGANDLABELS/LAYOUT_PANEL   (protected) Layout panel components
%   LAYOUT_PANEL(OBJ) layouts the child objects of OBJ.hg according to the
%   current panel size.

if ~obj.autolayout || isempty(obj.hg) || any(obj.totallims(:)<=0), return; end

% turn off the content listeners
lisena = get(obj.hg_listener,{'Enabled'});
set(obj.hg_listener,'Enabled','off');

% get container size
u = get(obj.hpanel,'Units');
set(obj.hg,'Units','pixels');
set(obj.hpanel,'Units','pixels');
set(obj.labels_h,'Units','pixels');

% get the display area size
posp = get(obj.hpanel,'Position');
sz = min(max(posp([3 4]),obj.totallims(1,:)),obj.totallims(2,:));

szhg = sz - obj.hgmargin([1 2]) - obj.hgmargin([3 4]);

% get the label position info
posl = obj.pos_labels;
posl(:,[1 2]) = posl(:,[1 2]) + bsxfun(@times,obj.mult,szhg);

origin = 1+obj.hgmargin([1 2]);
posl(:,[1 2]) = bsxfun(@plus,origin,posl(:,[1 2]));

N = numel(obj.labels_h);
set(obj.labels_h,{'Position'},mat2cell(posl,ones(N,1),4));

pos = [origin szhg];
set(obj.hg,'Position',pos);

% revert the unit
set(obj.hpanel,'Units',u);

% turn back on the listeners
set(obj.hg_listener,{'Enabled'},lisena);
