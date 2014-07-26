classdef uiscrollpanel < uipanelex
   %UISCROLLPANEL   An HG panel with scrollable canvas
   %   UISCROLLPANEL embeds a panel type HG objects (<a href="matlab:help uicontainer">uicontainer</a> (default), <a href="matlab:help uipanel">uipanel</a>,
   %   <a href="matlab:help uigridcontainer">uigridcontainer</a>, or <a href="matlab:help uiflowcontainer">uiflowcontainer</a>) as a canvas in a panel with
   %   scrollbars.
   %
   %   UISCROLLPANEL in Matlab prior to R2014b has an inherent limitation in
   %   which uicontrols outside of the UISCROLLPANEL's child visible area
   %   remain visible.
   %
   %
   %   UISCROLLPANEL properties.
   %      Canvas                   - HG object handle of the canvas panel
   %      CanvasOrigin             - location of lower-left-hand corner
   %      CanvasSize               - size of the canvas (in CanvasUnits)
   %      CanvasUnits              - units of the CanvasSize
   %      ContentExtent            - 
   %      SliderThickness          - width of the scrollbars scrollbar
   %      ResizeFcnMode            - ['auto' 'manual']
   %
   %      HorizontalAlignment      - horizontal alignment of canvas when it is smaller than the shell ['left' 'center' 'right']
   %      VerticalAlignment        - vertical alignment of canvas when it is smaller than the shell ['bottom' 'middle' 'top']
   %
   %      AutoDetach      - Simultaneous deletion of HG object
   %      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
   %                         if panel content has changed.
   %      ContentExtent   - (Read-only) tightest position rectangle encompassing all canvas' Children
   %      Enable          - Enable or disable the panel and its contents
   %      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
   %      GraphicsHandle  - Attached HG object handle
   %
   %   Properties related to horizontal scrollbar:
   %      HorizontalScrollbar         - ['on' 'off'] turn on/off
   %      HorizontalScrollbarLocation - ['bottom' 'top'] scrollbar location
   %      HorizontalScrollbarAutoHide - ['on' 'off'] on to turn off scrollbar when not in use
   %      HorizontalScrollbarStep     - scrollbar step size when clicked on an arrow
   %
   %   Properties related to vertical scrollbar:
   %      VerticalScrollbar           - ['on' 'off']
   %      VerticalScrollbarLocation   - ['left' 'right']
   %      VerticalScrollbarAutoHide   - ['on' 'off'] on to turn off scrollbar when not in use
   %      VerticalScrollbarStep       - scrollbar step size when clicked on an arrow
   %
   %   UISCROLLPANEL methods:
   %   UISCROLLPANEL object construction:
   %      @UISCROLLPANEL/UISCROLLPANEL   - Construct UISCROLLPANEL object.
   %      delete                 - Delete UISCROLLPANEL object.
   %
   %   HG Object Association:
   %      attach                 - Attach HG panel-type object.
   %      detach                 - Detach HG object.
   %      isattached             - True if HG object is attached.
   %
   %   HG Object Control:
   %      enable               - Enable the scollbars and canvas
   %      disable              - Disable the scollbars and canvas
   %      inactivate           - Inactivate (visually on, functionally off)
   %                             the scollbars and canvas.
   %
   %      fitcanvas            - Fit canvas to the panel
   %
   %   Getting and setting parameters:
   %      get              - Get value of UISCROLLPANEL object property.
   %      set              - Set value of UISCROLLPANEL object property.
   
   properties
      ResizeFcnMode            % ['auto'|'manual']
   end
   properties (SetAccess=private,Dependent)
      Window                  % container HG handle (outside base panel)
      Canvas                  % container HG handle (inside object layout area)
   end
   properties (Dependent)
      CanvasOrigin             % location of the LLH corner wrt Shell's LLH corner
      CanvasSize               % size of the full layout area
      CanvasUnits              % units for CanvasSize
      HorizontalAlignment      % horizontal alignment of canvas when it is smaller than the shell ['left' 'center' 'right']
      HorizontalScrollbar         % ['on' 'off']
      HorizontalScrollbarLocation % ['bottom' 'top']
      HorizontalScrollbarAutoHide  % horizontal scrollbar mode ['off' 'on']
      HorizontalScrollbarStep     % horizontal scrollbar step sizes
      ScrollbarThickness          % width of the scrollbars scrollbar
      VerticalAlignment        % vertical alignment of canvas when it is smaller than the shell ['bottom' 'middle' 'top']
      VerticalScrollbar         % ['on' 'off']
      VerticalScrollbarLocation   % ['left' 'right']
      VerticalScrollbarAutoHide   % vertical scrollbar visibility ['off' 'on']
      VerticalScrollbarStep       % vertical scrollbar stepsizes
   end
   properties (Access=protected)
      hwindow  % window container (base)
      hcanvas  % canvas container (child of hview)
      hscrollbars % [horizontal vertical] scroller (children of hview)
      
      thickness
      
      % alignment if canvas is smaller than shell
      onoff = false(1,2) % true to show scrollbar
      align = zeros(1,2) % 1-'left',2-'center',3-'right or 1-'bottom',2-'middle',3-'top'
      vis = false(1,2)   % false to auto-hide
      loclo = false(1,2) % true to be 'bottom' or 'left'
      step = zeros(1,2);   % scrollbar minor step size in pixels
   end
   methods
      fitcanvas(obj,dolayout) % set canvas to fit the shell
      
      function obj = uiscrollpanel(varargin)
         %UISCROLLPANEL/UISCROLLPANEL() instantiates UISCROLLPANEL
         %class
         %
         %   UISCROLLPANEL creates a scalar UISCROLLPANEL object. A new
         %   uicontainer object is also created on the current figure and attached
         %   to the UISCROLLPANEL object.
         %
         %   UISCROLLPANEL(N) creates an N-by-N matrix of UISCROLLPANEL
         %   objects
         %
         %   UISCROLLPANEL(M,N) creeates an M-by-N matrix of UISCROLLPANEL
         %   objects
         %
         %   UISCROLLPANEL(M,N,P,...) or UISCROLLPANEL([M N P ....])
         %   creates an M-by-N-by-P-by-... array of UISCROLLPANEL objects.
         %
         %   UISCROLLPANEL(SIZE(A)) creates UISCROLLPANEL objects with the
         %   same size as A.
         %
         %   UISCROLLPANEL(...,TYPE) uses a different type of container. TYPE
         %   may be one of: 'uicontainer', 'uipanel', 'uiflowcontainer',
         %   'uigridcontainer' and 'detached'. If TYPE = 'detached', created
         %   UISCROLLPANEL objects is not attached to any HG container object.
         %
         %   UISCROLLPANEL(H) creates UISCROLLPANEL objects for the
         %   uipanel objects given in H and the created object has the same
         %   dimension as H. The HG object must be one of the supported types.
         %
         %   UISCROLLPANEL(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created UISCROLLPANEL objects. All
         %   objects are set to the same property values.
         %
         %   UISCROLLPANEL(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         varargin = uipanelex.autoattach(mfilename,@uicontainer,varargin);
         obj = obj@uipanelex(varargin{:});
      end
   end
   methods (Access=protected)
      function types = supportedtypes(~) % supported HG object types
         types = {'uipanel','uicontainer','uiflowcontainer','uigridcontainer'};
      end
      
      init(obj)
      
      populate_panel(obj)   % populate the panel content after attachment
      layout_panel(obj,sz,origin)  % layout the panel (position canvas and scrollbars)
      unpopulate_panel(obj) % unpopulate the panel (undoing the dual-panel construction)
      
      move_canvas(obj,varargin) % scrollbar callback function
      
      check_resizefcn(obj,val) % obj.hg|ResizeFcn|PostSet
      
      [pos,dispsize] = get_canvas_position(obj,actual) % get current canvas position in pixels and its maximum display size
      
      val = get_canvas(obj)      % to override get.Canvas
      val = get_canvassize(obj)  % to override get.CanvasSize
      set_canvassize(obj,val)    % to override set.CanvasSize
      val = get_canvasunits(obj) % to override get.CanvasUnits
      set_canvasunits(obj,val)   % to override set.CanvasUnits
      
      val = get_canvasorigin(obj);
      set_canvasorigin(obj,val);

      val = get_contentextent(obj,h) % to override for get.ContentExtent

      function h = hgbase_se(obj), h = obj.hwindow; end      
   end
   methods (Access=private)
      [issmall,hide] = is_canvas_small(obj,csize,ssize)
      set_canvas_position(obj,pos)
      set_scrollbar(obj,I,val)  % new scrollbar step configuration (Value,Max,ScrollbarSteps)
   end
   
   methods (Access=private,Static)
      origin = get_small_canvas_origin(csize,ssize,align,other_vis,other_loclo,th)
      [M0,m0,Mlen,mlen] = get_scrollbar_position(loloc,maxlen,hother,other_loclo,other_maxlen,th)
      newval = set_scrollbar_step(h,hother,other_loclo,step,ssize,csize,th)
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   methods % Property set/get functions
      function val = get.Canvas(obj)
         if obj.isattached()
            val = obj.get_canvas();
         else
            val = [];
         end
      end
      
      function val = get.Window(obj)
         if obj.isattached()
            val = obj.hwindow;
            try
               val = double(val);
            catch
            end
         else
            val = [];
         end
      end
      
      % location of the canvas
      function val = get.CanvasOrigin(obj)
         if obj.isattached()
            val = obj.get_canvasorigin();
         else
            val = [];
         end
      end
      function set.CanvasOrigin(obj,val)
         if obj.isattached()
            obj.validateproperty('CanvasOrigin',val);
            obj.set_canvasorigin(val);
         elseif ~isempty(val)
            error('CanvasOrigin can only be set if OBJ is attached to an HG object.');
         end
      end
      
      % size of the full layout area
      function val = get.CanvasSize(obj)
         if obj.isattached()
            val = obj.get_canvassize();
         else
            val = [];
         end
      end
      function set.CanvasSize(obj,val)
         if obj.isattached()
            obj.validateproperty('CanvasSize',val);
            set_canvassize(obj,val);
         elseif ~isempty(val)
            error('CanvasSize can only be set if OBJ is attached to an HG object.');
         end
      end
      
      % units for CanvasSize
      function val = get.CanvasUnits(obj)
         if obj.isattached()
            val = obj.get_canvasunits();
         else
            val = [];
         end
      end
      function set.CanvasUnits(obj,val)
         if obj.isattached()
            val = obj.validateproperty('CanvasUnits',val);
            set_canvasunits(obj,val)
         elseif ~isempty(val)
            error('CanvasSize can only be set if OBJ is attached to an HG object.');
         end
      end
      
      function set.ResizeFcnMode(obj,val)
         if obj.isattached()
            [obj.ResizeFcnMode,val] = obj.validateproperty('ResizeFcnMode',val);
            if val==2 % 'auto' - resize now
               set(obj.window,'ResizeFcn',@(~,~)obj.layout_panel);
            end
         elseif ~isempty(val)
            error('ResizeFcnMode can only be set if OBJ is attached to an HG object.');
         end
      end
      
      % horizontal alignment of canvas when it is smaller than the shell ['left' 'center' 'right']
      function val = get.HorizontalAlignment(obj)
         val = obj.propopts.HorizontalAlignment.StringOptions{obj.align(1)};
      end
      function set.HorizontalAlignment(obj,val)
         [~,val] = obj.validateproperty('HorizontalAlignment',val);
         if val==obj.align(1), return; end
         
         obj.align(1) = val;
         obj.layout_panel();
      end
      
      % the horizontal scrollbar ['off' 'on']
      function val = get.HorizontalScrollbar(obj)
         val = obj.propopts.HorizontalScrollbar.StringOptions{obj.onoff(1)+1};
      end
      function set.HorizontalScrollbar(obj,val)
         [~,val] = obj.validateproperty('HorizontalScrollbar',val);
         val = val==2;
         if val==obj.onoff(1), return; end
         
         obj.onoff(1) = val;
         obj.layout_panel();
      end
      
      % location of the horizontal scrollbar ['bottom' 'top']
      function val = get.HorizontalScrollbarLocation(obj)
         val = obj.propopts.HorizontalScrollbarLocation.StringOptions{2-obj.loclo(1)};
      end
      function set.HorizontalScrollbarLocation(obj,val)
         [~,val] = obj.validateproperty('HorizontalScrollbarLocation',val);
         val = val==1;
         if val==obj.loclo(1), return; end
         
         obj.loclo(1) = val;
         obj.layout_panel();
      end
      
      % horizontal scrollbar mode ['off' 'on']
      function val = get.HorizontalScrollbarAutoHide(obj)
         val = obj.propopts.HorizontalScrollbarAutoHide.StringOptions{2-obj.vis(1)};
      end
      function set.HorizontalScrollbarAutoHide(obj,val)
         [~,val] = obj.validateproperty('HorizontalScrollbarAutoHide',val);
         val = val==1; % =='off'
         if val==obj.vis(1), return; end
         
         obj.vis(1) = val;
         obj.layout_panel();
      end
      
      % horizontal scrollbar step sizes
      function val = get.HorizontalScrollbarStep(obj)
         val = obj.step(1,:);
      end
      function set.HorizontalScrollbarStep(obj,val)
         obj.validateproperty('HorizontalScrollbarStep',val);
         obj.set_scrollbar(1,val);
      end
      
      % width of the scrollbars scrollbar
      function val = get.ScrollbarThickness(obj)
         val = obj.thickness;
      end
      function set.ScrollbarThickness(obj,val)
         obj.validateproperty('ScrollbarThickness',val);
         if val==obj.thickness, return; end
         
         obj.thickness = val;
         obj.layout_panel();
      end
      
      % vertical alignment of canvas when it is smaller than the shell ['bottom' 'middle' 'top']
      function val = get.VerticalAlignment(obj)
         val = obj.propopts.VerticalAlignment.StringOptions{obj.align(2)};
      end
      function set.VerticalAlignment(obj,val)
         [~,val] = obj.validateproperty('VerticalAlignment',val);
         if val==obj.align(2), return; end
         
         obj.align(2) = val;
         obj.layout_panel();
      end
      
      % the vertical scrollbar ['off' 'on']
      function val = get.VerticalScrollbar(obj)
         val = obj.propopts.VerticalScrollbar.StringOptions{obj.onoff(2)+1};
      end
      function set.VerticalScrollbar(obj,val)
         [~,val] = obj.validateproperty('VerticalScrollbar',val);
         val = val==2;
         if val==obj.onoff(2), return; end
         
         obj.onoff(2) = val;
         obj.layout_panel();
      end
      
      % location of the vertical scrollbar ['left' 'right']
      function val = get.VerticalScrollbarLocation(obj)
         val = obj.propopts.VerticalScrollbarLocation.StringOptions{2-obj.loclo(2)};
      end
      function set.VerticalScrollbarLocation(obj,val)
         [~,val] = obj.validateproperty('VerticalScrollbarLocation',val);
         val = val==1;
         if val==obj.loclo(2), return; end
         
         obj.loclo(2) = val;
         obj.layout_panel();
      end
      
      % vertical scrollbar visibility ['off' 'on']
      function val = get.VerticalScrollbarAutoHide(obj)
         val = obj.propopts.VerticalScrollbarAutoHide.StringOptions{2-obj.vis(1)};
      end
      function set.VerticalScrollbarAutoHide(obj,val)
         [~,val] = obj.validateproperty('VerticalScrollbarAutoHide',val);
         val = val==1; % =='off'
         if val==obj.vis(2), return; end
         
         obj.vis(2) = val;
         obj.layout_panel();
      end
      
      % vertical scrollbar stepsizes
      function val = get.VerticalScrollbarStep(obj)
         val = obj.step(2);
      end
      function set.VerticalScrollbarStep(obj,val)
         obj.validateproperty('VerticalScrollbarStep',val);
         obj.set_scrollbar(2,val);
      end
   end
   
end
