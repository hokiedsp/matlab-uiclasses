classdef uizoomctrl < uipanelautoresize
   %UIZOOMCTRL   UIPANEL with buttons to turn zoom/pan on/off on a figure
   %   UIZOOMCTRL provides a user interface with 4 buttons, which act
   %   identically to those in the default figure toolbar: pointer (normal),
   %   zoom in, zoom out, and pan. UIZOOMCTRL also provides centralized
   %   methods to access figure's zoom and pan objects.
   %
   % UIZOOMCTRL Properties:
   %
   %   CurrentMode          {'point'}|'zoomin'|'zoomout'|'pan'
   %   AllowUnselect        'on'|{'off'} - Allows CurrentMode = []
   %   TargetFigure         figure handle
   %   ButtonSize           {16} in pixels
   %   PointVisible         {'on'}|'inactive'|'disable'|'off'
   %   ZoomInVisible        {'on'}|'inactive'|'disable'|'off'
   %   ZoomOutVisible       {'on'}|'inactive'|'disable'|'off'
   %   PanVisible           {'on'}|'inactive'|'disable'|'off'
   %   PointTooltipString   text for Point mode: default to 'Normal'
   %   ModeChangedFcn       <function_handle> callback when CurrentMode is changed on GUI
   %
   %   ZOOM related properties: (see help zoom for the details)
   %   -------------------------------
   %   PreZoomCallback      <function_handle>
   %   PostZoomCallback     <function_handle>
   %   ZoomButtonDownFilter <function_handle>
   %   ZoomMotion           'horizontal'|'vertical'|{'both'}
   %   ZoomRightClickAction 'InverseZoom'|{'PostContextMenu'}
   %   ZoomUIContextMenu    <handle>
   %
   %   PAN related properties: (see help pan for the details)
   %   -----------------------------
   %   PanButtonDownFilter  <function_handle>
   %   PrePanCallback       <function_handle>
   %   PostPanCallback <function_handle>
   %   PanMotion 'horizontal'|'vertical'|{'both'}
   %   PanUIContextMenu <handle>
   %
   %   Properties inherited from UIPANELWRAPPER:
   %   -----------------------------------------
   %   Parent           - handle which contains this uipanal
   %   Position         - location of this uipanel
   %   Units            - units of the location values
   %   Visible          - {'on'}|'off'
   %   ResizeFcn        - <function_handle>
   %   ButtonDownFcn    - <function_handle>
   %   CreateFcn        - <function_handle>
   %   DeleteFcn        - <function_Handle>
   %
   % UIZOOMCTRL Methods:
   %
   %   uizoomctrl       - constructor
   %   delete           - destructor
   %   reset            - use current axes limits as the zoom out point
   %
   %   ZOOM Functions:
   %   ---------------
   %   zoomin            - zooms in the specified axes
   %   zoomout           - zooms out the specified axes
   %   isAllowAxesZoom   - true if axes can be zoomed
   %   setAllowAxesZoom  - block/unblock zoom operation on specified axes
   %   getAxesZoomMotion - get axes specific ZoomMotion setting
   %   setAxesZoomMotion - set axes specific ZoomMotion setting
   %
   %   PAN Functions:
   %   --------------
   %   isAllowAxesPan    - true if axes can be panned
   %   setAllowAxesPan   - block/unblock pan opeation on specified axes
   %   getAxesPanMotion  - get axes specific PanMotion setting
   %   setAxesPanMotion  - set axes specific PanMotion setting

   events
      ModeChanged
   end
   properties (Dependent=true,SetAccess=private)
      UIReady
   end
   properties (Dependent=true)
      AllowUnselect        %'on'|{'off'} - Allows CurrentMode = []
      ButtonSize           %positive val
      CurrentMode          %{'point'}|'zoomin'|'zoomout'|'pan'
      PanVisible           %{'on'}|'inactive'|'disable'|'off'
      PanXBounded          %{'on'}|'off' limit panning on x-axis to the zoomed out point
      PanYBounded          %{'on'}|'off' limit panning on y-axis to the zoomed out point
      PointTooltipString   %string
      PointVisible         %{'on'}|'inactive'|'disable'|'off'
      TargetFigure         %figure handle
      ZoomInVisible        %{'on'}|'inactive'|'disable'|'off'
      ZoomOutVisible       %{'on'}|'inactive'|'disable'|'off'
      
      ZoomButtonDownFilter %<function_handle>
      ZoomEnable           %'on'|{'off'}
      ZoomMotion           %'horizontal'|'vertical'|{'both'}
      ZoomRightClickAction %'InverseZoom'|{'PostContextMenu'}
      ZoomUIContextMenu    %<handle>
      
      PanButtonDownFilter  %<function_handle>
      PanEnable            %'on'|{'off'}
      PanMotion            %'horizontal'|'vertical'|{'both'}
      PanUIContextMenu     %<handle>
   end
   properties (Access=private)
      
      fig      % figure under control
      btns     % uicontrol toggle buttons
      jbtns    % btns' java handles
      zoom     % figure's zoom object
      pan      % figure's pan object
      
      mode      % current operating mode
      unsel     % true if mode can be unspecified
      panelsize % button size is fixed to this value
      
      ax      % fig's axes list
      axlims  % zoomed out limits; each row: [xmin xmax ymin ymax]
      
      panxbound
      panybound
      
      el_figclose % listen to obj.fig window closure
      el_axpos    % listens to following axes position
   end
   
   methods
      
      javainit(obj) % if uizoomctrl is constructed with 'Visible'='off', call javainit when uizoomctrl became visible 
      
      reset(obj)
      zoomin(obj,axes,factor)
      zoomout(obj,axes,factor)
      V = getAxesZoomOutPoint(obj,axes)

      scanAxes(obj) % scan for the axes on the figure
      
      followAxes(obj,ax,loc) % automatic object positioning wrt an Axes
      
      function obj = uizoomctrl(varargin)
         %   OBJ = UIZOOMCTRL() creates a uipanel with zoom/pan control
         %   buttons on the current figure. Its mode controls the axes in
         %   the current figure.
         %
         %   OBJ = UIZOOMCTRL(FIG) specifies the figure to be controled by
         %   OBJ.
         %
         %   The input argument may include parameter/value pairs at the
         %   end to specify additional properties of the UIZOOMCTRL and 
         %   UIPANEL.

         obj = obj@uipanelautoresize(varargin{:});
      end
   end
   methods (Access=protected)
      init(obj)
      populate_panel(obj)
      unpopulate_panel(obj)
      layout_panel(obj) % layout the buttons according to the ButtonSize & XXXVisible properties
      mode = enable_action(obj)
   end
   methods (Access=private)
      val = get_btnvisible(obj,type)
      set_targetfigure(obj,h)

      setpanelsize(obj)
      modechange(obj,newmode) % used by set.CurrentMode & Buttons' Callbacks
      btnscallback(obj,h) % Buttons' callback function
      btnsvisiblechange(obj,idx,mode) % performs changes in XXXVisible properties
      panactionpostfcn(obj,h,evt)
   end
   
   methods  % TO GET & SET DEPENDENT PROPERTIES
      
      function val = get.AllowUnselect(obj)
         val = obj.propopts.AllowUnselect.StringOptions{2-obj.unsel};
      end
      function set.AllowUnselect(obj,val)
         obj.validateproperty('AllowUnselect',val);
         obj.unsel = logical(2-val);
      end
      
      function val = get.ButtonSize(obj)
         val = obj.panelsize(2);
      end
      function set.ButtonSize(obj,val)
         obj.validateproperty('ButtonSize',val);
         if ~isequal(val,obj.panelsize(2))
            obj.panelsize(2) = val;
            obj.layout_panel();
         end
      end
      
      function val = get.CurrentMode(obj)
         val = obj.propopts.CurrentMode.StringOptions{obj.mode};
      end
      function set.CurrentMode(obj,val)
         %'none'|{'point'}|'zoomin'|'zoomout'|'pan'
         [~,val] = obj.validateproperty('CurrentMode',val);
         if val==1 && ~obj.unsel
            error('CurrentMode cannot be empty if AllowUnselect = ''off''.');
         end
         obj.modechange(val-1);
      end
      
      function val = get.TargetFigure(obj)
         val = obj.fig;
      end
      function set.TargetFigure(obj,val)
         obj.validateproperty('TargetFigure',val);
         obj.set_targetfigure(val);
      end
      
      function val = get.PointVisible(obj)
         val = obj.get_btnvisible(1);
      end
      function set.PointVisible(obj,val)
         obj.set_btnvisible(1,val);
      end
      
      function val = get.ZoomInVisible(obj)
         val = obj.get_btnvisible(2);
      end
      function set.ZoomInVisible(obj,val)
         obj.set_btnvisible(2,val);
      end
      
      function val = get.ZoomOutVisible(obj)
         val = obj.get_btnvisible(3);
      end
      function set.ZoomOutVisible(obj,val)
         obj.set_btnvisible(3,val);
      end
      
      function val = get.PanVisible(obj)
         val = obj.get_btnvisible(4);
      end
      function set.PanVisible(obj,val)
         obj.set_btnvisible(4,val);
      end
      
      function val = get.PointTooltipString(obj)
         if isempty(obj.jbtns)
            val = '';
         else
            val = char(obj.jbtns(1).getToolTipText());
         end
      end
      function set.PointTooltipString(obj,val)
         if ~obj.isattached()
            error('PointTooltipString can be set only if attached.');
         end
         if isempty(obj.jbtns)
            error('The uizoomctrl object has not been initialized fully. First call layout() after the object became visible.');
         end
         obj.validateproperty('PointTooltipString',val);
         try
            obj.jbtns(1).setToolTipText(val);
         catch ME
            ME.throwAsCaller();
         end
      end
      
      function val = get.PanXBounded(obj)
         val = obj.propopts.PanXBounded.StringOptions{2-obj.panxbound};
      end
      function set.PanXBounded(obj,val) 
         [~,val] = obj.validateproperty('PanXBounded',val);
         obj.panxbound = strcmp(val,'on');
      end
      
      function val = get.PanYBounded(obj)
         val = obj.propopts.PanYBounded.StringOptions{2-obj.panybound};
      end
      function set.PanYBounded(obj,val) 
         [~,val] = obj.validateproperty('PanYBounded',val);
         obj.panybound = strcmp(val,'on');
      end
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%% ZOOM object property wrappers

      function val = get.ZoomButtonDownFilter(obj)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            val = {};
         else
            val = obj.zoom.ButtonDownFilter;
         end
      end
      function set.ZoomButtonDownFilter(obj,val)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.zoom.ButtonDownFilter = val;
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      
      function val = get.ZoomMotion(obj)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            val = {};
         else
            val = obj.zoom.Motion;
         end
      end
      function set.ZoomMotion(obj,val)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.zoom.Motion = val;
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      
      function val = get.ZoomRightClickAction(obj)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            val = {};
         else
            val = obj.zoom.RightClickAction;
         end
      end
      function set.ZoomRightClickAction(obj,val)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.zoom.RightClickAction = val;
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      
      function val = get.ZoomUIContextMenu(obj)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            val = {};
         else
            val = obj.zoom.UIContextMenu;
         end
      end
      function set.ZoomUIContextMenu(obj,val)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.zoom.UIContextMenu = val;
            catch ME
               ME.throwAsCaller();
            end
         end
      end
       
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%% PAN object property wrappers

      function val = get.PanButtonDownFilter(obj)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            val = {};
         else
            val = obj.pan.ButtonDownFilter;
         end
      end
      function set.PanButtonDownFilter(obj,val)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.pan.ButtonDownFilter = val;
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      
      function val = get.PanMotion(obj)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            val = {};
         else
            val = obj.pan.Motion;
         end
      end
      function set.PanMotion(obj,val)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.pan.Motion = val;
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      
      function val = get.PanUIContextMenu(obj)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            val = {};
         else
            val = obj.pan.UIContextMenu;
         end
      end
      function set.PanUIContextMenu(obj,val)
         if isempty(obj.fig) || ~ishghandle(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.pan.UIContextMenu = val;
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      
      function val = get.UIReady(obj)
         if isempty(obj.btns)
            val = 'off';
         else
            val = 'on';
         end
      end
   end
   
   
   methods % passing through the ZOOM & PAN object functions
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % ZOOM object function wrappers
      
      function flag = isAllowAxesZoom(obj,ax)
         if isempty(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               flag = obj.zoom.isAllowAxesZoom(ax);
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      function setAllowAxesZoom(obj,ax,flag)
         if isempty(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.zoom.setAllowAxesZoom(ax,flag);
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      function style = getAxesZoomMotion(obj,ax)
         if isempty(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               style = obj.zoom.getAxesZoomMotion(ax);
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      function setAxesZoomMotion(obj,ax,style)
         if isempty(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.zoom.setAxesZoomMotion(ax,style);
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % PAN object function wrappers
      function flag = isAllowAxesPan(obj,ax)
         if isempty(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               flag = obj.pan.isAllowAxesPan(ax);
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      function setAllowAxesPan(obj,ax,flag)
         if isempty(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.pan.setAllowAxesPan(ax,flag);
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      function style = getAxesPanMotion(obj,ax)
         if isempty(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               style = obj.pan.getAxesPanMotion(ax);
            catch ME
               ME.throwAsCaller();
            end
         end
      end
      function setAxesPanMotion(obj,ax,style)
         if isempty(obj.fig)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.pan.setAxesPanMotion(ax,style);
            catch ME
               ME.throwAsCaller();
            end
         end
      end
   end

end
