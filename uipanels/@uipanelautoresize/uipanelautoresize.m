classdef uipanelautoresize < uipanelex
%UIPANELAUTORESIZE   adding ResizeFcnMode support to a panel-type HG object
%   UIPANELAUTORESIZE class makes supporting HG objects to an HG object
%   transparent to the users. When any HG object (except for figure and
%   descendents of axes object) is attached to UIPANELAUTORESIZE object, it shows
%   the HG object as its GraphisHandle, and the properties of the HG object
%   are linked in the set/get methods. However, the HG object is placed on
%   a transparent uicontainer at the time of attachment, and additional HG
%   components may be placed on the uicontainer by the derived class.
%
%   UIPANELAUTORESIZE inherits and extends Enable property from its superclass,
%   HGENABLE. 
%
%   Unlike other uipanels, GraphicsHandle property and set/get interface
%   of UIPANELAUTORESIZE connects to uicontrol and not the enclosing panel.
%
%   UIPANELAUTORESIZE properties.
%      AutoDetach       - Simultaneous deletion of HG object
%      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
%                         if panel content has changed.
%      Enable          - Enable or disable the panel and its contents
%      Extent          - (Read-only) tightest position rectangel encompassing all Children
%      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
%      GraphicsHandle  - Attached HG object handle
%      ResizeFcnMode   - {'manual','auto'}
%
%   UIPANELAUTORESIZE methods:
%   UIPANELAUTORESIZE object construction:
%      @UIPANELAUTORESIZE/UIPANELAUTORESIZE   - Construct UIPANELAUTORESIZE object.
%      delete                 - Delete UIPANELAUTORESIZE object.
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
%      get              - Get value of UIPANELAUTORESIZE object property.
%      set              - Set value of UIPANELAUTORESIZE object property.
%
%   Static methods:
%      ispanel          - true if HG object can be wrapped by UIPANELAUTORESIZE
   properties
      ResizeFcnMode   % 'auto'|'manual': 'auto' to set UIPANELAUTORESIZE resize function to adjust HG size
   end
   properties (Access=protected)
      defaultresizefcn % default to @(~,~)obj.layout_panel() during initialization, may be changed by derived classes
   end

   methods
      function obj = uipanelautoresize(varargin)
         %UIPANELAUTORESIZE/UIPANELAUTORESIZE   Construct UIPANELAUTORESIZE object.
         %
         %   UIPANELAUTORESIZE creates a detached scalar UIPANELAUTORESIZE object.
         %
         %   UIPANELAUTORESIZE(H) creates a UIPANELAUTORESIZE objects for all HG handle
         %   objects in H.
         %
         %   UIPANELAUTORESIZE(N) creates an N-by-N matrix of UIPANELAUTORESIZE
         %   objects
         %
         %   UIPANELAUTORESIZE(M,N) creeates an M-by-N matrix of UIPANELAUTORESIZE
         %   objects
         %
         %   UIPANELAUTORESIZE(M,N,P,...) or UIPANELAUTORESIZE([M N P ....])
         %   creates an M-by-N-by-P-by-... array of UIPANELAUTORESIZE objects.
         %
         %   UIPANELAUTORESIZE(SIZE(A)) creates UIPANELAUTORESIZE objects with the
         %   same size as A.
         %
         %   UIPANELAUTORESIZE(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created UIPANELAUTORESIZE objects. All
         %   objects are set to the same property values.
         %
         %   UIPANELAUTORESIZE(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         obj = obj@uipanelex(varargin{:});
      end
   end
   methods (Access=protected)
      init(obj) % (overriding)
      populate_panel(obj)
      check_resizefcn(obj,val) % listener callback for hpanel's ResizeFcn
   end
   
   methods
      %ResizeFcnMode   % 'manual'||'auto'
      function set.ResizeFcnMode(obj,val)
         [obj.ResizeFcnMode,val] = obj.validateproperty('ResizeFcnMode',val);
         if obj.isattached() && val==2 % if auto
            set(obj.hg,'ResizeFcn',obj.defaultresizefcn); %#ok
         end
      end
   end
end
