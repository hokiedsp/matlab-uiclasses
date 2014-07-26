classdef hgenable < hgwrapper
   %HGENABLE   HG object wrapper class with Enable property
   %   HGENABLE adds Enable property to HG object if it is not natively
   %   supported. The implemented Enable property takes values 'off', 'on',
   %   or 'inactive'. This class is designed to be used as the superclass
   %   to an interactive HandleGraphics control class.
   %
   %   HGENABLE properties.
   %      AutoDetach      - Simultaneous deletion of HG object
   %      Enable          - Enable or disable the panel and its contents
   %      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
   %      GraphicsHandle  - Attached HG object handle
   %
   %   HGENABLE methods: HGENABLE object construction:
   %      @HGENABLE/HGENABLE   - Construct HGENABLE object.
   %      delete               - Delete HGENABLE object.
   %
   %   HG Object Association:
   %      attach               - Attach HG panel-type object.
   %      detach               - Detach HG object.
   %      isattached           - True if HG object is attached.
   %
   %   HG Object Control:
   %      enable               - Enable the panel content
   %      disable              - Disable the panel content
   %      inactivate           - Inactivate (visually on, functionally off)
   %                             the panel content.
   %
   %   Getting and setting parameters:
   %      get                  - Get value of HGENABLE object property.
   %      set                  - Set value of HGENABLE object property.
   
   properties (SetObservable,GetObservable)
      Enable   % Enable/Disable state of the panel ['on','inactive','off']
   end
   
   methods (Sealed)
      function enable(obj), [obj.Enable] = deal('on'); end   % enable object
      function disable(obj), [obj.Enable] = deal('off'); end  % disable object
      function inactivate(obj), [obj.Enable] = deal('inactive'); end % make object inactive
   end
   
   properties (Access=private)
      natively_supported % true if HG object natively supports Enable
   end
   
   methods
      
      function obj = hgenable(varargin)
         %HGENABLE/HGENABLE   Construct HGENABLE object.
         %
         %   HGENABLE creates a scalar HGENABLE object. A new
         %   uicontainer object is also created on the current figure and attached
         %   to the HGENABLE object.
         %
         %   HGENABLE(N) creates an N-by-N matrix of HGENABLE
         %   objects
         %
         %   HGENABLE(M,N) creeates an M-by-N matrix of HGENABLE
         %   objects
         %
         %   HGENABLE(M,N,P,...) or HGENABLE([M N P ....])
         %   creates an M-by-N-by-P-by-... array of HGENABLE objects.
         %
         %   HGENABLE(SIZE(A)) creates HGENABLE objects with the
         %   same size as A.
         %
         %   HGENABLE(...,TYPE) uses a different type of container. TYPE may
         %   be one of: 'uicontainer', 'uipanel', 'uiflowcontainer',
         %   'uigridcontainer', 'uitabgroup', 'uitab', and 'detached'. If TYPE =
         %   'detached', created HGENABLE objects is not attached to any HG
         %   container object.
         %
         %   HGENABLE(H) creates HGENABLE objects for the
         %   uipanel objects given in H and the created object has the same
         %   dimension as H.
         %
         %   HGENABLE(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created HGENABLE objects. All
         %   objects are set to the same property values.
         %
         %   HGENABLE(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         obj = obj@hgwrapper(varargin{:});
      end
      
   end
   methods (Access=protected)
      init(obj)
      attach_se(obj,h)   % overriding for HG type check & to activate Enable monitoring
      mode = enable_action(obj)
   end
   
   methods
      function set.Enable(obj,val)
         obj.validateproperty('Enable',val);
         if strcmp(val,obj.Enable), return; end % no change
         obj.Enable = val;
         obj.enable_action();
      end
   end
end
