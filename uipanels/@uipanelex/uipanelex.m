classdef uipanelex < hgenable
%UIPANELEX   Panel-type HG object wrapper with feature extension
%   UIPANELEX controls a panel-type HandleGraphics object, which
%   has a 'Children' property. It includes:
%    * <a href="matlab:help figure">figure</a>
%    * <a href="matlab:help uipanel">uipanel</a> (default)
%    * <a href="matlab:help uibuttongroup">uibuttongroup</a>
%    * <a href="matlab:help uicontainer">uicontainer</a> (<a href="http://undocumentedmatlab.com/blog/matlab-layout-managers-uicontainer-and-relatives/#uicontainer">click for more info</a>)
%    * <a href="matlab:help uiflowcontainer">uiflowcontainer</a> (<a href="http://undocumentedmatlab.com/blog/matlab-layout-managers-uicontainer-and-relatives/#uiflowcontainer">click for more info</a>)
%    * <a href="matlab:help uigridcontainer">uigridcontainer</a> (<a href="http://undocumentedmatlab.com/blog/matlab-layout-managers-uicontainer-and-relatives/#uigridcontainer">click for more info</a>)
%    * <a href="matlab:help uitabgroup">uitabgroup</a> (<a href="http://undocumentedmatlab.com/blog/tab-panels-uitab-and-relatives">click for more info</a>)
%    * <a href="matlab:help uitab">uitab</a> (<a href="http://undocumentedmatlab.com/blog/tab-panels-uitab-and-relatives">click for more info</a>)
%
%   UIPANELEX inherits and extends Enable property from its superclass,
%   HGENABLE. It adds a mechanism to control Enable properties of all child
%   objects. When UIPANELEX's Enable is 'on', its child objects own Enable
%   property value is reflected in their appearances. If UIPANELEX's Enable
%   is either 'off' or 'inactive', the child object appearance follows the
%   panel's Enable value; however, its actual Enable value remains that of
%   itself.
%
%   UIPANELEX properties.
%      AutoDetach       - Simultaneous deletion of HG object
%      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
%                         if panel content has changed.
%      Enable           - Enable or disable the panel and its contents
%      EnableMonitoring - [{'on'}|'off'] to enable monitoring of panel
%                         descendents
%      Extent           - (Read-only) tightest position rectangel encompassing all Children
%      HGDetachable     - (Read-only) Indicate whether attach/detach can be called
%      GraphicsHandle   - Attached HG object handle
%
%   UIPANELEX methods:
%   UIPANELEX object construction:
%      @UIPANELEX/UIPANELEX   - Construct UIPANELEX object.
%      delete                 - Delete UIPANELEX object.
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
%      get              - Get value of UIPANELEX object property.
%      set              - Set value of UIPANELEX object property.
%
%   Static methods:
%      ispanel          - true if HG object can be wrapped by UIPANELEX
   
   properties (Dependent)
      AutoLayout
      Extent % tightest position rectangel encompassing all Children
   end
   properties (Access=protected)
      autolayout
      content_listeners % add any property listeners that listens to the evens of obj.hg's children
   end
   properties (Access=private)
      % variables for descendent's enable state monitoring
      d_hgs % HG object monitor
      d_hg_states % HG object Enable state
      d_hg_listeners % HG object Enable property listener
      d_hgws % hgwrapper object monitor
      d_hgw_states % hgwrapper object Enable state
      d_hgw_listeners % hgwrapper object Enble property monitor
   end
   methods (Static)
      tf = ispanel(h) % returns true if considered a panel-type object
   end
   methods (Sealed)
      layout(obj) % layout the content
      autosize(obj) % adjust base HG Position to match the content extent
   end
   methods
      
      function obj = uipanelex(varargin)
         %UIPANELEX/UIPANELEX   Construct UIPANELEX object.
         %
         %   UIPANELEX creates a scalar UIPANELEX object. A new
         %   uicontainer object is also created on the current figure and attached
         %   to the UIPANELEX object.
         %
         %   UIPANELEX(N) creates an N-by-N matrix of UIPANELEX
         %   objects
         %
         %   UIPANELEX(M,N) creeates an M-by-N matrix of UIPANELEX
         %   objects
         %
         %   UIPANELEX(M,N,P,...) or UIPANELEX([M N P ....])
         %   creates an M-by-N-by-P-by-... array of UIPANELEX objects.
         %
         %   UIPANELEX(SIZE(A)) creates UIPANELEX objects with the
         %   same size as A.
         %
         %   UIPANELEX(...,TYPE) uses a different type of container. TYPE may
         %   be 'detached' if not desired to have an HG object pre-attached or a
         %   name of any valid function which return an HG object with a "Children"
         %   property; for instance, it could be 'figure', 'uipanel', 'uicontainer',
         %   'uiflowcontainer', 'uigridcontainer', 'uitabgroup', and 'uitab'.
         %
         %   UIPANELEX(H) creates UIPANELEX objects for the
         %   uipanel objects given in H and the created object has the same
         %   dimension as H.
         %
         %   UIPANELEX(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created UIPANELEX objects. All
         %   objects are set to the same property values.
         %
         %   UIPANELEX(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         varargin = uipanelex.autoattach(mfilename,@uipanel,varargin);
         obj = obj@hgenable(varargin{:});
      end
   end
   methods (Access=protected)
      init(obj) % (overriding)
      validatehg(obj,h) % (overriding) to be validate that the HG object is supported by the class
      
      attach_se(obj,h)   % overriding for HG type check & to activate Enable monitoring
      h = detach_se(obj) % overriding to deactivate Enable monitoring
      
      autosize_se(obj) % adjust base HG Position to match the content extent (for individual scalar attached OBJ)

      populate_panel(obj) % (empty, to be overridden) populate obj.hg
      tf = layout_panel(obj)   % (empty, to be overridden) layout obj.hg children
      unpopulate_panel(obj) % (empty, to be overridden) unpopulate obj.hg
      
      val = get_contentextent(obj,h) % return position of the tightest rectangle encompassing Children
      delete_listeners(obj,h) % ObjectChildRemoved event callback to remove unused listeners
      
      mode = enable_action(obj) % (overriding) action to be performed when Enable property is changed
      d_update(obj,I,ishg) % Enable monitoring: to intercept an attempt to change descendent's Enable property during a disabled state
      d_revert(obj)   % Enable monitoring: to revert all descendent's Enable proeprties to their own states
   end
   
   methods (Access=protected,Static)
      argin = autoattach(clsname,hgobj,argin)
      
      sz = get_displayarea(h) % return the size of the actual visible panel area
      bmargin = get_bordermargins(h) % return the total panel border thickness
   end
   
   methods
      function val = get.Extent(obj)
         val = obj.get_contentextent();
      end
      
      %AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
      function val = get.AutoLayout(obj)
         val = obj.propopts.AutoLayout.StringOptions{obj.autolayout+1};
      end
      function set.AutoLayout(obj,val)
         [~,val] = obj.validateproperty('AutoLayout',val);
         obj.autolayout = logical(val-1);
         % if turned on, layout now.
         if obj.autolayout
            obj.layout_panel();
         end
      end
   end
end
