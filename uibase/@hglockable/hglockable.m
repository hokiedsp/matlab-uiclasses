classdef hglockable < hgauxctrl 
   %HGLOCKABLE   a uicontainer wrapped HG object with a checkbox
   %   HGLOCKABLE places a checkbox uicontrol next to a uicontrol. A checkbox
   %   shows an icon of a lock either in a locked or unlocked position. By
   %   clicking on the lock togglebutton toggles between locked or unlocked
   %   state, and notifies either HgIsLocked or HgIsUnlocked events. Note that
   %   these events are only triggered by user interaction. Also, LockedAction
   %   property can be set to 'disable' or 'inactive' to set the Enable
   %   property of the main HG object (if available) when it is in a locked
   %   state.
   %
   %   GraphicsHandle property of HGLOCKABLE returns the main HG object
   %   handle, and set/get methods of HGLOCKABLE object is linked with the
   %   properties of the main HG object.
   %
   %   HGLOCKABLE events
   %      HgIsLocked
   %      HgIsUnlocked
   %
   %   HGLOCKABLE properties.
   %      Locked          - {'on','off'}
   %      LockedAction    - {'none','disable','inactive'}
   %      LockHandle      - HG handle of the lock uicontrol object
   %
   %      LockLocation    - {'left','bottom','right','top}
   %      LockHorizontalAlignment - {'left','center','right','fill'}
   %      LockVerticalAlignment   - {'bottom','middle','top','fill'}
   %
   %      LockEnable      - {'on','off','inactive'}
   %      LockVisible     - {'on','off'}
   %
   %      LockedIcon
   %      LockedTooltipString
   %      UnlockedIcon
   %      UnlockedTooltipString
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
   %   HGLOCKABLE methods:
   %   HGLOCKABLE object construction:
   %      @HGLOCKABLE/HGLOCKABLE   - Construct HGLOCKABLE object.
   %      delete                 - Delete HGLOCKABLE object.
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
   %      get              - Get value of HGLOCKABLE object property.
   %      set              - Set value of HGLOCKABLE object property.
   %
   %   Static methods:
   %      ispanel          - true if HG object can be wrapped by HGLOCKABLE
   properties (Dependent,SetAccess=private)
      LockHandle      % Lock uicontrol
   end
   properties (Dependent)
      Locked          % {'on','off'}
      LockedAction    % {'none','disable','inactive'}
      
      LockLocation    % {'left','bottom','right','top}
      LockHorizontalAlignment % {'left','center','right','fill'}
      LockVerticalAlignment   % {'bottom','middle','top','fill'}
      
      LockEnable      % {'on','off','inactive'}
      LockVisible     % {'on','off'}
      
      LockedIcon
      UnlockedIcon
      LockedTooltipString
      UnlockedTooltipString
   end
   properties (Access=protected)
      icons    % lock icon images: {1}-unlocked; {2}-locked
      ttstrs   % lock icon tooltip strings: {1}-unlocked, {2}-locked
      ena_mode % '','off','inactive'
   end
   events
      HgIsLocked
      HgIsUnlocked
   end
   methods (Sealed)
      lock(obj)
      unlock(obj)
      tf = islocked(obj)
   end
   methods
      varargout = setLockCtrl(obj,varargin)
      varargout = getLockCtrl(obj,varargin)
      
      function obj = hglockable(varargin)
         %HGLOCKABLE/HGLOCKABLE   Construct HGLOCKABLE object.
         %
         %   HGLOCKABLE creates a detached scalar HGLOCKABLE object.
         %
         %   HGLOCKABLE(H) creates a HGLOCKABLE objects for all HG handle
         %   objects in H.
         %
         %   HGLOCKABLE(N) creates an N-by-N matrix of HGLOCKABLE
         %   objects
         %
         %   HGLOCKABLE(M,N) creeates an M-by-N matrix of HGLOCKABLE
         %   objects
         %
         %   HGLOCKABLE(M,N,P,...) or HGLOCKABLE([M N P ....])
         %   creates an M-by-N-by-P-by-... array of HGLOCKABLE objects.
         %
         %   HGLOCKABLE(SIZE(A)) creates HGLOCKABLE objects with the
         %   same size as A.
         %
         %   HGLOCKABLE(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created HGLOCKABLE objects. All
         %   objects are set to the same property values.
         %
         %   HGLOCKABLE(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         obj = obj@hgauxctrl(varargin{:});
      end
   end
   methods (Access=protected)
      init(obj) % (overriding)
      
      populate_panel(obj) % populate hpanel
      
      lock_clicked(obj) % callback to user click action on the lock icon
      lock_se(obj)      % scalar-element lock
      unlock_se(obj)    % valid scalar-element unlock
      
      set_icon(obj,I,val) % I=1:unlock, 2:lock
      c = match_bgcolor(obj,p,pname)
   end
   
   methods
      %LockHandle (uicontrol:style=togglebutton)
      function val = get.LockHandle(obj)
         if obj.isattached()
            val = obj.aux_h;
            try
               val = double(val);
            catch
            end
         else
            val = [];
         end
      end
      
      %Locked: 'on','off'
      function val = get.Locked(obj)
         if obj.isattached()
            val = obj.propopts.Locked.StringOptions(obj.islocked()+1);
         else
            val = '';
         end
      end
      function set.Locked(obj,val)
         if obj.isattached()
            [~,val] = obj.validateproperty('Locked',val);
            if val==1
               obj.unlock();
            else
               obj.lock();
            end
         elseif ~isemtpy(val)
            error('Locked cannot be be set if detached.');
         end
      end
      
      %LockedAction - 'none','disable','inactive'
      function val = get.LockedAction(obj)
         if isempty(obj.ena_mode)
            val = obj.propopts.LockedAction.StringOptions{1};
         elseif strcmp(obj.ena_mode,'off')
            val = obj.propopts.LockedAction.StringOptions{2};
         else
            val = obj.ena_mode;
         end
      end
      function set.LockedAction(obj,val)
         [val,I] = obj.validateproperty('LockedAction',val);
         if I==1 % none
            obj.ena_mode = '';
         elseif I==2
            obj.ena_mode = 'off';
         else
            obj.ena_mode = val;
         end
         if obj.isattached() && obj.islocked() % if currently locked
            obj.lock(); % lock again to reflect the change
         end
      end
      
      %LockLocation = 'left','right','top','bottom'
      function val = get.LockLocation(obj)
         val = obj.propopts.LockLocation.StringOptions{obj.aux_loc};
      end
      function set.LockLocation(obj,val)
         [~,obj.aux_loc] = obj.validateproperty('LockLocation',val);
         if obj.isattached()
            obj.layout_panel();
         end
      end
      
      %LockHorizontalAlignment = 'fill','left','center','right'
      function val = get.LockHorizontalAlignment(obj)
         val = obj.propopts.LockHorizontalAlignment.StringOptions{obj.aux_halign};
      end
      function set.LockHorizontalAlignment(obj,val)
         [~,obj.aux_halign] = obj.validateproperty('LockHorizontalAlignment',val);
         if obj.isattached() && obj.aux_loc>=3
            obj.layout_panel();
         end
      end
      
      %LockVerticalAlignment = 'fill','bottom','middle','top'
      function val = get.LockVerticalAlignment(obj)
         val = obj.propopts.LockVerticalAlignment.StringOptions{obj.aux_valign};
      end
      function set.LockVerticalAlignment(obj,val)
         [~,obj.aux_valign] = obj.validateproperty('LockVerticalAlignment',val);
         if obj.isattached() && obj.aux_loc<=2
            obj.layout_panel();
         end
      end
      
      %LockVisible = 'off','on'
      function val = get.LockVisible(obj)
         if obj.isattached()
            val = get(obj.aux_h,'Visible');
         else
            val = '';
         end
      end
      function set.LockVisible(obj,val)
         if obj.isattached()
            val = obj.validateproperty('LockVisible',val);
            set(obj.aux_h,'Visible',val);
         elseif ~isemtpy(val)
            error('LockVisible cannot be be set if detached.');
         end
      end
      
      %LockEnable = 'off','on'
      function val = get.LockEnable(obj)
         if obj.isattached()
            val = get(obj.aux_h,'Enable');
         else
            val = '';
         end
      end
      function set.LockEnable(obj,val)
         if obj.isattached()
            val = obj.validateproperty('LockEnable',val);
            set(obj.aux_h,'Enable',val);
         elseif ~isemtpy(val)
            error('LockEnable cannot be be set if detached.');
         end
      end
      
      % LockedIcon
      function val = get.LockedIcon(obj)
         val = obj.icons{2};
      end
      function set.LockedIcon(obj,val)
         [val,I] = obj.validateproperty('LockedIcon',val);
         if isempty(I) % RGB matrix given
            obj.set_icon(2,val);
         else % 'auto'
            obj.set_icon(2,[]);
         end
      end
      
      % UnlockedIcon
      function val = get.UnlockedIcon(obj)
         val = obj.icons{1};
      end
      function set.UnlockedIcon(obj,val)
         [val,I] = obj.validateproperty('UnlockedIcon',val);
         if isempty(I) % RGB matrix given
            obj.set_icon(1,val);
         else % 'auto'
            obj.set_icon(1,[]);
         end
      end
      
      % LockedTooltipString
      function val = get.LockedTooltipString(obj)
         val = obj.ttstrs{2};
      end
      function set.LockedTooltipString(obj,val)
         obj.validateproperty('LockedTooltipString',val);
         obj.ttstrs{2} = val;
         if obj.isattached() && obj.islocked()
            set(obj.aux_h,'TooltipString',val);
         end
      end
      
      % UnlockedTooltipString
      function val = get.UnlockedTooltipString(obj)
         val = obj.ttstrs{1};
      end
      function set.UnlockedTooltipString(obj,val)
         obj.validateproperty('UnlockedTooltipString',val);
         obj.ttstrs{1} = val;
         if obj.isattached() && ~obj.islocked()
            set(obj.aux_h,'TooltipString',val);
         end
      end
      
   end
end
