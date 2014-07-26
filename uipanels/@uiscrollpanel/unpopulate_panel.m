function unpopulate_panel(obj)
%UISCROLLPANEL/UNPOPULATE_PANEL (protected) remove the class dependent child objects from obj.hg
%   UNPOPULATE_PANEL(OBJ) is called during OBJ.detach such that OBJ.hg is
%   reverted to the original condition at the time of attachment

% only relevant if HG object is currently attached
if ~obj.isattached(), return; end

% remove all listeners
obj.unpopulate_panel@uipanelex();

% delete the scrollbar controls
delete(obj.hscrollbars(ishghandle(obj.hscrollbars)));

if isequal(obj.hg,obj.hwindow) % keep window
   % clear ResizeFcn if its mode is set to 'auto'
   if ~isequal(get(obj.hg,'ResizeFcn'),@(~,~)obj.layout_panel)
      set(obj.hg,'ResizeFcn',{});
   end
   
   % copy canvas objects onto window panel
   % move the child object back to hg
   set(get(obj.hcanvas,'Children'),'Parent',obj.hg);
   
   delete(obj.hcanvas);
else % keep canvas
   % copy the parent & position data from obj.hg to obj.hcanvas
   props2copy = {'Parent','Units','Position'};
   set(obj.hg,props2copy,get(obj.hwindow,props2copy));
   delete(obj.hwindow);
end

% clear HG handle holders
[obj.hwindow,obj.hcanvas,obj.hscrollbars] = deal([]);
