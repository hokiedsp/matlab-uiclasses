classdef uiflowgridcontainer < uipanelautoresize
   %UIFLOWGRIDCONTAINER   Self-organizing panel with a grid of elements
   %   UIFLOWGRIDCONTAINER is a makeover of UIGRIDCONTAINER with additional
   %   features. UIFLOWGRIDCONTAINER is a subclass of UIPANELEX, and it can
   %   control any panel-type HG object, not limited to uicontainer.
   %
   %   UIFLOWGRIDCONTAINER monitors the children of its attached HG panel and
   %   automatically organizes them on a user-defined grid.
   %
   %   UIFLOWGRIDCONTAINER properties.
   %      AutoExpand          - [{'on'}|'off'] Auto-expand grid
   %      ExcludedChildren    - list of ignored children objects
   %      GridSize            - [nrows ncols]
   %      GridFillingOrder    - 'rowsfirst'|'columnsfirst'
   %      HorizontalAlignment - {'left'}|'center'|'right'
   %      Margins             - [left bottom right top] outside margins of the
   %                            grid in pixels
   %      ElementSpacings     - [horizontal vertical] spacings between 
   %                            elements in pixels
   %      VerticalAlignment   - 'bottom'|'middle'|{'top'}
   %      EliminateEmptySpace - ['on'|'off'] empty grid rows/columns are eliminated 
   %
   %      Elements            - children HG objects in grid
   %      ElementsHeightLimits - height limits in pixels, each row: [min max]
   %      ElementsWidthLimits  - width limits in pixels, each row: [min max]
   %      ElementsLocation     - [row column] element's location on the grid 
   %                            upper-left-corner is [1 1].
   %      ElementsSpan         - How many grid cells to occupy: each row [nrows ncols]
   %      ElementsHorizontalAlignment % 'left'|'center'|'right'
   %      ElementsVerticalAlignment   % 'bottom'|'middle'|'top'
   %      NumberOfElements     - number of elements on the grid
   %
   %      AutoDetach      - Simultaneous deletion of HG object
   %      AutoLayout      - [{'on'}|'off'] to re-layout panel automatically
   %                        if panel content has changed.
   %      Extent          - (read-only) tightest position rectangel encompassing all Children
   %      Enable          - Enable or disable the panel and its contents
   %      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
   %      GraphicsHandle  - Attached HG object handle
   %      ResizeFcnMode   - [{'auto'}|'manual'] Auto to use class-defined ResizeFcn
   %
   %   UIFLOWGRIDCONTAINER methods:
   %   UIFLOWGRIDCONTAINER object construction:
   %      @UIFLOWGRIDCONTAINER/UIFLOWGRIDCONTAINER   - Construct UIFLOWGRIDCONTAINER object.
   %      delete                 - Delete UIFLOWGRIDCONTAINER object.
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
   %      get              - Get value of UIFLOWGRIDCONTAINER object property.
   %      set              - Set value of UIFLOWGRIDCONTAINER object property.
   %
   %   Static methods:
   %      ispanel          - true if HG object can be wrapped by UIFLOWGRIDCONTAINER
   properties (Dependent,SetAccess=private)
      NumberOfElements
   end
   properties (Dependent)
      AutoExpand          % [{'on'}|'off'] Auto-expand grid mode
      GridSize            % [nrows ncols]
      GridFillingOrder    % 'horizontalfirst'|'verticalfirst'
      ElementSpacings     % [horizontal vertical] spacing between cells in pixels (if not distribute)
      Margins             % [left right bottom top] spacing between cells and border
      HorizontalAlignment % 'left'|'center'|'right'
      VerticalAlignment   % 'bottom'|'middle'|'top'
      ExcludedChildren    % list of ignored children objects
      EliminateEmptySpace % ['on'|'off'] empty grid rows/columns are eliminated 
      
      Elements            % children HG objects in grid
      ElementsHeightLimits % height limits in pixels, each row: [min max]
      ElementsWidthLimits  % width limits in pixels, each row: [min max]
      ElementsLocation     % [row column] element's location on the grid ([1 1] is at the upper-left-corner).
      ElementsSpan         % How many grid cells to occupy: each row [nrows ncols]
      ElementsHorizontalAlignment % 'left'|'center'|'right'
      ElementsVerticalAlignment   % 'bottom'|'middle'|'top'
   end
   properties (Access=protected)
      autoexpand % tf
      gridsize   % [nrows ncols]
      rowfirst   % true to fill rows first
      inmargin   % spacing between elements [horizontal vertical]
      outmargin  % outside margin [left right bottom top]
      halign     % horizontal alignment of grid wrt panel
      valign     % vertical alignment of grid wrt panel
      elimempty  % true to eliminate empty row/column
      
      elem_h       % HG objects to be included
      elem_wlims   % elements' width limits
      elem_hlims   % elements' height limits
      elem_subs    % elements' placement subcripts
      elem_span    % elements' sizes in cells
      elem_halign  % elements' horizontal alignment w/in cell
      elem_valign  % elements' vertical alignment w/in cell

      elem_halign_opts  % option strings
      elem_valign_opts  % option strings
      
      defer % set true to hold off on the layout
      
      map   % element grid map (updated by update_grid)
      col_wlims % [min max] of each column width
      row_hlims % [min max] of each row height
   end
   properties (Access=private)
   end
   methods (Static)
   end
   
   methods (Sealed)
      addElement(obj,H,varargin)
      removeElement(obj,H,delopt)
      setElement(obj,H,varargin)
      pv = getElement(obj,H,pn)
   end
   
   methods
      
      function obj = uiflowgridcontainer(varargin)
         %UIFLOWGRIDCONTAINER/UIFLOWGRIDCONTAINER   Construct UIFLOWGRIDCONTAINER object.
         %
         %   UIFLOWGRIDCONTAINER creates a scalar UIFLOWGRIDCONTAINER object. A new
         %   uicontainer object is also created on the current figure and attached
         %   to the UIFLOWGRIDCONTAINER object.
         %
         %   UIFLOWGRIDCONTAINER(N) creates an N-by-N matrix of UIFLOWGRIDCONTAINER
         %   objects
         %
         %   UIFLOWGRIDCONTAINER(M,N) creeates an M-by-N matrix of UIFLOWGRIDCONTAINER
         %   objects
         %
         %   UIFLOWGRIDCONTAINER(M,N,P,...) or UIFLOWGRIDCONTAINER([M N P ....])
         %   creates an M-by-N-by-P-by-... array of UIFLOWGRIDCONTAINER objects.
         %
         %   UIFLOWGRIDCONTAINER(SIZE(A)) creates UIFLOWGRIDCONTAINER objects with the
         %   same size as A.
         %
         %   UIFLOWGRIDCONTAINER(...,'detached') to create detached UIAXESARRAY
         %   object.
         %
         %   UIFLOWGRIDCONTAINER(H) creates UIFLOWGRIDCONTAINER objects for the
         %   uipanel objects given in H and the created object has the same
         %   dimension as H.
         %
         %   UIFLOWGRIDCONTAINER(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created UIFLOWGRIDCONTAINER objects. All
         %   objects are set to the same property values.
         %
         %   UIFLOWGRIDCONTAINER(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         varargin = uipanelex.autoattach(mfilename,@uipanel,...
            {'figure','uipanel','uicontainer','uitab'}, varargin);
         obj = obj@uipanelautoresize(varargin{:});
      end
   end
   methods (Access=protected)
      function types = supportedtypes(obj) % supported HG object types
         % override this function to limit object types
         types = {'figure','uipanel','uicontainer','uitab'};
      end
      
      init(obj) % (overriding)
      
      populate_panel(obj) % populate obj.hg
      layout_panel(obj)   % layout obj.hg children
      update_grid(obj) % update obj.map to reflect changes in GridSize, ElementsLocation
      
      [col_wlims,row_hlims,Ivis,subs] = format_grid(obj)
      
      register_element(obj,h)   % ObjectChildAdded event callback
      unregister_element(obj,h) % ObjectChildRemoved event callback
      
      added = add_element(obj,h) % add new element (no layout update)
      remove_elements(obj,h)  % remove existing elements (no layout update)
      
      subs = nextcellsubs(obj,Nadd) % get the next available unoccupied grid cells

      val = get_contentextent(obj,h) % Returns size of panel content
      
      validategridsize(obj,val)
   end
   
   methods % public property set/get methods
      % NumberOfElements
      function val = get.NumberOfElements(obj)
         val = numel(obj.elem_h);
      end
      
      % GridSize            % [nrows ncols]
      function val = get.GridSize(obj)
         val = obj.gridsize;
      end
      function set.GridSize(obj,val)
         obj.validateproperty('GridSize',val);
         obj.gridsize = val;
         obj.update_grid(); % <- need to be reshape_grid
      end
      
      % GridFillingOrder    % 'horizontalfirst'|'verticalfirst'
      function val = get.GridFillingOrder(obj)
         val = obj.propopts.GridFillingOrder.StringOptions{obj.rowfirst+1};
      end
      function set.GridFillingOrder(obj,val)
         [~,val] = obj.validateproperty('GridFillingOrder',val);
         obj.rowfirst = val==2;
         if obj.isattached
            obj.layout_panel();
         end
      end
      
      % Margin              % element spacing in pixels (if not distribute)
      function val = get.ElementSpacings(obj)
         val = obj.inmargin;
      end
      function set.ElementSpacings(obj,val)
         if isscalar(val)
            val(2) = val;
         end
         obj.inmargin = obj.validateproperty('ElementSpacings',val);
         obj.layout_panel();
      end
      function val = get.Margins(obj)
         val = obj.outmargin;
      end
      function set.Margins(obj,val)
         if isscalar(val)
            val(2:4) = val;
         end
         obj.outmargin = obj.validateproperty('Margins',val);
         obj.layout_panel();
      end
      
      % HorizontalAlignment % 'left'|'center'|'right'|'distribute'
      function val = get.HorizontalAlignment(obj)
         val = obj.propopts.HorizontalAlignment.StringOptions{obj.halign};
      end
      function set.HorizontalAlignment(obj,val)
         [~,obj.halign] = obj.validateproperty('HorizontalAlignment',val);
          % 1:'left'|2:'center'|3:'right'
         obj.layout_panel();
      end
      
      % VerticalAlignment   % 'bottom'|'middle'|'top'|'distribute'
      function val = get.VerticalAlignment(obj)
         val = obj.propopts.VerticalAlignment.StringOptions{obj.valign};
      end
      function set.VerticalAlignment(obj,val)
         [~,obj.valign] = obj.validateproperty('VerticalAlignment',val);
          % 1:'bottom'|2:'middle'|3:'top'
         obj.layout_panel();
      end
      
      % ExcludedChildren    % list of ignored children objects
      function val = get.ExcludedChildren(obj)
         if obj.isattached()
            val = setdiff(handle(get(obj.hg,'Children')),obj.elem_h);
            if isempty(val)
               val = [];
            else
               try
                  val = double(val);
               catch
               end
            end
         else
            val = [];
         end
      end
      function set.ExcludedChildren(obj,val)
         if obj.isattached()
            obj.validateproperty('ExcludedChildren',val);
            obj.remove_elements(val)
         elseif ~isempty(val)
            error('ExcludedChildren can only be set if there is an attached HG object.');
         end
      end
      
      % Elements            % children HG objects in grid
      function val = get.Elements(obj)
         val = obj.elem_h;
         if isempty(val)
            val = [];
         else
            try
               val = double(val);
            catch
            end
         end
      end
      function set.Elements(obj,val)
         if obj.isattached()
            obj.validateproperty('Elements',val);
            val = handle(val);
            obj.remove_elements(setdiff(obj.elem_h,val)); % remove no longer in val
            obj.addElement(setdiff(val,obj.elem_h)); % add not yet in obj.elem_h
         elseif ~isempty(val)
            error('Elements can only be set if there is an attached HG object.');
         end
      end
      
      % ElementsHeightLimits % height limits in pixels, each row: [min max]
      function val = get.ElementsHeightLimits(obj)
         if isempty(obj.elem_h)
            val = [];
         else
            val = obj.elem_hlims;
         end
      end
      function set.ElementsHeightLimits(obj,val)
         if isempty(obj.elem_h) && ~isempty(val)
            error('ElementsHeightLimits can only be set if grid elements are set.');
         else
            obj.validateproperty('ElementsHeightLimits',val);
            obj.elem_hlims = val;
            obj.layout_panel();
         end
      end
      
      % ElementsWidthLimits  % width limits in pixels, each row: [min max]
      function val = get.ElementsWidthLimits(obj)
         if isempty(obj.elem_h)
            val = [];
         else
            val = obj.elem_wlims;
         end
      end
      function set.ElementsWidthLimits(obj,val)
         if isempty(obj.elem_h) && ~isempty(val)
            error('ElementsWidthLimits can only be set if grid elements are set.');
         else
            obj.validateproperty('ElementsWidthLimits',val);
            obj.elem_wlims = val;
            obj.layout_panel();
         end
      end
      
      % ElementsLocation     % [row column] element's location on the grid ([1 1] is at the upper-left-corner).
      function val = get.ElementsLocation(obj)
         if isempty(obj.elem_h)
            val = [];
         else
            val = obj.elem_subs;
         end
      end
      function set.ElementsLocation(obj,val)
         if isempty(obj.elem_h) && ~isempty(val)
            error('ElementsLocation can only be set if grid elements are set.');
         else
            obj.validateproperty('ElementsLocation',val);
            obj.elem_subs = val;
            obj.update_grid();
         end
      end
      
      % ElementsSpan         % How many grid cells to occupy: each row [nrows ncols]
      function val = get.ElementsSpan(obj)
         if isempty(obj.elem_h)
            val = [];
         else
            val = obj.elem_span;
         end
      end
      function set.ElementsSpan(obj,val)
         if isempty(obj.elem_h) && ~isempty(val)
            error('ElementsSpan can only be set if grid elements are set.');
         else
            obj.validateproperty('ElementsSpan',val);
            obj.elem_span = val;
            obj.update_grid();
         end
      end
      
      % ElementsHorizontalAlignment % 'left'|'center'|'right'|'fill'
      function val = get.ElementsHorizontalAlignment(obj)
         if isempty(obj.elem_h)
            val = {};
         else
            val = obj.elem_halign_opts(obj.elem_halign+1);
         end
      end
      function set.ElementsHorizontalAlignment(obj,val)
         if isempty(obj.elem_h) && ~isempty(val)
            error('ElementsHorizontalAlignment can only be set if grid elements are set.');
         else
            obj.elem_halign = obj.validateproperty('ElementsHorizontalAlignment',val);
            obj.layout_panel()
         end
      end
      
      % ElementsVerticalAlignment   % 'bottom'|'middle'|'top'|'fill'
      function val = get.ElementsVerticalAlignment(obj)
         if isempty(obj.elem_h)
            val = [];
         else
            val = obj.elem_valign_opts(obj.elem_valign+1);
         end
      end
      function set.ElementsVerticalAlignment(obj,val)
         if isempty(obj.elem_h) && ~isempty(val)
            error('ElementsVerticalAlignment can only be set if grid elements are set.');
         else
            obj.elem_valign = obj.validateproperty('ElementsVerticalAlignment',val);
            obj.layout_panel()
         end
      end
      
      % AutoExpand - grid auto-expansion mode
      function val = get.AutoExpand(obj)
         val = obj.propopts.AutoExpand.StringOptions{2-obj.autoexpand};
      end
      function set.AutoExpand(obj,val)
         [~,val] = obj.validateproperty('AutoExpand',val);
         obj.autoexpand = logical(2-val);
      end
      
      % EliminateEmptySpace - 'on' to eliminate rows & columns with no
      % element
      function val = get.EliminateEmptySpace(obj)
         val = obj.propopts.EliminateEmptySpace.StringOptions{2-obj.autoexpand};
      end
      function set.EliminateEmptySpace(obj,val)
         [~,val] = obj.validateproperty('EliminateEmptySpace',val);
         obj.elimempty = logical(2-val);
         obj.layout_panel();
      end
   end      
end
