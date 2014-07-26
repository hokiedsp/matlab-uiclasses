function [tf,hide] = is_canvas_small(obj,csize,ssize)
% UISCROLLPANEL.IS_CANVAS_SMALL
% TF = UISCROLLPANEL.IS_CANVAS_SMALL(OBJ,CSIZE,SSIZE)

% 1. Check whether scrollbars can be hidden
dsize = ssize-csize; % positive if shell is larger than canvas
autohide = ~obj.vis;  % if false, scrollbars auto-hide

hide = autohide & dsize>=0; % false if scrollbar is determined to be shown
foresure_hidden = autohide & dsize>=-obj.thickness; % true if scrollbar is determined to be hidden
maybe_hidden = hide & ~foresure_hidden; % uncertain
if all(maybe_hidden) % if both uncertain, cannot be hidden
   hide(:) = false;
elseif ~hide(1) && maybe_hidden(2) % if the other is shown, uncertain resolves to be shown
   hide(2) = false;
elseif ~hide(2) && maybe_hidden(1)
   hide(1) = false;
end

% 2. Check if canvas fits inside shell
dmin = [0 0];
dmin(~hide([2 1])) = -obj.thickness; % if the other scrollbar is not hidden
tf = dsize>=dmin;

% 3. if scrollbar is turned, off, overrule size based hidden
hide(:) = hide | ~obj.onoff;
