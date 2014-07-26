function linkaxes(obj,linkcols,idx)
%UIAXESARRAY/LINKAXES   Link axes along columns or rows
%   LINKAXES(OBJ,LINKCOLS,INDEX) links the axes under control of
%   UIAXESARRAY OBJ. If LINKCOLS=true, the x-axes of the axes on the
%   INDEX-th column are linked. If LINKCOLS=false, the y-axes of the axes
%   on the INDEX-th row are linked. If INDEX is a vector, the axes on each
%   column/row specified by INDEX are separately linked.

if linkcols
   % destroy the linking functions
   delete(obj.xlink_listeners);
   obj.xlink_listeners(:) = [];
   
   for n = idx(:).'
      
      I = obj.map(:,n);
      I(I==0) = [];
      I = unique(I);
      I(obj.elem_span(I,2)~=1) = []; % spanned axes are not linked
      h = obj.elem_h(I);
      Nh = numel(h);
      if Nh<=1, return; end % nothing to link
      for m = 1:Nh
         obj.xlink_listeners(end+1) = addlistener(h(m),'XLim','PostSet',...
            @(el,event)link_lims(obj,h([1:m-1 m+1:end]),'XLim',event.NewValue));
      end
   end
   
else
   delete(obj.ylink_listeners);
   obj.ylink_listeners(:) = [];
   
   for n = idx(:).'
      
      I = obj.map(n,:);
      I(I==0) = [];
      I = unique(I);
      I(obj.elem_span(I,1)~=1) = []; % spanned axes are not linked
      h = obj.elem_h(I);
      Nh = numel(h);
      if Nh<=1, return; end % nothing to link
      for m = 1:Nh
         obj.ylink_listeners(end+1) = addlistener(h(m),'YLim','PostSet',...
            @(el,event)link_lims(obj,h([1:m-1 m+1:end]),'YLim',event.NewValue));
      end
   end
   
end

end

function link_lims(obj,h,limname,newxlim)
set(obj.xlink_listeners,'Enabled','off');
set(h,limname,newxlim);
set(obj.xlink_listeners,'Enabled','on');
end
