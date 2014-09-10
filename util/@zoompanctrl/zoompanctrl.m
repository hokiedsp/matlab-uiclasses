classdef zoompanctrl < hgsetgetex
%ZOOMPANCTRL   Base class to control zoom/pan state of a figure
%   ZOOMPANCTRL provides a user interface with 4 buttons, which act
%   identically to those in the default figure toolbar: pointer (normal),
%   zoom in, zoom out, and pan. ZOOMPANCTRL also provides centralized
%   methods to access figure's zoom and pan objects.
%
% ZOOMPANCTRL Properties:
%
%   CurrentMode          'none'|{'point'}|'zoomin'|'zoomout'|'pan'
%   ModeChangedFcn       <function_handle> callback when CurrentMode is changed on GUI
%   TargetFigure         figure handle
%   SupportedModes
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
% ZOOMPANCTRL Methods:
%
%   zoompanctrl      - constructor
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

   properties
      CurrentMode          %'none' or one of SupportedModes
      SupportedModes       % multiple-selection from ['point'|zoomin'|'zoomout'|'pan']
      TargetFigure         % figure handle
   end
   properties (Dependent=true)
      
      PanXBounded          %{'on'}|'off' limit panning on x-axis to the zoomed out point
      PanYBounded          %{'on'}|'off' limit panning on y-axis to the zoomed out point
      
      ZoomButtonDownFilter %<function_handle>
      ZoomMotion           %'horizontal'|'vertical'|{'both'}
      ZoomRightClickAction %'InverseZoom'|{'PostContextMenu'}
      ZoomUIContextMenu    %<handle>
      
      PanButtonDownFilter  %<function_handle>
      PanMotion            %'horizontal'|'vertical'|{'both'}
      PanUIContextMenu     %<handle>
   end
   properties (Access=private)
      
      zoom     % figure's zoom object
      pan      % figure's pan object
      
      ax      % fig's axes list
      axlims  % zoomed out limits; each row: [xmin xmax ymin ymax]
      
      panxbound
      panybound
      
      el_figclose % listen to obj.TargetFigure window closure
   end
   
   methods
      
      reset(obj)
      zoomin(obj,axes,factor)
      zoomout(obj,axes,factor)
      V = getAxesZoomOutPoint(obj,axes)

      scanAxes(obj) % scan for the axes on the figure under control
      
      function obj = zoompanctrl(varargin)
         %   OBJ = ZOOMPANCTRL() creates a uipanel with zoom/pan control
         %   buttons on the current figure. Its mode controls the axes in
         %   the current figure.
         %
         %   OBJ = ZOOMPANCTRL(FIG) specifies the figure to be controled by
         %   OBJ.
         %
         %   The input argument may include parameter/value pairs at the
         %   end to specify additional properties of the ZOOMPANCTRL and 
         %   UIPANEL.

         obj = obj@hgsetgetex(varargin{:});
      end
   end

   methods (Access=protected)
      init(obj)
      tf = isfig(obj,val) % error out if val is not valid figure object
      fig = set_targetfigure(obj,h)

      cfg_currentmode(obj,newmode) % used by set.CurrentMode & Buttons' Callbacks
   end
   methods (Access=private)
      panactionpostfcn(obj,h,evt)
      cfg_supportedmodes(obj)
   end
   
   methods  % TO GET & SET DEPENDENT PROPERTIES
      
      function set.CurrentMode(obj,val)
         val = obj.validateproperty('CurrentMode',val);
         obj.cfg_currentmode(val);
         obj.CurrentMode = val;
      end
      
      function set.SupportedModes(obj,val)
         obj.SupportedModes = obj.validateproperty('SupportedModes',val);
         obj.cfg_supportedmodes(); % update CurrentMode options and value
      end
      
      function val = get.TargetFigure(obj)
         val = obj.TargetFigure;
      end
      function set.TargetFigure(obj,val)
         obj.validateproperty('TargetFigure',val);
         
         obj.TargetFigure = obj.set_targetfigure(val);
         if isempty(obj.TargetFigure)
            obj.CurrentMode = 'none'; %#ok
            return;
         end
         
         % initialize figure monitor listeners
         obj.scanAxes();
         
         % set the mode on the new figure
         obj.CurrentMode = obj.CurrentMode; %#ok
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
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
            val = {};
         else
            val = obj.zoom.ButtonDownFilter;
         end
      end
      function set.ZoomButtonDownFilter(obj,val)
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
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
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
            val = {};
         else
            val = obj.zoom.Motion;
         end
      end
      function set.ZoomMotion(obj,val)
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
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
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
            val = {};
         else
            val = obj.zoom.RightClickAction;
         end
      end
      function set.ZoomRightClickAction(obj,val)
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
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
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
            val = {};
         else
            val = obj.zoom.UIContextMenu;
         end
      end
      function set.ZoomUIContextMenu(obj,val)
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
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
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
            val = {};
         else
            val = obj.pan.ButtonDownFilter;
         end
      end
      function set.PanButtonDownFilter(obj,val)
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
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
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
            val = {};
         else
            val = obj.pan.Motion;
         end
      end
      function set.PanMotion(obj,val)
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
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
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
            val = {};
         else
            val = obj.pan.UIContextMenu;
         end
      end
      function set.PanUIContextMenu(obj,val)
         if isempty(obj.TargetFigure) || ~ishghandle(obj.TargetFigure)
            error('OBJ.TargetFigure is not set or invalid.');
         else
            try
               obj.pan.UIContextMenu = val;
            catch ME
               ME.throwAsCaller();
            end
         end
      end
   end
   
   
   methods % passing through the ZOOM & PAN object functions
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % ZOOM object function wrappers
      
      function flag = isAllowAxesZoom(obj,ax)
         if isempty(obj.TargetFigure)
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
         if isempty(obj.TargetFigure)
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
         if isempty(obj.TargetFigure)
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
         if isempty(obj.TargetFigure)
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
         if isempty(obj.TargetFigure)
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
         if isempty(obj.TargetFigure)
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
         if isempty(obj.TargetFigure)
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
         if isempty(obj.TargetFigure)
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
