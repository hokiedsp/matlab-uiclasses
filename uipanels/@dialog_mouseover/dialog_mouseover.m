classdef dialog_mouseover < dialogex & figctrl_mouseover
%DIALOG_MOUSEOVER   Enables UIAXOBJs on DIALOGEX
%   DIALOG_MOUSEOVER is a HANDLE class derived from DIALOGEX and
%   FIGURE_MOUSEOVER so that the dialog figure can houseUIAXOBJ objects.
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
   
   methods
      function obj = dialog_mouseover(varargin)
         %DIALOG_MOUSEOVER/DIALOG_MOUSEOVER() instantiates DIALOG_MOUSEOVER class
         %
         %   OBJ = DIALOG_MOUSEOVER() creates a new DIALOG_MOUSEOVER object with a new dialog figure
         %   HG object. The HG figure object is created using built-in DIALOG
         %   command.
         %
         %   The dialog figure created will contain a uipanel to populate with
         %   uicontrols for user's dialog box need. Handle to the uipanel object can
         %   be obtained via DIALOG_MOUSEOVER property ControlPanel
         %
         %   The function call may include parameter/value pairs at the end to
         %   specify additional properties of both the DIALOG_MOUSEOVER and its FIGURE HG
         %   object.
         
         varargin = uipanelex.autoattach(mfilename,@dialog,{'figure'},varargin);
         obj = obj@figctrl_mouseover;
         obj = obj@dialogex(varargin{:});
      end
   end
   
   methods (Access=protected)
      init(obj)              % initialize the class object
      populate_panel(obj)    % populate obj.hg
      unpopulate_panel(obj)  % unpopulate obj.hg
   end
   
end
