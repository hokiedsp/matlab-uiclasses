function I = addLabel(obj,str,varargin)
%HGANDLABELS/ADDLABEL   Add label
%   ADD(OBJ,STR) adds a new label with string STR to a scalar
%   HGANDLABELS object OBJ. If H must be supported panel type.
%
%   ADD(OBJ,STR,'ElementProp1Name',ElementProp1Value,...) to set
%   additional label properties:
%
%      HorizontalAlignment: ['left'|{'center'}|'right'] horizontal
%         alignment of the label. Only relevant if Location = 'top' or
%         'bottom.'
%      Interpreter: [{'none'}|'latex'|'tex'] sets text interpreter. If
%         Interpreter = 'latex' or 'tex', label is displayed on an axes text.
%      Margin: [non-negative scalar] space between label origin and the
%         nearest HG object edge (default: 2)
%      Location: [{'left'}|'top'|'right'|'bottom'] location of the label
%         with respect to the HG object.
%      VerticalAlignment: ['bottom'|{'middle'}|'top'] vertical alignemnt
%         of the label. Only relevant if Location = 'left' or 'right.'

narginchk(2,inf);
if ~isscalar(obj)
   error('OBJ must be a scalar HGANDLABELS object.');
end
if isempty(obj.hg)
   error('OBJ must be attached to an HG object.');
end

if ischar(str) && isrow(str)
   str = cellstr(str);
elseif ~(iscellstr(str) && all(cellfun(@isrow,str)))
   error('STR must be either a string or a cellstr array');
end

% turn off the layout until all done
al = obj.autolayout;
obj.autolayout = false;

% create new control
I0 = numel(obj.labels_h);
Nadd = numel(str);
I = (I0+1):(I0+Nadd);
for n = 1:Nadd
   h = handle(uicontrol('Parent',obj.hpanel,'Style','text',...
      'String',str{n},'BackgroundColor',get(obj.hpanel,'BackgroundColor'),...
      'HorizontalAlignment','left'));
   obj.labels_h(I(n),1) = h;
   
   % set listeners on uicontrol property which may affect its Extent property
   obj.content_listeners(end+1) = addlistener(h,'String','PostSet',@(~,~)obj.update_gridlims());
   obj.content_listeners(end+1) = addlistener(h,'FontAngle','PostSet',@(~,~)obj.update_gridlims());
   obj.content_listeners(end+1) = addlistener(h,'FontWeight','PostSet',@(~,~)obj.update_gridlims());
   obj.content_listeners(end+1) = addlistener(h,'FontSize','PostSet',@(~,~)obj.update_gridlims());
   obj.content_listeners(end+1) = addlistener(h,'FontUnits','PostSet',@(~,~)obj.update_gridlims());
end

% set label properties to the default
obj.labels_htext(I,1) = {[]};    % text handle for tex/latex text interpreter support
obj.labels_margin(I,1) = 2;   % space from the origin of the leading label to the nearest edge of the HG
obj.labels_interpreter(I,1) = 1;

% determine the next unused default layout positions
layout_order = [
   1 3 2 % west|right|middle
   2 1 2 % east|left|middle
   3 1 3 % north|left|bottom
   4 3 1 % south|right|top
   1 3 1 % west|right|top
   2 1 1 % east|left|top
   3 2 3 % north|center|bottom
   4 2 1 % south|center|top
   1 3 3 % west|right|bottom
   2 1 3 % east|left|bottom
   3 3 3 % north|right|bottom
   4 1 1 % south|left|top
];

layouts = setdiff(layout_order,obj.labels_layout,'rows','stable');
Nlo = size(layouts,1);
if Nlo<Nadd
   layouts((Nlo+1):Nadd,:) = repmat(layout_order(1,:),Nadd-Nlo,1);
end
obj.labels_layout(I,:) = layouts(1:Nadd,:);      % location of leading label {}

% set properties
if nargin>2
   obj.setLabel(I,varargin{:});
end

% update the label limits & layout the panel
obj.autolayout = true;
obj.update_gridlims();

% reset AutoLayout (which may trigger layout() method)
obj.autolayout = al;
