function origin = get_small_canvas_origin(csize,ssize,align,other_vis,other_loclo,th)
%UISCROLLPANEL.GET_CANVAS_ORIGIN

% place it according to horizontalalignment
if align==1
   origin = 1;
else
   origin = ssize-csize;
   if align==2 % align = center/middle
      origin = origin/2;
   end
   origin = origin + 1;
end

% if the other scrollbar is shown at 'left' or 'bottom' (loclo=true),
% move the canvas by the thickness of the scrollbar
if other_vis && other_loclo
   origin = origin + th;
end
