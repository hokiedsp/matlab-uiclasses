classdef dialogex < uipanelautoresize
%DIALOGEX   Extended dialog figure with OK/Cancel/Apply buttons.
%   DIALOGEX is a HANDLE class derived from UIPANELAUTORESIZE to control a
%   dialog figure. Its main feature are the control buttons: OK, Cancel,
%   and Apply. The dialog can have any combination of these buttons, and
%   their visibility, enabledness, and labels can be customized. Also, any
%   of the buttons can be configured to close the figure (OK and Cancel are
%   default to close) via XxxBtnCloseDlg properties.
%
%   DIALOGEX places a uicontainer for its content right above the control
%   buttons, and the handle of the uicontainer can be retrieved via
%   ContentPanel property.
%
%   When user presses any of the control buttons (or an equivalent action
%   is taken), one of the following events is triggered: OkButtonPressed,
%   CancelButtonPressed, and ApplyButtonPressed. The application should set
%   up listeners for these events to retrieve the information from the
%   dialog. Matlab blocks the execution of the button callback function
%   while event listener's callback is running.
%
%   Other features include:
%   - If dialog content is incomplete, calling cancelDialogClosure() method
%     from a button pressed event listener callback cancels the pending
%     dialog closure.
%   - Default button: One of the three buttons can be set as the default
%     button via DefaultButton property, and it defines the action when
%     'Enter' or 'Space' key is pressed on the keyboard.
%   - Pressing 'ESC' key or ctrl-'c' and closing the figure via X button
%     are equivalent to pressing the 'Cancel' button.
%   - Auto-Resize: Figure's ResizeFcn is automatically set up so that
%
%   UIPANELAUTORESIZE inherits and extends Enable property from its superclass,
%   HGENABLE.
%
%   Unlike other uipanels, GraphicsHandle property and set/get interface
%   of UIPANELAUTORESIZE connects to uicontrol and not the enclosing panel.
%
%   UIPANELAUTORESIZE properties.
%      BeingClosed        - (read-only) ['on'|'off'] turns 'on' during ...
%                           XxxButtonPressed events if XxxCloseDlg='on'.
%      ButtonBoxAlignment - ['left'|'center'|{'right'}] horizontal
%                           alignment of the buttons
%      ContentPanel % Handle to uipanel object to add user controls
%      CloseRequestFcnMode % {'auto'}|'custom'
%      WindowKeyPressFcnMode % {'auto'}|'custom' ('auto' closes figure when ctrl-c is pressed)
%      ButtonOrder % [{'okcancelapply'},'okapplycancel','applyokcancel']
%      
%      DefaultBtn    % {'ok'}|'cancel'|'apply'|'none'
%      
%      OkBtn         % Show/Enable OK button: {'on'}|'inactive'|'disable'|'off'
%      OkBtnLabel    % OK button label: {'OK'}
%      OkBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering OkButtonPressed event
%      
%      CancelBtn      % Show/Enable Cancel button: {'on'}|'inactive'|'disable'|'off'
%      CancelBtnLabel % Cancel button label: {'Cancel'}
%      CancelBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering CancelButtonPressed event
%      
%      ApplyBtn % Show/Enable Cancel button: 'on'|'inactive'|'disable'|{'off'}
%      ApplyBtnLabel  % Apply Button label: {'Apply'}
%      ApplyBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering OkButtonPressed event
%
%      AutoDetach       - Simultaneous deletion of HG object
%      AutoLayout       - [{'on'}|'off'] to re-layout panel automatically
%                         if panel content has changed.
%      Enable          - Enable or disable the panel and its contents
%      Extent          - (Read-only) tightest position rectangel encompassing all Children
%      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
%      GraphicsHandle  - Attached HG object handle
%      ResizeFcnMode   - {'manual','auto'}
%
%   UIPANELAUTORESIZE methods:
%   UIPANELAUTORESIZE object construction:
%      @UIPANELAUTORESIZE/UIPANELAUTORESIZE   - Construct UIPANELAUTORESIZE object.
%      delete                 - Delete UIPANELAUTORESIZE object.
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
%      get              - Get value of UIPANELAUTORESIZE object property.
%      set              - Set value of UIPANELAUTORESIZE object property.
%
%   Static methods:
%      ispanel          - true if HG object can be wrapped by UIPANELAUTORESIZE
   
   events
      OkButtonPressed
      CancelButtonPressed
      ApplyButtonPressed
   end
   
   properties (Dependent=true)
      CloseRequestFcnMode % {'auto'}|'custom'
      WindowKeyPressFcnMode % {'auto'}|'custom' ('auto' closes figure when ctrl-c is pressed)
      ButtonOrder % [{'okcancelapply'},'okapplycancel','applyokcancel']
      
      DefaultBtn    % {'ok'}|'cancel'|'apply'|'none'
      
      OkBtn         % Show/Enable OK button: {'on'}|'inactive'|'disable'|'off'
      OkBtnLabel    % OK button label: {'OK'}
      OkBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering OkButtonPressed event
      
      CancelBtn      % Show/Enable Cancel button: {'on'}|'inactive'|'disable'|'off'
      CancelBtnLabel % Cancel button label: {'Cancel'}
      CancelBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering CancelButtonPressed event
      
      ApplyBtn % Show/Enable Cancel button: 'on'|'inactive'|'disable'|{'off'}
      ApplyBtnLabel  % Apply Button label: {'Apply'}
      ApplyBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering OkButtonPressed event
   end
   properties
      ButtonBoxAlignment % ['left'|'center'|{'right'}]
   end
   properties (SetAccess=private)
      ContentPanel % Handle to uipanel object to add user controls
      BeingClosed  % 'on'|{'off'} - turns 'on' during XxxButtonPressed events with XxxCloseDlg='on'
   end
   properties (Access=private)
      btnvis
      btnena
      btnlabels
      btnclose
      btnorder % 1'okcancelapply'},2'okapplycancel',3'applyokcancel']

      default_mode    % 1'ok'|2'cancel'|3'apply'|4'none'
      
      pnButtonBox % button box at the bottom
      hBtns % uicontrols of the buttons
      
      crfmode  % CloseRequestFcn
      wkpfmode % WindowKeyPressFcnMode
      
      propsync % automatic property synchronizer
   end
   
   methods
      cancelDialogClosure(obj) % call this method during OkButtonPressed or CancelButtonPressed event callback to abort figure closure
      pressDefaultButton(obj) % call this method to trigger the action associated with the default button
      function obj = dialogex(varargin)
         %DIALOGEX/DIALOGEX() instantiates DIALOGEX class
         %
         %   OBJ = DIALOGEX() creates a new DIALOGEX object with a new dialog figure
         %   HG object. The HG figure object is created using built-in DIALOG
         %   command.
         %
         %   The dialog figure created will contain a uipanel to populate with
         %   uicontrols for user's dialog box need. Handle to the uipanel object can
         %   be obtained via DIALOGEX property ControlPanel
         %
         %   The function call may include parameter/value pairs at the end to
         %   specify additional properties of both the DIALOGEX and its FIGURE HG
         %   object.
         
         varargin = uipanelex.autoattach(mfilename,@dialog,{'figure'},varargin);
         obj = obj@uipanelautoresize(varargin{:});
      end
   end
   
   methods (Access=protected)
      init(obj)              % initialize the class object
      populate_panel(obj)    % populate obj.hg
      tf = layout_panel(obj)
      unpopulate_panel(obj)  % unpopulate obj.hg
      val = get_contentextent(obj,h)
      
      format_buttonbox(obj)
      setdefaultbutton(obj)
      
      val = get_btn(obj,I) % get button enable/visible mode
      set_btn(obj,I,val)   % set button enable/visible mode
      val = get_btnlabel(obj,I)
      set_btnlabel(obj,I,val)
      val = get_btnclose(obj,I)
      set_btnclose(obj,I,val)
      
      btncallback(obj,I)
      windowskeypressfcn(obj,h,event) % if ctrl-c pressed, force close
   end
   
   methods % set/get methods for the properties
      function val = get.DefaultBtn(obj)
         val = obj.propopts.DefaultBtn.StringOptions{obj.default_mode};
      end
      function set.DefaultBtn(obj,val)
         prev = obj.default_mode;
         [~,obj.default_mode] = obj.validateproperty('DefaultBtn',val);
         if obj.isattached() && obj.default_mode==4 && prev~=obj.default_mode
            warning('The new DefaultBtn value ''none'' is not reflected in the current dialog appearance.');
         end
         obj.setdefaultbutton();
      end
      
      % CloseRequestFcnMode: {'auto'}|'manual'
      function val = get.CloseRequestFcnMode(obj)
         if obj.crfmode.hasTarget()
            val = obj.propopts.CloseRequestFcnMode.StringOptions{obj.crfmode.hasValueChanged+1};
         else
            val = '';
         end
      end
      function set.CloseRequestFcnMode(obj,val)
         if obj.crfmode.hasTarget()
            [~,val] = obj.validateproperty('CloseRequestFcnMode',val);
            if val==1 % 'auto'
               obj.wkpcrfmodefmode.setPropertyToDefault();
            end
         else
            if ~isempty(val)
               error('CloseRequestFcnMode cannot be set if OBJ is not attached to a figure.');
            end
         end
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % WindowKeyPressFcnMode: {'auto'}|'manual'
      function val = get.WindowKeyPressFcnMode(obj)
         if obj.wkpfmode.hasTarget()
            val = obj.propopts.WindowKeyPressFcnMode.StringOptions{obj.wkpfmode.hasValueChanged+1};
         else
            val = '';
         end
      end
      function set.WindowKeyPressFcnMode(obj,val)
         if obj.wkpfmode.hasTarget()
            [~,val] = obj.validateproperty('WindowKeyPressFcnMode',val);
            if val==1 % 'auto'
               obj.wkpfmode.setPropertyToDefault();
            end
         else
            if ~isempty(val)
               error('WindowKeyPressFcnMode cannot be set if OBJ is not attached to a figure.');
            end
         end
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %ButtonBoxAlignment % ['left'|'center'|{'right'}]
      function set.ButtonBoxAlignment(obj,val)
         obj.ButtonBoxAlignment = obj.validateproperty('ButtonBoxAlignment',val);
         obj.layout();
      end
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %ButtonOrder
      function val = get.ButtonOrder(obj)
         val = obj.propopts.ButtonOrder.StringOptions{obj.btnorder};
      end
      function set.ButtonOrder(obj,val)
         [~,obj.btnorder] = obj.validateproperty('ButtonOrder',val);
         obj.format_buttonbox();
         obj.layout_panel();
      end
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %OkBtn         % Show/Enable OK button: {'on'}|'inactive'|'disable'|'off'
      function val = get.OkBtn(obj)
         val = obj.get_btn(1);
      end
      function set.OkBtn(obj,val)
         val = obj.validateproperty('OkBtn',val);
         obj.set_btn(1,val);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % OkBtnLabel    % OK button label: {'OK'}
      function val = get.OkBtnLabel(obj)
         val = obj.get_btnlabel(1);
      end
      function set.OkBtnLabel(obj,val)
         val = obj.validateproperty('OkBtnLabel',val);
         obj.set_btnlabel(1,val);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %OkBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering OkButtonPressed event
      function val = get.OkBtnCloseDlg(obj)
         val = obj.propopts.OkBtnCloseDlg.StringOptions{obj.get_btnclose(1)};
      end
      function set.OkBtnCloseDlg(obj,val)
         [~,val] = obj.validateproperty('OkBtnCloseDlg',val);
         obj.set_btnclose(1,val);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %CancelBtn      % Show/Enable Cancel button: {'on'}|'inactive'|'disable'|'off'
      function val = get.CancelBtn(obj)
         val = obj.get_btn(2);
      end
      function set.CancelBtn(obj,val)
         val = obj.validateproperty('CancelBtn',val);
         obj.set_btn(2,val);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %CancelBtnLabel % Cancel button label: {'Cancel'}
      function val = get.CancelBtnLabel(obj)
         val = obj.get_btnlabel(2);
      end
      function set.CancelBtnLabel(obj,val)
         val = obj.validateproperty('CancelBtnLabel',val);
         obj.set_btnlabel(2,val);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %CancelBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering CancelButtonPressed event
      function val = get.CancelBtnCloseDlg(obj)
         val = obj.propopts.CancelBtnCloseDlg.StringOptions{obj.get_btnclose(2)};
      end
      function set.CancelBtnCloseDlg(obj,val)
         [~,val] = obj.validateproperty('CancelBtnCloseDlg',val);
         obj.set_btnclose(2,val);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %ApplyBtn % Show/Enable Cancel button: 'on'|'inactive'|'disable'|{'off'}
      function val = get.ApplyBtn(obj)
         val = obj.get_btn(3);
      end
      function set.ApplyBtn(obj,val)
         val = obj.validateproperty('ApplyBtn',val);
         obj.set_btn(3,val);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %ApplyBtnLabel  % Apply Button label: {'Apply'}
      function val = get.ApplyBtnLabel(obj)
         val = obj.get_btnlabel(3);
      end
      function set.ApplyBtnLabel(obj,val)
         val = obj.validateproperty('ApplyBtnLabel',val);
         obj.set_btnlabel(3,val);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %ApplyBtnCloseDlg % [{'on'}|'off'] Close dialog after triggering OkButtonPressed event
      function val = get.ApplyBtnCloseDlg(obj)
         val = obj.propopts.ApplyBtnCloseDlg.StringOptions{obj.get_btnclose(3)};
      end
      function set.ApplyBtnCloseDlg(obj,val)
         [~,val] = obj.validateproperty('ApplyBtnCloseDlg',val);
         obj.set_btnclose(3,val);
      end
   end
end
