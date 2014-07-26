function pv = getLabel(obj,I,pn)
%HGANDLABELS/GETLABEL
%   GETLABEL(OBJ,H,'PropertyName')
%   GETLABEL(OBJ,I,'PropertyName')
%   GETLABEL(...,pv,pn)
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

narginchk(3,3);

if isempty(I)
   pv = [];
   return;
end
   
if ~isscalar(obj)
   error('OBJ must be a scalar HGANDLABELS object.');
end
if isempty(obj.hg)
   error('OBJ must be attached to an HG object.');
end

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

pnisnotcell = ~iscell(pn);
if pnisnotcell
   pn = {pn};
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

pv = cell(numel(I),numel(pn));
for n = 1:numel(pn)
   tf = strcmp(pn{n},propnames(:,1));
   if any(tf)
      [psrc,pint,pidx] = deal(propnames{tf,2:end});
      if tf(1) % margin
         pv(:,n) = num2cell(obj.(pint)(I));
      else % other OBJ property
         opts = obj.propopts.(psrc).StringOptions;
         pv(:,n) = opts(obj.(pint)(I,pidx));
      end
   else % HG property
      pv(:,n) = get(obj.labels_h(I),pn(n));
   end
end

if pnisnotcell && isscalar(pv)
   pv = pv{1};
end
