classdef hgpropmode < hgsetgetex
   %HGPROPMODE   monitor HG object property
   %   HGPROPMODE monitors an HG object property for its value change. It
   %   provides a mechanism to a HGWRAPPER property similar to Axes XLimMode
   %   property with its XLim property. HGPROPMODE object targets a specific
   %   HG object (GraphicsHandle) and its property (PropertyName) and stores
   %   the property's default property value (DefaultValue).
   %
   %   * The target object and property can be set during construction or with
   %     setTarget() method. The target can also be cleared via clrTarget()
   %     method. Use hasTarget() method to check if target has been set.
   %   * Use setPropertyToDefault() method to set the property value to the
   %     default.
   %   * isValueChanged() returns the current state of the target property. It
   %     returns true if the property value has been changed externally even
   %     if the new value is the default value.
   %   * DefaultValue is the only property value which can be changed. Note
   %     that HGPROPMODE does not validate it.
   %
   %   HGPROPMODE properties.
   %      GraphicsHandle       - (read-only) Simultaneous deletion of HG object
   %      PropertyName         - (read-only) [{'on'}|'off'] to re-layout panel automatically
   %      DefaultValue         - Default property value
   %
   %   HGPROPMODE methods:
   %   HGPROPMODE object construction:
   %      @HGPROPMODE/HGPROPMODE   - Construct HGPROPMODE object.
   %      delete                 - Delete HGPROPMODE object.
   %
   %   HG Property configuration:
   %      setTarget   - Set target object and property
   %      clrTarget   - Clear current target object and property
   %      hasTarget   - True if target object & property are set
   %
   %   Property value management
   %      setPropertyToDefault - reset the property value to the default
   %      hasValueChanged      - true if the property value is changed from the default
   %      forceValueChanged    - manually set ValueChanged flag
   %
   %   Getting and setting parameters:
   %      get              - Get value of HGPROPMODE object property.
   %      set              - Set value of HGPROPMODE object property.
   
   properties (GetAccess=public,SetAccess=private)
      GraphicsHandle   % target HG handle
      PropertyName     % target property name
   end
   properties
      DefaultValue     % default property name
   end
   properties (Access=private)
      lis_destroy       % listens to hg object destruction
      lis_prop_postset  % listens to property value change
      valchg            % true if value has changed
   end
   methods
      
      setTarget(obj,h,pname,defval)
      clrTarget(obj)
      tf = hasTarget(obj)
      
      setPropertyToDefault(obj)
      tf = hasValueChanged(obj)
      forceValueChanged(obj)
      
      function obj = hgpropmode(varargin)
         %HGPROPMODE/HGPROPMODE   Construct HGPROPMODE object.
         %   OBJ = HGPROPMODE() creates a HGPROPMODE object without its target. Use
         %   OBJ.setTarget(...) afterwards to configure the object.
         %
         %   OBJ = HGPROPMODE([M N ...]) creates an M-by-N-by... array of HGPROPMODE
         %   objects without their targets.
         %
         %   HGPROPMODE(H,PROPNAME,DEFAULT) creates a HGPROPMODE object to monitor
         %   the HG handle objects in H for their properties given by PROPNAME. If H
         %   is scalar, PROPNAME must be a string. If H is non-scalar, PROPNAME may
         %   be a string for a common property name or a cellstr array of matching
         %   size. The default value for the property is given in the DEFAULT
         %   argument. Like PROPNAME, DEFAULT maybe a non-cell object to set a
         %   common value or a cell array of matching size as H.
         
         if nargin>1 % given target, must have 3 arguments
            narginchk(3,3);
            varargin(2:end+1) = varargin;
            varargin{1} = size(varargin{1});
         elseif nargin==1
            validateattributes(varargin{1},{'numeric'},{'row','positive','integer','finite'});
         end
         obj = obj@hgsetgetex(varargin{:});
      end
      
      function delete(obj)
         obj.clrTarget();
      end
   end
   methods (Access=protected)
      init(obj) % (overriding)
      argin = processargin(obj,argin)
      prop_postsetfcn(obj) % event listener callback function
   end
end
