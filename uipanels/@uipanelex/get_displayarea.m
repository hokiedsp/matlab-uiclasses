function sz = get_displayarea(h)
%UIPANELEX.GET_DISPLAYAREA   Returns size of visible area inside of panel
%   SZ = GET_DISPLAYAREA(H): SZ = [width height]. It adjusts for both
%   border thickness and title text.

% start with the full size
u = get(h,'Units');
set(h,'Units','pixel');
sz = get(h,'Position');
set(h,'Units',u);
sz([1 2]) = [];

bmargin = uipanelex.get_bordermargins(h);

% adjust the width first
sz(1) = sz(1) - sum(bmargin([1 2]));
sz(2) = sz(2) - sum(bmargin([3 4]));
