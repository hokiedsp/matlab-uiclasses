classdef uibuttongroupex < uiflowgridcontainer
   %UIBUTTONGROUPEX   Extended component to exclusively manage radiobuttons/togglebuttons.
   %   UIBUTTONGROUPEX extends the controls of the built-in <a href="matlab:help uibuttongroup">uibuttongroup</a>. It
   %   adds two features to <a href="matlab:help uibuttongroup">uibuttongroup</a> object:
   %
   %   1. Group Enable: This feature is inherited from uipanelex. Setting
   %      Enable property to a disabling value ('off' or 'inacitve') will
   %      disable its child buttons.
   %   2. Auto-Layout: The child button objects are automatically laid out
   %      to form a grid of user-specified size. It uses the inherited
   %      layout engine from UIFLOWGRIDCONTAINER
   %   3. SelectedItem: property returning the index of the selected object.
   %
   %   UIBUTTONGROUPEX is derived from UIFLOWGRIDCONTAINER.
   %
   %   UIBUTTONGROUPEX properties.
   %      DefaultElementStyle  - 'radiobutton'|'togglebutton'
   %      SelectedIndex        - Name of the selected button index
   %      SelectedName         - Index of the selected button index
   %
   %      AutoExpand
   %      ExcludedChildren     - list of ignored children objects
   %      GridSize             - [nrows ncols]
   %      GridFillingOrder     - 'rowsfirst'|'columnsfirst'
   %      HorizontalAlignment  - 'left'|'center'|'right'|'distribute'
   %      Margin               - element spacing in pixels (if not distribute)
   %      VerticalAlignment    - 'bottom'|'middle'|'top'|'distribute'
   %
   %      Elements             - children HG objects in grid
   %      ElementsNames        - Names of the button controls
   %      ElementsHeightLimits - height limits in pixels, each row: [min max]
   %      ElementsWidthLimits  - width limits in pixels, each row: [min max]
   %      ElementsLocation     - [row column] element's location on the grid 
   %                            upper-left-corner is [1 1].
   %      ElementsSpan         - How many grid cells to occupy: each row [nrows ncols]
   %      NumberOfElements     - number of elements on the grid
   %
   %      AutoDetach      - Simultaneous deletion of HG object
   %      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
   %                         if panel content has changed.
   %      ContentExtent   - (read-only) tightest position rectangel encompassing all Children
   %      Enable          - Enable or disable the panel and its contents
   %      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
   %      GraphicsHandle  - Attached HG object handle
   %
   %   UIBUTTONGROUPEX methods:
   %   UIBUTTONGROUPEX object construction:
   %      @UIBUTTONGROUPEX/UIBUTTONGROUPEX   - Construct UIBUTTONGROUPEX object.
   %      delete                 - Delete UIBUTTONGROUPEX object.
   %
   %   HG Grid Element Object Manipulation
   %      addElement    - Add grid elements
   %      removeElement - Remove grid elements
   %      setElement    - Change elements' grid layout properties
   %      getElement    - Get elements' grid layout properties
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
   %      get              - Get value of UIBUTTONGROUPEX object property.
   %      set              - Set value of UIBUTTONGROUPEX object property.
   %
   %   Static methods:
   %      ispanel          - true if HG object can be wrapped by UIFLOWGRIDCONTAINER
   
   properties (Dependent)
      ElementsNames       % 2d cellstr array (empty to skip a grid cell)
      DefaultElementStyle % 'radiobutton'|'togglebutton'
      SelectedIndex       % Name of the selected button index
      SelectedName        % Index of the selected button index
   end
   properties (Access=protected)
      defaultbutton  % function handle to one of the button object fcn
   end
   
   methods
      
      function obj = uibuttongroupex(varargin)
         %UIBUTTONGROUPEX/UIBUTTONGROUPEX   Construct UIBUTTONGROUPEX object.
         %
         %   UIBUTTONGROUPEX creates a scalar UIBUTTONGROUPEX object. A new
         %   uicontainer object is also created on the current figure and attached
         %   to the UIBUTTONGROUPEX object.
         %
         %   UIBUTTONGROUPEX(N) creates an N-by-N matrix of UIBUTTONGROUPEX
         %   objects
         %
         %   UIBUTTONGROUPEX(M,N) creeates an M-by-N matrix of UIBUTTONGROUPEX
         %   objects
         %
         %   UIBUTTONGROUPEX(M,N,P,...) or UIBUTTONGROUPEX([M N P ....])
         %   creates an M-by-N-by-P-by-... array of UIBUTTONGROUPEX objects.
         %
         %   UIBUTTONGROUPEX(SIZE(A)) creates UIBUTTONGROUPEX objects with the
         %   same size as A.
         %
         %   UIBUTTONGROUPEX(H) creates UIBUTTONGROUPEX objects for the
         %   uipanel objects given in H and the created object has the same
         %   dimension as H.
         %
         %   UIBUTTONGROUPEX(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created UIBUTTONGROUPEX objects. All
         %   objects are set to the same property values.
         %
         %   UIBUTTONGROUPEX(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         varargin = uibuttongroupex.autoattach(mfilename,@uibuttongroup,{'uibuttongroup'},varargin);
         obj = obj@uiflowgridcontainer(varargin{:});
      end
   end
   methods (Access=protected)
      function types = supportedtypes(~) % supported HG object types
         types = {'uibuttongroup'};
      end
      init(obj) % (overriding)
      
      set_elemensnames(obj,names) % to implement set.ElementsNames
      
      added = add_element(obj,h) % overriding
      
      check_child(obj,h) % keep uicontrol styles in check
      
      validate_selected(obj,val) % val may be index or string
      [name,I] = get_selected(obj) % get currently selected button index & name
      set_selected(obj,val) % select a button
   end
   methods (Access=protected,Static)
      tf = isvalidbutton(h)
   end
   methods % set/get methods for the public properties
      %ElementsNames               % 2d cellstr array (empty to skip a grid cell)
      function val = get.ElementsNames(obj)
         if obj.isattached() && ~isempty(obj.elem_h)
            val = cell(obj.gridsize);
            [val{:}] = deal('');
            ind = sub2ind(obj.gridsize,obj.elem_subs(:,1),obj.elem_subs(:,2));
            val(ind) = get(obj.Elements,{'String'});
         else
            val = {};
         end
      end
      function set.ElementsNames(obj,val)
         obj.validateproperty('ElementsNames',val);
         obj.set_elementsnames(val);
      end
      
      %DefaultElementStyles % 'radiobutton'|'togglebutton'
      function val = get.DefaultElementStyle(obj)
         val = obj.defaultbutton;
      end
      function set.DefaultElementStyle(obj,val)
         obj.defaultbutton = obj.validateproperty('DefaultElementStyle',val);
      end
      
      %SelectedIndex       % Name of the selected button index
      function val = get.SelectedIndex(obj)
         [~,val] = obj.get_selected();
      end
      function set.SelectedIndex(obj,val)
         if obj.isattached()
            obj.validateproperty('SelectedIndex',val);
            obj.set_selected(val);
         elseif ~isempty(val)
            error('SelectedIndex cannot be set if OBJ is not attached.');
         end
      end
      
      %SelectedName        % Index of the selected button index
      function val = get.SelectedName(obj)
         val = obj.get_selected();
      end
      function set.SelectedName(obj,val)
         if obj.isattached()
            obj.validateproperty('SelectedName',val);
            obj.set_selected(val);
         elseif ~isempty(val)
            error('SelectedName cannot be set if OBJ is not attached.');
         end
      end
   end
end
