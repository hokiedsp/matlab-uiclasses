classdef hgandlabels < hgdisguise
%HGANDLABELS   a uipanel wrapped HG object with 2 labels
%   HGANDLABELS actually is a UIPANELEX-based class 
%
%   HGANDLABELS inherits and extends Enable property from its superclass,
%   HGENABLE. 
%
%   Unlike other uipanels, GraphicsHandle property and set/get interface
%   of HGANDLABELS connects to uicontrol and not the enclosing panel.
%
%   HGANDLABELS properties.
%      HgHeightLimits    - [min max] limits of the main uicontrol's height 
%      HgHgWidthLimits     - [min max] limits of the main uicontrol's width
%      LabelStrings              - displayed string
%      LabelMargins              - space from the origin of the leading label to the nearest edge of the HG
%      LabelLocations            - array of {'left','top'}
%      LabelInterpreters         - array of {'none','tex','latex'}
%      LabelHorizontalAlignments - array of {'left','center','right'}
%      LabelVerticalAlignments   - array of {'bottom','middle','top'}
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
%      Extent          - (Read-only) tightest position rectangle encompassing all Children
%      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
%      GraphicsHandle  - Attached HG object handle
%
%   HGANDLABELS methods:
%   HGANDLABELS object construction:
%      @HGANDLABELS/HGANDLABELS   - Construct HGANDLABELS object.
%      delete                 - Delete HGANDLABELS object.
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
%      get              - Get value of HGANDLABELS object property.
%      set              - Set value of HGANDLABELS object property.
%
%   Static methods:
%      ispanel          - true if HG object can be wrapped by HGANDLABELS
   properties (Dependent,SetAccess=private)
      LabelHandles    % Label uicontrol (default to text Style)
   end
   properties (Dependent)
      HgHeightLimits    % [min max] limits of the main uicontrol's height 
      HgWidthLimits     % [min max] limits of the main uicontrol's width
      
      LabelStrings               % displayed string
      LabelMargins               % space from the origin of the label to the nearest edge of the HG
      LabelLocations             % {'left','top'}
      LabelHorizontalAlignments  % {'left','center','right'}
      LabelVerticalAlignments    % {'bottom','middle','top'}
      LabelInterpreters          % {'none','tex','latex'}
   end
   properties (Access=protected)
      haxes          % for tex/latex text interpreter support

      labels_h        % uicontrol handle
      labels_htext    % text handle for tex/latex text interpreter support
      labels_layout   % layout info: [loc|halign|valign]
      labels_margin   % space from the origin of the leading label to the nearest edge of the HG
      labels_interpreter
   end
   properties (Access=private)
      hlims        % HG height limits [min max
      wlims        % HG width limits [min max]
 
      pos_labels   % label positions w.r.t. zero-size hg origin 
      totallims    % [wmin hmin;wmax hmax]
      hgmargin     % [right top] required margins for HG to fit labels
      mult         % [hmult vmult] multiplier to layout around HG object
   end
   
   methods
      I = addLabel(obj,str,varargin)
      removeLabel(obj,I)
      setLabel(obj,I,varargin)
      pv = getLabel(obj,I,pn)
      
      function obj = hgandlabels(varargin)
         %HGANDLABELS/HGANDLABELS   Construct HGANDLABELS object.
         %
         %   HGANDLABELS creates a detached scalar HGANDLABELS object.
         %
         %   HGANDLABELS(H) creates a HGANDLABELS objects for all HG handle
         %   objects in H.
         %
         %   HGANDLABELS(N) creates an N-by-N matrix of HGANDLABELS
         %   objects
         %
         %   HGANDLABELS(M,N) creeates an M-by-N matrix of HGANDLABELS
         %   objects
         %
         %   HGANDLABELS(M,N,P,...) or HGANDLABELS([M N P ....])
         %   creates an M-by-N-by-P-by-... array of HGANDLABELS objects.
         %
         %   HGANDLABELS(SIZE(A)) creates HGANDLABELS objects with the
         %   same size as A.
         %
         %   HGANDLABELS(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created HGANDLABELS objects. All
         %   objects are set to the same property values.
         %
         %   HGANDLABELS(...,pn,pv) sets the named properties specified in
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

      update_gridlims(obj)
      
      set_labelstring(obj,type,str)
      pos = get_labelextent(obj,type)
      set_labelposition(obj,type,pos)
      adjust_labelposition(obj,type,adjustgrid)
      
      val = get_contentextent(obj,h) % Returns size of panel content
      c = match_bgcolor(obj,p,pname) % match panel & label background color to the parent's
   end
   
   methods
      %LabelHandles    % Prefix uicontrol (default to text Style)
      function val = get.LabelHandles(obj)
         if obj.isattached()
            val = obj.labels_h;
            try
               val = double(val);
            catch
            end
         else
            val = [];
         end
      end
      
      %HgHeightLimits    % [min max] limits of the main uicontrol's height
      function val = get.HgHeightLimits(obj)
         val = obj.hlims;
      end
      function set.HgHeightLimits(obj,val)
         obj.validateproperty('HgHeightLimits',val);
         obj.hlims = val;
         obj.update_gridlims();
      end
      
      %HgWidthLimits     % [min max] limits of the main uicontrol's width
      function val = get.HgWidthLimits(obj)
         val = obj.wlims;
      end
      function set.HgWidthLimits(obj,val)
         obj.validateproperty('HgWidthLimits',val);
         obj.wlims = val;
         obj.update_gridlims();
      end
      
      %LabelMargins:margin_lead
      function val = get.LabelMargins(obj)
         val = obj.getLabel(obj.labels_h,'Margin');
      end
      function set.LabelMargins(obj,val)
         obj.setLabel(obj.labels_h,'Margin',val);
      end
      
      %LabelLocations: loc_lead
      function val = get.LabelLocations(obj)
         val = obj.getLabel(obj.labels_h,'Location');
      end
      function set.LabelLocations(obj,val)
         obj.setLabel(obj.labels_h,'Location',val);
      end
      
      %LabelHorizontalAlignments: halign_lead
      function val = get.LabelHorizontalAlignments(obj)
         val = obj.getLabel(obj.labels_h,'HorizontalAlignment');
      end
      function set.LabelHorizontalAlignments(obj,val)
         obj.setLabel(obj.labels_h,'HorizontalAlignment',val);
      end
      
      %LabelVerticalAlignments: valign_lead
      function val = get.LabelVerticalAlignments(obj)
         val = obj.getLabel(obj.labels_h,'VerticalAlignment');
      end
      function set.LabelVerticalAlignments(obj,val)
         obj.setLabel(obj.labels_h,'VerticalAlignment',val);
      end
      
      %LabelStrings
      function val = get.LabelStrings(obj)
         val = obj.getLabel(obj.labels_h,'String');
      end
      function set.LabelStrings(obj,val)
         obj.setLabel(obj.labels_h,'String',val);
      end
      
      %LabelInterpreters {{'latex','text','none'}}
      function val = get.LabelInterpreters(obj)
         val = obj.getLabel(obj.labels_h,'Interpreter');
      end
      function set.LabelInterpreters(obj,val)
         obj.setLabel(obj.labels_h,'Interpreter',val);
      end
      
   end
end
