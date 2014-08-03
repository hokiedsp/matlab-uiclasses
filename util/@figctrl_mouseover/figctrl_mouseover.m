classdef figctrl_mouseover < hgsetgetex
%FIGCTRL_MOUSEOVER   Figure object with mouse over action
%   FIGCTRL_MOUSEOVER wraps HG figure object to specify callbacks when a
%   mouse pointer is moved over specified child objects of the figure.
%
%   FIGCTRL_MOUSEOVER overrides WindowButtonMotionFcn property of the figure
%   to monitor the mouse pointer and to issue the callbacks. If
%   WindowButtonMotionFcn needs to be changed from the default, setting
%   OBJ.WindowButtonMotionFcnMode to 'auto' restores the default behavior.
%
%   FIGCTRL_MOUSEOVER inherits and extends Enable property from its
%   superclass, FIGCTRL_MOUSEOVER. It adds a mechanism to control Enable
%   properties of all child objects. When FIGCTRL_MOUSEOVER's Enable is
%   'on', its child objects own Enable property value is reflected in their
%   appearances. If FIGCTRL_MOUSEOVER's Enable is either 'off' or
%   'inactive', the child object appearance follows the panel's Enable
%   value; however, its actual Enable value remains that of itself.
%
%   FIGCTRL_MOUSEOVER properties.
%      WindowButtonMotionFcnMode - [{'auto'}|'manual'] FIGCTRL_MOUSEOVER or
%                                  user controlled WindowButtonMotionFcn
%
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
%   FIGCTRL_MOUSEOVER methods:
%   FIGCTRL_MOUSEOVER object construction:
%      @FIGCTRL_MOUSEOVER/FIGCTRL_MOUSEOVER - Construct FIGCTRL_MOUSEOVER object.
%      delete                 - Delete FIGCTRL_MOUSEOVER object.
%
%   Assigning mouse-over behavior
%    setCurrentPointerAsDefault - Set current mouse pointer as default
%    addMouseOverCallback       - Add mouse motion callback for HG object.
%    removeMouseOverCallback    - Remove mouse motion callback of HG object.
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
%      get              - Get value of FIGCTRL_MOUSEOVER object property.
%      set              - Set value of FIGCTRL_MOUSEOVER object property.
%
%   Static methods:
%      ispanel          - true if HG object can be wrapped by FIGCTRL_MOUSEOVER
%
%   See also SETFIGCTRL_MOUSEOVER, UIAXOBJ, UILINE, UIPATCH, UITEXT, UIRECTANGLE, UIIMAGE.

% Revision - (Nov. 14, 2011)
% Written by: Takeshi Ikuma (tikuma@hotmail.com)
% Created: Nov. 14, 2011
% Revision History:
%    - (Nov. 14, 2011) - Initial release

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % static keyboard state tracker
   properties (Dependent)
      WindowButtonMotionFcnMode
   end
   properties (Access=private)
      h        % vector of HG handles monitored for mouse hover action
      cbfcns   % vector of function_handles for mouse hover action callbacks
      el       % vector of event listener callbacks to look for h's deletion
      
      hit      % last hit HG handle: index to obj.h & obj.cbfcns
      ptrstyle % pointer style when not over any HG objects in obj.h
               % trio of {'Pointer','PointerShapeCData','PointerShapeHotSpot'}
      killfcn  % ready-made function pointer to remove the listener
      
      wbmf_mode
   end
   methods

      % Functions to add/remove uiaxobj mousemovedaction callbacks
      addMouseOverCallback(obj,h,cbfcn); % add new uiaxobj callback
      removeMouseOverCallback(obj,h);    % remove existing uiaxobj callback
      setCurrentPointerAsDefault(obj);   % Set default mouse pointer to current

   end
   methods (Access=protected)
      init(obj)  % hgwrapper's abstract method
      register_figure(obj,fig)
      unregister_figure(obj)
   end
   
   methods (Access=private)
      kill_monitor(obj,h)
      
      % figure window callbacks
      windowbuttonmotionfcn(obj,fig) % figure mouse moved event callback
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % keyboard state tracker
   methods
      % WindowButtonMotionFcnMode   ['auto'|'manual']
      function val = get.WindowButtonMotionFcnMode(obj)
         if obj.wbmf_mode.hasTarget()
            tf = obj.wbmf_mode.hasValueChanged();
            val = obj.propopts.WindowButtonMotionFcnMode.StringOptions{tf+1};
         else
            val = '';
         end
      end
      function set.WindowButtonMotionFcnMode(obj,val)
         [~,val] = obj.validateproperty('WindowButtonMotionFcnMode',val);
         if obj.wbmf_mode.hasTarget()
            [~,val] = obj.validateproperty('WindowButtonMotionFcnMode',val);
            if val==1 % 'auto'
               obj.wbmf_mode.setPropertyToDefault();
            end
         elseif ~isempty(val)
            error('WindowButtonMotionFcnMode cannot be set if OBJ is not attached to a figure.');
         end
      end
   end
end
