function register_figure(obj,fig)
%FIGCTRL_MOUSEOVER/REGISTER_FIGURE   (protected) Populate panel with its content
%   REGISTER_FIGURE(OBJ,FIG) configures the figure object FIG (which must
%   be scalar) so that it's WindowButtonMotionFcn is controlled by OBJ
%   (which alsmo must be scalar). This function assumes that OBJ does not
%   have any figure already registered.

% Set up WindowButtonMotionFcn & its monitoring
obj.wbmf_mode.setTarget(fig,'WindowButtonMotionFcn',@(fig,~)obj.windowbuttonmotionfcn(fig));

% set default pointer style (when pointer is not hovering over an uiaxobj)
obj.setCurrentPointerAsDefault();
