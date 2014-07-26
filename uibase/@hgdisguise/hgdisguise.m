classdef hgdisguise < uipanelautoresize
%HGDISGUISE   a uicontainer-wrapped HG object
%   HGDISGUISE class makes supporting HG objects to an HG object
%   transparent to the users. When any HG object (except for figure and
%   descendents of axes object) is attached to HGDISGUISE object, it shows
%   the HG object as its GraphisHandle, and the properties of the HG object
%   are linked in the set/get methods. However, the HG object is placed on
%   a transparent uicontainer at the time of attachment, and additional HG
%   components may be placed on the uicontainer by the derived class.
%
%   HGDISGUISE inherits and extends Enable property from its superclass,
%   HGENABLE. 
%
%   Unlike other uipanels, GraphicsHandle property and set/get interface
%   of HGDISGUISE connects to uicontrol and not the enclosing panel.
%
%   HGDISGUISE properties.
%      DetachAsIs      - [{'off'}|'on'] 'on' to detach without HG objects
%                        created by class
%      PanelHandle     - Enclosing uicontainer
%      Position        - position rectangle of PanelHandle object
%      Units           - units of PanelHandle object
%
%      AutoDetach       - Simultaneous deletion of HG object
%      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
%                         if panel content has changed.
%      Enable          - Enable or disable the panel and its contents
%      Extent          - (Read-only) tightest position rectangel encompassing all Children
%      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
%      GraphicsHandle  - Attached HG object handle
%      ResizeFcnMode   - {'manual','auto'}
%
%   HGDISGUISE methods:
%   HGDISGUISE object construction:
%      @HGDISGUISE/HGDISGUISE   - Construct HGDISGUISE object.
%      delete                 - Delete HGDISGUISE object.
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
%      get              - Get value of HGDISGUISE object property.
%      set              - Set value of HGDISGUISE object property.
%
%   Static methods:
%      ispanel          - true if HG object can be wrapped by HGDISGUISE
   properties (Dependent,SetAccess=private)
      PanelHandle     % Enclosing panel
   end
   properties (Dependent)
      Position        % position rectangle of hpanel
      Units           % units of hpanel
      DetachAsIs      % 'on' keep obj.hg in obj.hpanel when detached
   end
   properties (Access=protected)
      hpanel
      create_panel_fcn % derived class may change this function handle in init (after hgdisguise.init run)
                       % can create any panel type HG object as long as it
                       % has BackgroundColor property
      removepanel
   end
   properties (Access=private)
      p_listener % listens to parent's background color setting
   end

   methods
      function obj = hgdisguise(varargin)
         %HGDISGUISE/HGDISGUISE   Construct HGDISGUISE object.
         %
         %   HGDISGUISE creates a detached scalar HGDISGUISE object.
         %
         %   HGDISGUISE(H) creates a HGDISGUISE objects for all HG handle
         %   objects in H.
         %
         %   HGDISGUISE(N) creates an N-by-N matrix of HGDISGUISE
         %   objects
         %
         %   HGDISGUISE(M,N) creeates an M-by-N matrix of HGDISGUISE
         %   objects
         %
         %   HGDISGUISE(M,N,P,...) or HGDISGUISE([M N P ....])
         %   creates an M-by-N-by-P-by-... array of HGDISGUISE objects.
         %
         %   HGDISGUISE(SIZE(A)) creates HGDISGUISE objects with the
         %   same size as A.
         %
         %   HGDISGUISE(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created HGDISGUISE objects. All
         %   objects are set to the same property values.
         %
         %   HGDISGUISE(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         % if no H is given, explicitly give empty H to make sure that
         % uipanelex constructor won't autoattach a panel.
         h = [];
         if nargin>0
            arg1 = varargin{1};
            if isempty(h) || all(ishghandle(h(:)))
               h = arg1;
               varargin(1) = [];
            end
         end
         obj = obj@uipanelautoresize(h,varargin{:});
      end
   end
   methods (Access=protected)
      init(obj) % (overriding)
      validatehg(obj,h) % (overriding) to be validate that the HG object is supported by the class
      
      attach_se(obj,h)   % overriding for HG type check & to activate Enable monitoring
      h = detach_se(obj) % overriding to deactivate Enable monitoring
      
      populate_panel(obj) % (empty, to be overridden) populate obj.hg
      unpopulate_panel(obj) % (empty, to be overridden) unpopulate obj.hg

      monitor_bgcolor(obj,p) % set up listener to monitor the change in parent's background color
      c = match_bgcolor(obj,p,pname) % match panel & label background color to the parent's
      
      % overriding uipanelex's to temporarily swap obj.hg with obj.hpanel
      val = get_contentextent(obj,h) % return position of the tightest rectangle encompassing Children
      mode = enable_action(obj)
      
      function h = hgbase_se(obj), h = obj.hpanel; end      
   end
   
   methods
      
      %PanelHandle     % Enclosing panel
      function val = get.PanelHandle(obj)
         if obj.isattached()
            val = obj.hpanel;
            try
               val = double(val);
            catch
            end
         else
            val = [];
         end
      end
      
      %Position
      function val = get.Position(obj)
         if obj.isattached()
            val = get(obj.hpanel,'Position');
         else
            val = '';
         end
      end
      function set.Position(obj,val)
         if obj.isattached()
            obj.validateproperty('Position',val);
            set(obj.hpanel,'Position',val);
         elseif ~isempty(val)
            error('Position cannot be set if not attached.');
         end
      end
      %Units
      function val = get.Units(obj)
         if obj.isattached()
            val = get(obj.hpanel,'Units');
         else
            val = '';
         end
      end
      function set.Units(obj,val)
         if obj.isattached()
            obj.validateproperty('Units',val);
            set(obj.hpanel,'Units',val);
         elseif ~isempty(val)
            error('Units cannot be set if not attached.');
         end
      end
      function val = get.DetachAsIs(obj)
         val = obj.propopts.DetachAsIs.StringOptions{2-obj.removepanel};
      end
      function set.DetachAsIs(obj,val)
         [~,I] = obj.validateproperty('DetachAsIs',val);
         obj.removepanel = ~(I-1);
      end
   end
end
