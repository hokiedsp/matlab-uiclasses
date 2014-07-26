function layout(obj)
%UIPANELEX/LAYOUT   Layout panel content
%   LAYOUT(OBJ) re-layout contents of the panel objects OBJ.
%
%   See Also: UIPANELEX/UIPANELEX

% ignore detached objects
obj(~obj.isattached()) = [];

for n = 1:numel(obj)
   o = obj(n);
   mode = o.autolayout; % save the current mode
   o.autolayout = true;
   o.layout_panel(); % run the layout
   o.autolayout = mode; % revert
end
