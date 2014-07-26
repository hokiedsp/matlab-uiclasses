classdef uipanelgroup < uipanelex
   %UIPANELGROUP   An HG panel with subpanels
   %   UIPANELGROUP creates a <a href="matlab:help uicontainer">uicontainer</a> (default) or <a href="matlab:help uipanel">uipanel</a> HG object,
   %   which houses multiple canvas panels (subpanels). UIPANELGROUP is inherits <a href="matlab:help uiscrollbar>uiscrollbar</a>.
   %
   %   The total canvas size are automatically determined so that everywhere
   %   on all canvases can be reached vai scrolling.
   %
   %   UIPANELGROUP properties.
   %      Panels                 - HG object handles of the subpanels
   %      PanelPositions         - size of the subpanels (in CanvasUnits)
   %      PanelUnits             - units of the subpanel sizes
   %      DefaultPanelType       - Default object type of the canvases
   %      NumberOfPanels         - Number of subpanels
   %
   %   General properties:
   %      AutoDetach      - Simultaneous deletion of HG object
   %      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
   %                         if panel content has changed.
   %      Enable          - Enable or disable the panel and its contents
   %      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
   %      GraphicsHandle  - Attached HG object handle
   %
   %   UIPANELGROUP methods:
   %   UIPANELGROUP object construction:
   %      @UIPANELGROUP/UIPANELGROUP   - Construct UIPANELGROUP object.
   %      delete                       - Delete UIPANELGROUP object.
   %
   %   HG Object Association:
   %      attach                 - Attach HG panel-type object.
   %      detach                 - Detach HG object.
   %      isattached             - True if HG object is attached.
   %
   %   HG Object Control:
   %      enable               - Enable the panel content
   %      disable              - Disable the panel content
   %      inactivate           - Inactivate (visually on, functionally off)
   %                             the panel content.
   %
   %   Getting and setting parameters:
   %      get              - Get value of UIPANELGROUP object property.
   %      set              - Set value of UIPANELGROUP object property.

   properties (Dependent)
      Panels                 % Handles of the subpanels
      PanelPositions         % Positions of the subpanels
      PanelUnits             % Units of the subpanels
      NumberOfPanels         % Number of subpanels
      DefaultPanelType       % Default object type of the canvases
   end

   properties (Access=private)
      default_type
   end

   methods (Sealed)
      add(obj,H)           % add subpanels
      remove(obj,H,delopt) % remove/delete subpanels (but HG remains on the panel)
   end
   
   methods
      function obj = uipanelgroup(varargin)
         %UIPANELGROUP/UIPANELGROUP() instantiates UIPANELGROUP class
         %
         %   UIPANELGROUP creates a scalar UIPANELGROUP object. Two new uicontainer
         %   objects are also created on the current figure and attached to the
         %   UIPANELGROUP object.
         %
         %   UIPANELGROUP(N) creates an N-by-N matrix of UIPANELGROUP objects
         %
         %   UIPANELGROUP(M,N) creeates an M-by-N matrix of UIPANELGROUP objects
         %
         %   UIPANELGROUP(M,N,P,...) or UIPANELGROUP([M N P ....]) creates an
         %   M-by-N-by-P-by-... array of UIPANELGROUP objects.
         %
         %   UIPANELGROUP(SIZE(A)) creates UIPANELGROUP objects with the same size
         %   as A.
         %
         %   UIPANELGROUP(...,TYPE) attaches a different type of container. TYPE may
         %   be one of: 'uicontainer', 'uipanel', and 'detached'. If TYPE =
         %   'detached', created UIPANELGROUP objects is not attached to any HG
         %   container object.
         %
         %   UIPANELGROUP(H) creates UIPANELGROUP objects for the panel-type objects
         %   given in H and the created object has the same dimension as H. H may be
         %   'uipanel', 'uicontainer', or 'uiflowcontainer'. H must have no children
         %   or all its children to be a panel-type objects.
         %
         %   UIPANELGROUP(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created UIPANELGROUP objects. All objects
         %   are set to the same property values.
         %
         %   UIPANELGROUP(...,pn,pv) sets the named properties specified in the cell
         %   array of strings pn to the corresponding values in the cell array pv
         %   for all objects created .  The cell array pn must be 1-by-N, but the
         %   cell array pv can be M-by-N where M is equal to numel(OBJ) so that each
         %   object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         varargin = uipanelex.autoattach(mfilename,@uipanel,varargin);
         obj = obj@uipanelex(varargin{:});
         
      end
   end
   methods (Access=protected)
      function types = supportedtypes(~) % supported HG object types
         types = {'uipanel','uicontainer'};
      end
      
      init(obj)
      validatehg(obj,h) % (overriding) additional check in case uiflowcontainer is given
      
      populate_panel(obj)   % populate the panel content after attachment
      set_subpanels(obj,hpanels) % implements set.Panels
      set_numsubpanels(obj,N)  % implements set.NumberOfPanels
      
      register_subpanel(obj,h,toadd)  % event callback to register/unregister the subpanel
      set_subpanel_listeners(obj,h) % add subpanel property listeners to obj.content_listener array
      
      sync_subpanelunits(obj,h,val) % to synchronize subpanel Units property
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   methods % Property set/get functions
   
      function val = get.Panels(obj)
         val = flipud(get(obj.hg,'Children')); % in drawing order
      end
      function set.Panels(obj,val)
         if obj.isattached()
            obj.validateproperty('Panels',val);
            obj.set_subpanels(val,get(obj.hg,'Children'));
            obj.layout_panel(); % <- for subclass, no action for plain uipanelgroup
         elseif ~isempty(val)
            error('PanelPositions cannot be set if OBJ is not attached.');
         end
      end
      
      function val = get.PanelPositions(obj)
         hc = get(obj.hg,'Children');
         if isempty(hc)
            val = [];
         else
            val = cell2mat(get(hc,{'Position'}));
         end
      end
      function set.PanelPositions(obj,val)
         if obj.isattached()
            obj.validateproperty('PanelPositions',val);
            hc = get(obj.hg,'Children');
            set(hc,'Position',mat2cell(val,ones(numel(hc),1),4));
         elseif ~isempty(val)
            error('PanelPositions cannot be set if OBJ is not attached.');
         end
      end
      
      function val = get.PanelUnits(obj)
         val = '';
         if obj.isattached()
            hc = get(obj.hg,'Children');
            if isempty(hc)
               val = get(obj.hg,'Units');
            else
               val = get(hc(1),'Units');
            end
         end
      end
      function set.PanelUnits(obj,val)
         if obj.isattached()
            val = obj.validateproperty('PanelUnits',val);
            hc = get(obj.hg,'Children');
            if ~isempty(hc)
               set(hc(1),'Units',val);
            elseif ~isempty(val)
               warning('uipanelgroup:noPanels','Ignored an attempt ot set PanelUnits (no subpanels present).');
            end
         elseif ~isempty(val)
            error('PanelPositions cannot be set if OBJ is not attached.');
         end
      end
      
      %NumberOfPanels - Number of subpanels
      function val = get.NumberOfPanels(obj)
         val = numel(get(obj.hg,'Children'));
      end
      function set.NumberOfPanels(obj,val)
         if obj.isattached()
            obj.validateproperty('NumberOfPanels',val);
            obj.set_numsubpanels(val);
         elseif ~isempty(val)
            error('NumberOfPanels cannot be set if OBJ is not attached.');
         end
      end

      % Type of canvas panel to be added when NumberOfPanels are increased
      function val = get.DefaultPanelType(obj)
         if isequal(obj.default_type,@uipanel)
            val = 'uipanel';
         elseif isequal(obj.default_type,@uicontainer)
            val = 'uicontainer';
         else
            val = obj.default_type;
         end
      end
      function set.DefaultPanelType(obj,val)
         val = obj.validateproperty('DefaultPanelType',val);
         if ischar(val)
            obj.default_type = str2func(val);
         else
            obj.default_type = val;
         end
      end
   end
   
end
