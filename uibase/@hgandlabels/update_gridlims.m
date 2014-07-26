function update_gridlims(obj)
%HGANDLABELS/UPDATE_GRIDLIMS

obj.pos_labels = zeros(0,4);
obj.hgmargin = [0 0 0 0]; % [left bottom right top]
obj.totallims = zeros(2);

if ~obj.isattached(), return; end

if isempty(obj.labels_h), return; end

% current label sizes
set(obj.labels_h,'Units','pixels');
pos_labels = cell2mat(get(obj.labels_h,{'Extent'}));

% determine the label positions w.r.t. obj.hg
%    assuming obj.hg Position = [0 0 0 0]
loc = obj.labels_layout(:,1);
mH = obj.labels_margin; % margin applied in the horizontal direction
mH(loc>2) = 0;
idx = loc==1;
mH(idx) = -mH(idx);
mV = obj.labels_margin; % margin applied in the vertical direction
mV(loc<3) = 0;
idx = loc==3;
mV(idx) = -mV(idx);

hmult = (obj.labels_layout(:,2)-1)/2;
vmult = (obj.labels_layout(:,3)-1)/2;
pos_labels(:,1) = mH - hmult .* pos_labels(:,3);
pos_labels(:,2) = mV - vmult .* pos_labels(:,4);

obj.pos_labels = pos_labels;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% only labels on the left influences the left margin
idx = loc==1;
pos = pos_labels(idx,:);
if ~isempty(pos)
   obj.hgmargin(1) = min(mH(idx) + hmult(idx).*pos(:,3));
end

% only labels below influecnces the bottom margin
idx = loc==3;
pos = pos_labels(idx,:);
if ~isempty(pos)
   obj.hgmargin(2) = min(mV(idx) + vmult(idx).*pos(:,4));
end

% only labels on the right influences the right margin
idx = loc==2;
pos = pos_labels(idx,:);
if ~isempty(pos)
   obj.hgmargin(3) = max(mH(idx) + (1-hmult(idx)).*pos(:,3));
end

% only labels above influences the top margin
idx = loc==4;
pos = pos_labels(idx,:);
if ~isempty(pos)
   obj.hgmargin(4) = max(mV(idx) + (1-vmult(idx)).*pos(:,4));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% adjust hmult & vmult to be used wtih HG size
hmult(loc==1) = 0; % left
hmult(loc==2) = 1; % right
vmult(loc==3) = 0; % bottom
vmult(loc==4) = 1; % top

obj.mult = [hmult vmult];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lims = [obj.HgWidthLimits(:) obj.HgHeightLimits(:)];
for n = 1:2 % [min max]
   pos = pos_labels;
   pos(:,[1 2]) = pos(:,[1 2]) + bsxfun(@times,obj.mult,lims(n,:)); % adjust controls above or to the right of hg
   llc = min(min(pos(:,[1 2]),[],1),[0 0]);
   urc = max(max(pos(:,[1 2])+pos(:,[3 4]),[],1),lims(n,:));
   obj.totallims(n,:) = urc - llc;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj.layout_panel();
