
classdef hgpropsync < hgsetgetex
   %HGPROPSYNC   Auto-synchronize HG object property
   %   HGPROPSYNC monitors an HG object property for its value change. When
   %   a new value is set (listening to the PostSet event) on the monitored
   %   source HG object, the value is then copied to the target HG
   %   object(s). The target property does not need to be the same as the
   %   source property.
   %
   %   HGPROPMODE properties.
   %      Enabled          - ['on'|'off']
   %      SourceHandle     - (read-only) Source HG object handle
   %      SourceProperty   - (read-only) Source HG object property name
   %      TargetHandles    - (read-only) Target HG object handles
   %      TargetProperties - (read-only) Target HG object property names
   %
   %   HGPROPMODE methods:
   %   HGPROPMODE object construction:
   %      @HGPROPMODE/HGPROPMODE   - Construct HGPROPMODE object.
   %      delete                 - Delete HGPROPMODE object.
   %
   %   HG Property configuration:
   %      setSource   - sets source HG object and its property
   %      clrSource   - clears the source object & property
   %      setTarget   - Set target object and property
   %      clrTarget   - Clear current target object and property
   %
   %   Getting and setting parameters:
   %      get              - Get value of HGPROPMODE object property.
   %      set              - Set value of HGPROPMODE object property.
   
   properties (GetAccess=public,SetAccess=private)
      SourceHandle     % source HG handle
      SourceProperty   % source property name
      TargetHandles    % target HG handles
      TargetProperties % target property names
   end
   properties (Dependent)
      Enabled     % ['on'|'off']
   end
   properties (Access=private)
      srclis_destroy       % listens to hg object destruction
      srclis_prop_postset  % listens to property value change
      dstlis_destroy       % listens to hg object destruction
   end
   methods
      setSource(obj,h,pname)
      clrSource(obj)
      setTarget(obj,h,pnames)
      clrTarget(obj)
     
      function obj = hgpropsync(varargin)
%HGPROPSYNC/HGPROPSYNC   Construct HGPROPSYNC object.
%   OBJ = HGPROPSYNC() creates a HGPROPSYNC object without its target. Use
%   OBJ.setTarget(...) afterwards to configure the object.
%
%   OBJ = HGPROPSYNC([M N ...]) creates an M-by-N-by... array of HGPROPSYNC
%   objects without their targets.
%
%   HGPROPSYNC(Hsource,PROPNAME,Htarget) creates a HGPROPSYNC object to
%   monitor the HG handle object in Hsource for its properties given by
%   PROPNAME. The source property value is synchronized to the property
%   with the same name of the HG handle objects in Htarget.
%
%   HGPROPSYNC(Hsource,PROPNAMEsource,Htarget,PROPNAMEtarget) specifies the
%   target property name if it is different from the source property.
%   PROPNAMEtarget may be a string containing the property name or a
%   cellstr array of the property names, matching the size of Htarget.
         
         if nargin>1 % given target, must have 3 arguments
            narginchk(3,4);
            varargin(2:end+1) = varargin;
            varargin{1} = size(varargin{1});
         elseif nargin==1
            validateattributes(varargin{1},{'numeric'},{'row','positive','integer','finite'});
         end
         obj = obj@hgsetgetex(varargin{:});
      end
      
      function delete(obj)
         obj.clrSource();
         obj.clrTarget();
      end
   end
   methods (Access=protected)
      init(obj) % (overriding)
      argin = processargin(obj,argin)
      prop_postsetfcn(obj,newval) % event listener callback function
   end
   
   methods
      function val = get.Enabled(obj)
         if isempty(obj.srclis_prop_postset)
            val = '';
         else
            val = get(obj.srclis_prop_postset,'Enabled');
         end
      end
      function set.Enabled(obj,val)
         if isempty(obj.srclis_prop_postset)
            if ~isempty(val)
               error('Enabled can be set only if SourceHandle is defined.');
            end
         else
            obj.validateproperty('Enabled',val);
            set(obj.srclis_prop_postset,'Enabled',val);
         end
      end
   end
end
