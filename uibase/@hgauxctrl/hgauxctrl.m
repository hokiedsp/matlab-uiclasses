classdef hgauxctrl < hgdisguise
   %HGAUXCTRL   a uicontainer wrapped UICONTROL object with AUX UICONTROL
   %   HGAUXCTRL places an auxiallary uicontrol next to the main uicontrol.
   %
   %   GraphicsHandle property of HGAUXCTRL returns the main HG object
   %   handle, and set/get methods of HGAUXCTRL object is linked with the
   %   properties of the main HG object.
   %
   %   HGAUXCTRL properties.
   %
   %      PanelHandle     - Enclosing uicontainer
   %      Parent          - parent of PanelHandle object
   %      Position        - position rectangle of PanelHandle object
   %      ResizeFcnMode   - {'manual','auto'}
   %      Units           - units of PanelHandle object
   %
   %      AutoDetach       - Simultaneous deletion of HG object
   %      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
   %                         if panel content has changed.
   %      Enable          - Enable or disable the panel and its contents
   %      Extent          - (Read-only) tightest position rectangel encompassing all Children
   %      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
   %      GraphicsHandle  - Attached HG object handle
   %
   %   HGAUXCTRL methods:
   %   HGAUXCTRL object construction:
   %      @HGAUXCTRL/HGAUXCTRL   - Construct HGAUXCTRL object.
   %      delete                 - Delete HGAUXCTRL object.
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
   %      get              - Get value of HGAUXCTRL object property.
   %      set              - Set value of HGAUXCTRL object property.
   %
   %   Static methods:
   %      ispanel          - true if HG object can be wrapped by HGAUXCTRL
   properties (Access=protected)
      aux_h
      aux_size
      aux_loc      % {1-'left',2-'bottom',3-'right',4-'top}
      aux_halign   % {1-'fill',2-'left',3-'center',4-'right'}
      aux_valign   % {1-'fill',2-'bottom',3-'middle',4-'top'}
   end
   methods
      function obj = hgauxctrl(varargin)
         %HGAUXCTRL/HGAUXCTRL   Construct HGAUXCTRL object.
         %
         %   HGAUXCTRL creates a detached scalar HGAUXCTRL object.
         %
         %   HGAUXCTRL(H) creates a HGAUXCTRL objects for all HG handle
         %   objects in H.
         %
         %   HGAUXCTRL(N) creates an N-by-N matrix of HGAUXCTRL
         %   objects
         %
         %   HGAUXCTRL(M,N) creeates an M-by-N matrix of HGAUXCTRL
         %   objects
         %
         %   HGAUXCTRL(M,N,P,...) or HGAUXCTRL([M N P ....])
         %   creates an M-by-N-by-P-by-... array of HGAUXCTRL objects.
         %
         %   HGAUXCTRL(SIZE(A)) creates HGAUXCTRL objects with the
         %   same size as A.
         %
         %   HGAUXCTRL(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created HGAUXCTRL objects. All
         %   objects are set to the same property values.
         %
         %   HGAUXCTRL(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         obj = obj@hgdisguise(varargin{:});
      end
   end
   methods (Access=protected)
      init(obj) % (overriding)
      
      populate_panel(obj) % (empty, to be overridden) populate obj.hg
      layout_panel(obj)   % (empty, to be overridden) layout obj.hg children
      unpopulate_panel(obj) % (empty, to be overridden) unpopulate obj.hg
   end
end
