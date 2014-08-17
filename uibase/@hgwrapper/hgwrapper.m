classdef hgwrapper < hgsetgetex & matlab.mixin.Heterogeneous
   %HGWRAPPER   Heterogeneous base class to control an HG object
   %   HGWRAPPER class is a subclass of <a href="matlab:help hgsetgetex">hgsetgetex</a> class (thus is a <a href="matlab:help handle">handle</a>
   %   class) which associates to any HG object via attach/detach methods. The
   %   properties of the HGWRAPPER and its associated HG objects can both be
   %   accessed and be manipulated via the HGWRAPPER object's set/get methods.
   %   None of the attach HG object's properties are stored in HGWRAPPER
   %   object.
   %
   %      classdef MyClass < hgwarpper makes MyClass a subclass of hgwrapper.
   %
   %   HGWRAPPER class features a static protected instance_manager function
   %   (which contains memory-locked persistent database) to keep track of
   %   which HGWRAPPER-HG association. If an HG object is already attached to
   %   an HGWRAPPER object, another HGWRAPPER object cannot be attached to
   %   that HG object until it is first detached from the other object.
   %
   %   In designing HGWRAPPER subclasses, there are several protected features
   %   that could be exploited:
   %
   %   1. detachable property - If derived class needs to be permanently
   %      attached to the first-attached HG object, set detachable=false to
   %      void any attempt to detach the HG object during its lifespan. This
   %      property is publically presented as HGDetachable read-only property.
   %
   %   2. <a href="matlab:help hgwrapper/autoattach">autoattach</a> static method - HGWRAPPER object constructor by default
   %      does not create any HG object. However, static autoattach method is
   %      implemented to aid default atatched HG object creation in its
   %      subclasses. This method shall be called in subclass' constructor
   %      before calling HGWRAPPER constructor. It creates new HG object(s)
   %      and prepend its handles to the input argument list, effectively
   %      making the subclass to call hgwrapper(H,...) constructor.
   %
   %   3  supportedtypes method - If the derived class is specific to certain
   %      HG object types, supportedtypes method can be overridden to return
   %      the cellstr array of the names of the supported HG object types. The
   %      HGWRAPPER's attach method utilizes this method to check for the
   %      valid type of the HG object.
   %
   %   4. hg_listener property - HGWRAPPER object automatically detects the
   %      deletion of its HG object via listenening for ObjectBeingDestroyed
   %      event of the HG object, and the listener is stored in this property.
   %      When HG object is detached, the listener is automatically destroyed.
   %      If the HGWRAPPER subclass needs to listen to other handle.events,
   %      these listener objects may be appended to hg_listener property for
   %      the automatic destruction at the time of detachment.
   %
   %   HGWRAPPER properties.
   %      AutoDetach      - Simultaneous deletion of HG object [{'on'}|'off']
   %      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
   %      GraphicsHandle  - Attached HG object handle
   %      Parent          - Parent HG/HGWRAPPER object of attached HG object
   %
   %   HGWRAPPER events.
   %      HGDeleted - Triggered when attached HG object is deleted and detached (AutoDetach~='off')
   %
   %   HGWRAPPER methods:
   %   HGWRAPPER object construction:
   %      @HGWRAPPER/HGWRAPPER   - Construct HGWRAPPER object.
   %      delete                 - Delete HGWRAPPER object.
   %
   %   HG Object Association:
   %      attach                 - Attach HG object.
   %      copyattach             - Attach copyied HG object.
   %      detach                 - Detach HG object.
   %      isattached             - True if HG object is attached.
   %
   %   Getting and setting parameters:
   %      get              - Get value of HGWRAPPER object property.
   %      set              - Set value of HGWRAPPER object property.
   %
   %   Global HG object management:
   %      HGWRAPPER.findobj   - Find associated HGWRAPPER object
   %
   %   See also: hgwrapper/hgwrapper, hgwrapper/attach, hgwrapper/detach,
   %   hgwrapper/set, hgwrapper/get, hgsetgetex, handle
   
   events
      HGDeleted % when attached HG object is deleted and AutoDetach~='off'
   end
   
   methods (Static=true)
      varargout = findobj(varargin)
   end
   methods (Static=true,Access=protected)
      varargout = instance_manager(command,varargin)
   end
   
   properties (Dependent=true)
      GraphicsHandle % Attached HG handle (assing empty to detach)
      AutoDetach     % 'on'|{'off'}  behavior when object or its attached HG object is deleted
      Parent         % Parent HGWRAPPER/HG object of attached HG object
   end
   properties (Dependent=true,SetAccess=private,GetAccess=public)
      HGDetachable     % 'on'|{'off'}  whether attach/detach may be called after instantiation
   end
   methods (Sealed)
      % methods related to attach/detach HG object
      attach(obj,h,varargin)
      h = detach(obj)
      tf = isattached(obj)
      
      h = hgbase(obj) % return base HG object
      
      p = ancestor(obj,varargin)
      
      % seal superclass functions
      varargout = get(obj,varargin)
      a = set(obj,varargin)
      function disp(obj), obj.disp@hgsetgetex(); end
      function display(obj), obj.display@hgsetgetex(); end
      function C = eq(A,B), C = eq@hgsetgetex(A,B); end
      function C = ne(A,B), C = ne@hgsetgetex(A,B); end
   end
   methods
      copyattach(obj,h,varargin) % attach a copy of specified object
      getdisp(obj) % overriding hgsetgetex
      setdisp(obj) % overriding hgsetgetex
      
      function obj = hgwrapper(varargin) % constructor
         %HGWRAPPER/HGWRAPPER   HGWRAPPER constructor
         %   HGWRAPPER creates a scalar HGWRAPPER object. Its associated HG object
         %   is also created and attached to the HGWRAPPER object.
         %
         %   HGWRAPPER(H) creates HGWRAPPER objects for the HG handle objects given
         %   in H and the created object has the same dimension as H.
         %
         %   HGWRAPPER(N) creates an N-by-N matrix of HGWRAPPER objects
         %
         %   HGWRAPPER(M,N) creeates an M-by-N matrix of HGWRAPPER objects
         %
         %   HGWRAPPER(M,N,P,...) or HGWRAPPER([M N P ....]) creates an
         %   M-by-N-by-P-by-... array of HGWRAPPER objects.
         %
         %   HGWRAPPER(SIZE(A)) creates HGWRAPPER objects with the same size as A.
         %
         %   HGWRAPPER([],M,N,...) constructs detached HGWRAPPER object
         %   array.
         %
         %   HGWRAPPER(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...) sets
         %   the properties of the created HGWRAPPER objects. All objects are set to
         %   the same property values.
         %
         %   HGWRAPPER(...,pn,pv) sets the named properties specified in the cell
         %   array of strings pn to the corresponding values in the cell array pv
         %   for all objects created .  The cell array pn must be 1-by-N, but the
         %   cell array pv can be M-by-N where M is equal to numel(OBJ) so that each
         %   object will be updated with a different set of values for the list of
         %   property names contained in pn.
         
         narginchk(0,inf);
         
         if nargin>0
            if isempty(varargin{1}) % detached, no need to check for HG object argument
               varargin(1) = []; % remove the first argument
            elseif all(ishghandle(varargin{1}))
               
               h = varargin{1};
               
               % if h is integer array & GraphicsHandle is not given in the
               % property name-value pair arguments, treat it as the HG array.
               % Else, treat it as the size array.
               nothg = isnumeric(h(:)) && all(h(:)==floor(h(:))); % potentially not HG
               if nothg
                  pargs = hgsetgetex.unifyproppairs(varargin(2:end));
                  if iscellstr(pargs{1})
                     pnames = pargs(1:2:end);
                  else
                     pnames = pargs{1};
                  end
                  nothg = any(strcmp(pnames,'GraphicsHandle'));
               end
               
               if ~nothg
                  varargin = [{size(h),{'GraphicsHandle'},num2cell(h(:))},varargin(2:end)];
               end
            end
         end
                  
         % initialize the object with set properties
         obj = obj@hgsetgetex(varargin{:});
         
         % add the object to the instance manager
         if numel([obj.hg])~=numel(obj)
            hgwrapper.instance_manager('add',obj);
         end
      end
      
      function delete(obj) % destructor
         
         obj.indelete = true;
         obj.detachable = true;
         
         % first attempt to detach HG object (if attached)
         h = obj.detach(); % detaches wrapper object from HG object
         if ~(isempty(h) || obj.autodetach)
            obj.autodetach = true;
            h(~ishghandle(h)) = [];
            delete(h); % delete the associated HG object as well
         end
         
         % update the instance manager
         hgwrapper.instance_manager('remove',obj);
         
      end
   end
   
   properties (Access=protected)
      hg            % handle object
      hg_listener   % handle.listener array
      
      autodetach    % true to destroy together
      attachable    % false for hgwrapper, shall be made false for all others in init()
      detachable    % true to error out on detach() call
      indelete      % true during destruction
   end
   methods (Static=true,Access=protected)
      argin = autoattach(clsname,hgobj,types,argin) % explicit default constructor
      [HgGiven,prt,vis,args] = getcritcalhgprops(args,Iend) % get parent and visible properties
   end
   methods (Access=protected)

      [vals,names] = gethgprops(obj,names)
      a = sethgprop(obj,name,val)
      
      init(obj) % implementing hgsetgetex.init
      validatehg(obj,h) % to be validate that the HG object is supported by the class
      
      attach_se(obj,h) % scalar-element attach
      h = detach_se(obj) % scalar-element detach
      
      val = get_autodetach(obj) % get autodetach flag
      set_autodetach(obj,val) % set autodetach flag
      
      function h = hgbase_se(obj), h = obj.hg; end % scalar-element return base HG class
      
      function deletefcn(obj) % attached object's DeleteFcn
         % if OBJ is still valid and is set to autodetach, delete OBJ
         if obj.isvalid()
            if obj.autodetach
               obj.detach();
               notify(obj,'HGDeleted');
            elseif isvalid(obj)
               obj.autodetach = true;
               delete(obj);
            end
         end
      end
      
      function types = supportedtypes(~) % supported HG object types
         % override this function to limit object types
         types = {};
      end
   end
   
   methods
      % GraphicsHandle Attached HG handle (assing empty to detach)
      function val = get.GraphicsHandle(obj)
         val = obj.hg;
         try
            val = double(val);
         catch
         end
      end
      function set.GraphicsHandle(obj,val)
         obj.attach(val);
      end
      
      % Detachable 'on'|'off'
      function val = get.HGDetachable(obj)
         val = obj.propopts.HGDetachable.StringOptions{2-obj.autodetach};
      end
      
      % AutoDetach     % 'on'|{'off'}  behavior when object or its attached HG object is deleted
      function val = get.AutoDetach(obj)
         val = obj.propopts.AutoDetach.StringOptions{obj.get_autodetach()};
      end
      function set.AutoDetach(obj,val)
         [~,val] = obj.validateproperty('AutoDetach',val);
         obj.set_autodetach(val);
      end
      
      % Parent - hgwrapper object if attached or HG object
      function val = get.Parent(obj)
         if obj.isattached()
            val = get(obj.hgbase(),'Parent');
            hgwobj = hgwrapper.findobj(val);
            if ~isempty(hgwobj)
               val = hgwobj;
            end
         else
            val = [];
         end
      end
      function set.Parent(obj,val)
         if ~obj.isattached()
            error('Parent property can be set only if %s is attached to an HG object',class(obj));
         end
         obj.validateproperty('Parent',val);
         if isa(val,'hgwrapper')
            val = val.GraphicsHandle;
         end
         set(obj.hgbase(),'Parent',val);
      end
   end
   
   methods (Access=protected,Sealed) % for heterogeneous array support
      function initprops(obj,varargin), initprops@hgsetgetex(obj,varargin{:}); end
   end
end
