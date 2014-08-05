classdef uiaxesarray < uiflowgridcontainer
%UIAXESARRAY   Multiple axes on a grid: Glorified subplots
%   UIAXESARRAY objects lay out multiple axes on a grid. UIAXESARRAY is
%   based on UIGRIDFLOWCONTAINER class, only allowing axes elements.
%
%   As axes are added to the attached panel (default to uicontainer), they
%   are automatically join the auto-expanding grid of axes. To form a
%   column of axes, set GridFillingOrder to 'rowfirst'; conversely, to form
%   a row of axes, set GridFillingOrder to 'columnfirst'.
%
%   Features:
%
%   1. Auto-Layout: The child axes objects are automatically laid out
%      to form a grid of user-specified size. Axes Position properties are
%      ignored and the widths and heights are determined by
%      ElementsWidthLimits and ElementsHeightLimits properties. It uses the
%      inherited layout engine from UIFLOWGRIDCONTAINER. This feature can
%      be turned off by setting the AutoLayout property to 'off'.
%   2. Column- or row-wise axis linking via XLimLinkedColumns and
%      YLimLinkedRows, respectively. Axes can only be linked if they are
%      non-spanning. Spanned axes are ignored by the linker.
%   3. Group Enable: Setting Enable property to a disabling value ('off' or
%      'inacitve') will disable any descenedent objects if they have Enable
%      properties.
%
%   UIAXESARRAY is derived from UIFLOWGRIDCONTAINER.
%
%   UIAXESARRAY properties.
%      IncludeLabels     - [{'on'}|'off'] to fit the axes and its text 
%                          labels within grid cell.
%      XLimLinkedColumns - Column indices, x-axes on which are linked
%      YLimLinkedRows    - Row indices, y-axes on which are linked
%
%      AutoExpand           - [{'on'}|'off'] 'on' to expand grid size as
%                             needed
%      ExcludedChildren     - list of ignored children objects
%      GridSize             - [nrows ncols]
%      GridFillingOrder     - 'rowsfirst'|'columnsfirst'
%      HorizontalAlignment  - 'left'|'center'|'right'|'distribute'
%      Margin               - element spacing in pixels (if not distribute)
%      VerticalAlignment    - 'bottom'|'middle'|'top'|'distribute'
%
%      Elements             - children HG objects in grid
%      ElementsHeightLimits - height limits in pixels, each row: [min max]
%      ElementsWidthLimits  - width limits in pixels, each row: [min max]
%      ElementsLocation     - [row column] element's location on the grid 
%                            upper-left-corner is [1 1].
%      ElementsSpan         - How many grid cells to occupy: each row [nrows ncols]
%      NumberOfElements     - number of elements on the grid
%
%      AutoDetach      - Simultaneous deletion of HG object
%      AutoLayout      - [{'on'}|'off'] to re-layout panel automatically
%                        if panel content has changed.
%      Extent          - (read-only) tightest position rectangel encompassing all Children
%      Enable          - Enable or disable the panel and its contents
%      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
%      GraphicsHandle  - Attached HG object handle
%
%   UIAXESARRAY methods:
%   UIAXESARRAY object construction:
%      @UIAXESARRAY/UIAXESARRAY   - Construct UIAXESARRAY object.
%      delete                 - Delete UIAXESARRAY object.
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
%      get              - Get value of UIAXESARRAY object property.
%      set              - Set value of UIAXESARRAY object property.
%
%   Static methods:
%      ispanel          - true if HG object can be wrapped by UIFLOWGRIDCONTAINER

% Revision - (Dec. 11, 2013)
% Written by: Takeshi Ikuma (tikuma@hotmail.com)
% Created: Dec. 11, 2013
% Revision History:
%    - (Dec. 11, 2013) - Initial release

   properties
      
      XScroll % ['on',{'off'}]
      XScrollMode % ['allaxes' 'leftcolumn' 'rightcolumn']
      YScroll % ['on',{'off'}]
      YScrollMode % ['allaxes' 'bottomrow' 'toprow']
      
      XLimLinkedColumns
      YLimLinkedRows
   end
   properties (Dependent)
      IncludeLabels      % [{'on'}|'off'] 'on' to fit the axes and its text labels within grid cell
   end
   properties (Access=protected)
      
      hscroll
      
      inclabel
      xlink_listeners
      ylink_listeners
   end
   
   methods
      
      function obj = uiaxesarray(varargin)
         %UIAXESARRAY/UIAXESARRAY   Construct UIAXESARRAY object.
         %
         %   UIAXESARRAY creates a scalar UIAXESARRAY object. A new uicontainer
         %   object is also created on the current figure and attached to the
         %   UIAXESARRAY object.
         %
         %   UIAXESARRAY(N) creates an N-by-N matrix of UIAXESARRAY objects
         %
         %   UIAXESARRAY(M,N) creeates an M-by-N matrix of UIAXESARRAY objects
         %
         %   UIAXESARRAY(M,N,P,...) or UIAXESARRAY([M N P ....]) creates an
         %   M-by-N-by-P-by-... array of UIAXESARRAY objects.
         %
         %   UIAXESARRAY(SIZE(A)) creates UIAXESARRAY objects with the same size as
         %   A.
         %
         %   UIAXESARRAY(...,TYPE) uses a different type of container. TYPE may be
         %   'detached' if not desired to have an HG object pre-attached or can be 
         %   any of the following HG objects: 'uipanel', 'uicontainer' (default),
         %   or 'uitab'.
         %
         %   UIAXESARRAY(H) creates UIAXESARRAY objects for the uipanel objects
         %   given in H and the created object has the same dimension as H.
         %
         %   UIAXESARRAY(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...) sets
         %   the properties of the created UIAXESARRAY objects. All objects are set
         %   to the same property values.
         %
         %   UIAXESARRAY(...,pn,pv) sets the named properties specified in the cell
         %   array of strings pn to the corresponding values in the cell array pv
         %   for all objects created .  The cell array pn must be 1-by-N, but the
         %   cell array pv can be M-by-N where M is equal to numel(OBJ) so that each
         %   object will be updated with a different set of values for the list of
         %   property names contained in pn.
         
         varargin = uiaxesarray.autoattach(mfilename,@uicontainer,{'uicontainer','uipanel','uitab'},varargin);
         obj = obj@uiflowgridcontainer(varargin{:});
      end
   end
   methods (Access=protected)
      function types = supportedtypes(~) % supported HG object types
         types = {'uicontainer','uipanel','uitab'};
      end

      init(obj)
      layout_panel(obj)
      added = add_element(obj,h)
      linkaxes(obj,cols,val)
   end   
   methods
      % IncludeLabels
      function val = get.IncludeLabels(obj)
         val = obj.propopts.IncludeLabels.StringOptions{2-obj.inclabel};
      end
      function set.IncludeLabels(obj,val)
         [~,val] = obj.validateproperty('IncludeLabels',val);
         obj.inclabel = logical(2-val);
         obj.layout_panel();
      end
      
      % XLimLinkedColumns
      function set.XLimLinkedColumns(obj,val)
         obj.validateproperty('XLimLinkedColumns',val);
         obj.linkaxes(true,val);
      end
      %YLimLinkedRows
      function set.YLimLinkedRows(obj,val)
         obj.validateproperty('YLimLinkedColumns',val);
         obj.linkaxes(false,val);
      end
   end
end
