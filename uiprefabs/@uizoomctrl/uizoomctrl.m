classdef uizoomctrl < uipanelautoresize & zoompanctrl
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

   properties
      DefaultMode          % 'point'|'zoomin'|'zoomout'|'pan'

      PanEnable            %{'on'}|'inactive'|'off'
      PanVisible           %{'on'}|'off'
      PointerEnable          %{'on'}|'inactive'|'off'
      PointerVisible         %{'on'}|'off'
      ZoomInEnable         %{'on'}|'inactive'|'off'
      ZoomInVisible        %{'on'}|'off'
      ZoomOutEnable        %{'on'}|'inactive'
      ZoomOutVisible       %{'on'}|'off'
   end
   properties (Dependent=true,SetAccess=private)
      UIReady
   end
   properties (Dependent=true)
      AllowUnselect        %'on'|{'off'} - Allows CurrentMode = []
      ButtonSize           %positive val
      PointerTooltipString   %string

      % CurrentMode          %{'point'}|'zoomin'|'zoomout'|'pan'
      % PanVisible           %{'on'}|'inactive'|'disable'|'off'
      % PanXBounded          %{'on'}|'off' limit panning on x-axis to the zoomed out point
      % PanYBounded          %{'on'}|'off' limit panning on y-axis to the zoomed out point
      % PointVisible         %{'on'}|'inactive'|'disable'|'off'
      % TargetFigure         %figure handle
      % ZoomInVisible        %{'on'}|'inactive'|'disable'|'off'
      % ZoomOutVisible       %{'on'}|'inactive'|'disable'|'off'
      % 
      % ZoomButtonDownFilter %<function_handle>
      % ZoomMotion           %'horizontal'|'vertical'|{'both'}
      % ZoomRightClickAction %'InverseZoom'|{'PostContextMenu'}
      % ZoomUIContextMenu    %<handle>
      % 
      % PanButtonDownFilter  %<function_handle>
      % PanMotion            %'horizontal'|'vertical'|{'both'}
      % PanUIContextMenu     %<handle>
   end
   properties (Access=private)
      btns     % uicontrol toggle buttons
      jbtns    % btns' java handles
      panelsize
      el_btnstates % listens to changes in btns' Visible/Enable PostSet
      btnstates % true if button is available
      unsel    % true if mode can be unspecified
      el_axpos
   end
   
   methods
      
      javainit(obj) % if uizoomctrl is constructed with 'Visible'='off', call javainit when uizoomctrl became visible 
      followAxes(obj,ax,loc,offset) % to make uizoomctrl panel to follow an axes

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
         obj = obj@zoompanctrl();
      end
   end
   methods (Access=protected)
      init(obj)
      populate_panel(obj)
      unpopulate_panel(obj)
      layout_panel(obj) % layout the buttons according to the ButtonSize & XXXVisible properties
      mode = enable_action(obj)

      f = set_targetfigure(obj,h)
      cfg_currentmode(obj,newmode)
      cfg_supportedmodes(obj)
      
      val = get_btnena(obj,type)
      set_btnena(obj,type,val,btnname)
      
      btnscallback(obj,h) % Buttons' callback function

      val = get_btnvis(obj,type)
      set_btnvis(obj,type,val,btnname)
      
      monitor_btnsstate(obj,type,newstate,otherisena)

      btnsvisiblechange(obj,idx,mode) % performs changes in XXXVisible properties
   end
   
   methods  % TO GET & SET DEPENDENT PROPERTIES
      function set.DefaultMode(obj,val)
         obj.DefaultMode = obj.validateproperty('DefaultMode',val);
      end
      
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
      
      function val = get.PointerTooltipString(obj)
         if isempty(obj.jbtns)
            val = '';
         else
            val = char(obj.jbtns.pointer.getToolTipText());
         end
      end
      function set.PointerTooltipString(obj,val)
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
      
      function val = get.UIReady(obj)
         if isempty(obj.btns)
            val = 'off';
         else
            val = 'on';
         end
      end
      
      function set.PointerVisible(obj,val)
         obj.PointVisible = obj.validateproperty('PointerVisible',val);
         obj.set_btnvis(1,val,'pointer');
      end
      
      function set.ZoomInVisible(obj,val)
         obj.ZoomInVisible = obj.validateproperty('ZoomInVisible',val);
         obj.set_btnvis(2,val,'zoomin');
      end
      
      function set.ZoomOutVisible(obj,val)
         obj.ZoomOutVisible = obj.validateproperty('ZoomOutVisible',val);
         obj.set_btnvis(3,val,'zoomout');
      end
      
      function set.PanVisible(obj,val)
         obj.PanVisible = obj.validateproperty('PanVisible',val);
         obj.set_btnvis(4,val,'pan');
      end
      
      function set.PointerEnable(obj,val)
         obj.PointEnable = obj.validateproperty('PointerEnable',val);
         obj.set_btnena(1,val,'pointer');
      end
      
      function set.ZoomInEnable(obj,val)
         obj.ZoomInEnable = obj.validateproperty('ZoomOutEnable',val);
         obj.set_btnena(2,val,'zoomin');
      end
      
      function set.ZoomOutEnable(obj,val)
         obj.ZoomOutEnable = obj.validateproperty('ZoomOutEnable',val);
         obj.set_btnena(3,val,'zoomout');
      end
      
      function set.PanEnable(obj,val)
         obj.PanEnable = obj.validateproperty('PanEnable',val);
         obj.set_btnena(4,val,'pan');
      end
      
   end
   
end
