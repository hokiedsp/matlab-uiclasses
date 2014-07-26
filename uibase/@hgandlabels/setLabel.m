function setLabel(obj,varargin)
%HGANDLABELS/SETLABEL
%   SETLABEL(OBJ,H,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
%   SETLABEL(OBJ,I,...)
%   SETLABEL(...,pv,pn)
%
%   Properties stored in OBJ
%   -----------------------------------------------------------------------
%   HorizontalAlignment: ['left'|{'center'}|'right'] horizontal
%         alignment of the label. Only relevant if Location = 'top' or
%         'bottom.'
%   Interpreter: [{'none'}|'latex'|'tex'] sets text interpreter. If
%         Interpreter = 'latex' or 'tex', label is displayed on an axes text.
%   Margin: [non-negative scalar] space between label origin and the
%         nearest HG object edge (default: 2)
%   Location: [{'left'}|'top'|'right'|'bottom'] location of the label
%         with respect to the HG object.
%   VerticalAlignment: ['bottom'|{'middle'}|'top'] vertical alignemnt
%         of the label. Only relevant if Location = 'left' or 'right.'
%
%   Accessible properties stored in the label UICONTROL
%   -----------------------------------------------------------------------
%   FontAngle:       Character slant
%   FontName:        Font family
%   FontSize:        Font size
%   FontUnits:       Font size units
%   FontWeight:      Weight of text characters
%   ForegroundColor: Color of text
%   String:          Label string
%   TooltipString:   Content of label's tooltip

narginchk(4,inf);
if ~isscalar(obj)
   error('OBJ must be a scalar HGANDLABELS object.');
end
if isempty(obj.hg)
   error('OBJ must be attached to an HG object.');
end

I = varargin{1};
hggiven = all(ishghandle(I));
if hggiven
   [tf,Itmp] = ismember(handle(I),obj.labels_h);
   hggiven = all(tf);
   if hggiven
      I = Itmp;
   end
end
if ~hggiven
   % index given, get elements at the specified cells
   validateattributes(I,{'numeric'},{'vector','positive','integer','<=',numel(obj.labels_h)});
end

if mod(nargin,2)~=0
   error('Invalid property name-value pair.');
end

if nargin==4 && all(cellfun(@iscell,varargin([2 3])))
   pn = varargin{2};
   pv = varargin{3};
   if size(pv,1)~=numel(I)
      error('Propety value cell must have the same number of rows as the labels to be modified.');
   end
else
   pn = varargin(2:2:end);
   pv = varargin(3:2:end);
   if all(cellfun(@(val)iscell(val)&&iscolumn(val),pv))
      pv = [pv{:}];
   end
end

propnames = {
   'margin'              'LabelMargins'              'labels_margin' 1
   'location'            'LabelLocations'            'labels_layout' 1
   'horizontalalignment' 'LabelHorizontalAlignments' 'labels_layout' 2
   'verticalalignment'   'LabelVerticalAlignments'   'labels_layout' 3
   'interpreter'         'LabelInterpreters'         'labels_interpreter' 1
};
hgpropnames = {'string';'fontangle';'fontname';'fontsize';'fontweight';'fontunits';'foregroundcolor';'tooltipstring'};

pn = cellfun(@(n)validatestring(n,[propnames(:,1);hgpropnames]),pn,'UniformOutput',false);

alprev = obj.autolayout;
obj.autolayout = false;

gridlimupdate = false;
for n = 1:numel(pn)
   tf = strcmp(pn{n},propnames(:,1));
   if any(tf) % OBJ property
      [pdst,pint,pidx] = deal(propnames{tf,2:end});
      vals = cellfun(@(val)obj.validateproperty(pdst,val),pv(:,n),'UniformOutput',false);
      if ~tf(1) % convert string value to option index (except for Margin)
         opts = obj.propopts.(pdst).StringOptions;
         vals = cellfun(@(val)find(strcmp(opts,val),1),vals,'UniformOutput',false);
      end
      
      obj.(pint)(I,pidx) = [vals{:}];
      gridlimupdate = true;
   else % HG property
      set(obj.labels_h(I),pn(n),pv(:,n));
      if ~gridlimupdate
         gridlimupdate = any(strcmp(pn{n},hgpropnames(1:5)));
      end
   end
end

% revert the auto-layout mode
obj.autolayout = alprev;

% perform necessary layout update
if gridlimupdate
   obj.update_gridlims(); % re-compute the grid column & row limits
else
   obj.layout_panel(); % just re-layout
end
