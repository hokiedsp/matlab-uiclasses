function removeLabel(obj,I)
%HGANDLABELS/REMOVE   Remove elements
%   REMOVE(OBJ,H) deletes UICONTROL label objects given in H from a scalar
%   HGANDLABELS object OBJ.
%
%   REMOVE(OBJ,I) deletes the I-th labels from OBJ.

narginchk(2,2);

if isempty(I), return; end

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

% delete listeners
[~,J] = ismember(cell2mat(get(obj.content_listeners,'Container')),obj.labels_h(I));
delete(obj.content_listeners(J));
obj.content_listeners(J) = [];

% remove associated text object
delete([obj.labels_htext{I}]);

% remove them from the grid
obj.labels_htext(I) = [];    % text handle for tex/latex text interpreter support
obj.labels_layout(I,:) = [];      % location of leading label {}
obj.labels_margin(I) = [];   % space from the origin of the leading label to the nearest edge of the HG
obj.labels_interpreter(I) = [];
