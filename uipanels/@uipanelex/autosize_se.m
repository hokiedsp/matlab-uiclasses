function autosize_se(obj)
%UIPANELEX/AUTOSIZE_SE   Adjust base HG Position to match the content extent
%   AUTOSIZE_SE(OBJ) implements public sealed AUTOSIZE(OBJ) for a scalar
%   OBJ with HG object attached.

h = obj.hgbase();

set(obj.hg_listener,'Enabled','off');

u = get(h,'Units');
set(h,'Units','pixels');
ext = obj.Extent;
pos = get(h,'Position');
pos([3 4]) = ext([3 4]);
set(h,'Position',pos);
set(h,'Units',u);

set(obj.hg_listener,'Enabled','on')
