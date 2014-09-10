function panactionpostfcn(obj,h,evt)
%UIZOOMCTRL/PANACTIONPOSTFCN   Pan ActionPostCallback function

% determine which axes is panned
I = find(obj.ax == evt.Axes,1);

% limit panning within the zoom out point range
maxlim = obj.axlims(I,:);
if obj.panxbound
   xlim = get(evt.Axes,'XLim');
   dx = diff(xlim);
   if xlim(1)<maxlim(1)
      xlim(1) = maxlim(1);
      xlim(2) = maxlim(1)+dx;
   elseif xlim(2)>maxlim(2)
      xlim(1) = maxlim(2)-dx;
      xlim(2) = maxlim(2);
   end
   set(evt.Axes,'XLim',xlim);
end
if obj.panybound
   ylim = get(evt.Axes,'YLim');
   dy = diff(ylim);
   if ylim(1)<maxlim(3)
      ylim(1) = maxlim(3);
      ylim(2) = maxlim(3)+dy;
   elseif ylim(2)>maxlim(4)
      ylim(1) = maxlim(4)-dy;
      ylim(2) = maxlim(4);
   end
   set(evt.Axes,'YLim',ylim);
end

% perform user callback if specified
if ~isempty(obj.usrpostpanfcn)
   obj.usrpostpanfcn(h,evt);
end
