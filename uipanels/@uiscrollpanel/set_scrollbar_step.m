function newval = set_scrollbar_step(h,hother,other_loclo,step,ssize,csize,th)
%UISCROLLPANEL/SET_SCROLLBAR_STEPS   (protected)
%   SET_SCROLLBAR_STEPS(H,Hother,OtherLocLo,Step,ShellSize,CanvasSize,Thickness)
%
%   Scrollbar's value will directly corresponds to the origin of the canvas
%   panel.

% if vertical scrollbar is visible, actual canvas shell height is shorter
vis = strcmp(get(hother,'Visible'),'on');
if vis
   ssize = ssize - th;
end

% save the relative value of the curent scrollbar 
val = get(h,{'Value','Max','Min'});
relloc = (val{1}-val{3})/(val{2}-val{3}); % current relative location

maxval = 1;
minval = ssize-csize+1;

% if the other scrollbar is shown at 'left' or 'bottom' (loclo=true),
% move the canvas by the thickness of the scrollbar
if other_loclo && vis
   minval = minval + th;
   maxval = maxval + th;
end

% negate for the slider values (so its sliding motion agrees with canvas motion)
newval = minval;
minval = -maxval;
maxval = -newval;

% compute new current value
rng = (maxval-minval);
newval = rng*relloc + minval;

steps = min([step ssize],rng)/rng;
set(h,'Min',minval,'Max',maxval,'Value',newval,'SliderStep',steps);

newval = -newval;
