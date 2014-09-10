function javainit(obj)
%UIZOOMCTRL/JAVAINIT   Initialize Java components on the panel
%   JAVAINIT(OBJ) must be called explicitly if any container handle (e.g.,
%   figure and uipanels) that contains OBJ is not visible at the time of
%   UIZOOMCTRL OBJ creation.

% format panel

if ~isempty(obj.btns.pointer), return; end % already initialized

% for these buttons to be visible, all its ancestors must be visible
if ~uiutil.isvisible(obj.hg), return; end

sz = obj.panelsize(2)-2; % button size
commonprops = {};

% create buttons
[j,obj.btns.pointer] = javacomponent('javax.swing.JToggleButton',[1 1 sz sz],obj.hg);
if isempty(j) % uizoomctrl is not visible, javainit must run after the ctrl is made visible
   delete(j);
   return
end
if ~isempty(commonprops)
   set(h,commonprops{:});
end
j.setToolTipText('Normal');
j.setIcon(scaledimageicon(sz,'tool_pointer.png'));
obj.jbtns.pointer = j;
set(obj.jbtns.pointer,'ActionPerformedCallback',@(~,~)obj.btnscallback('pointer'));
obj.el_btnstates(1,1) = addlistener(obj.btns.pointer,'Visible','PostSet',@(~,d)obj.monitor_btnsstate('pointer',strcmp(d.NewValue,'on'),true));
set(obj.jbtns.pointer,'PropertyChangeCallback',@(~,evt)propertychangefcn(obj,'pointer',evt));

[j,obj.btns.zoomin] = javacomponent('javax.swing.JToggleButton',[sz 1 sz sz],obj.hg);
if ~isempty(commonprops)
   set(h,commonprops{:});
end
j.setToolTipText('Zoom In');
j.setIcon(scaledimageicon(sz,'tool_zoom_in.png'));
obj.jbtns.zoomin = j;
set(obj.jbtns.zoomin,'ActionPerformedCallback',@(~,~)obj.btnscallback('zoomin'));
obj.el_btnstates(2,1) = addlistener(obj.btns.zoomin,'Visible','PostSet',@(~,d)obj.monitor_btnsstate('zoomin',strcmp(d.NewValue,'on'),true));
set(obj.jbtns.zoomin,'PropertyChangeCallback',@(~,evt)propertychangefcn(obj,'zoomin',evt));

[j,obj.btns.zoomout] = javacomponent('javax.swing.JToggleButton',[2*sz 1 sz sz],obj.hg);
if ~isempty(commonprops)
   set(h,commonprops{:});
end
j.setToolTipText('Zoom Out');
j.setIcon(scaledimageicon(sz,'tool_zoom_out.png'));
obj.jbtns.zoomout = j;
set(obj.jbtns.zoomout,'ActionPerformedCallback',@(~,~)obj.btnscallback('zoomout'));
obj.el_btnstates(3,1) = addlistener(obj.btns.zoomout,'Visible','PostSet',@(~,d)obj.monitor_btnsstate('zoomout',strcmp(d.NewValue,'on'),true));
set(obj.jbtns.zoomout,'PropertyChangeCallback',@(~,evt)propertychangefcn(obj,'zoomout',evt));

[j,obj.btns.pan] = javacomponent('javax.swing.JToggleButton',[3*sz 1 sz sz],obj.hg);
if ~isempty(commonprops)
   set(h,commonprops{:});
end
j.setToolTipText('Pan');
j.setIcon(scaledimageicon(sz,'tool_hand.png'));
obj.jbtns.pan = j;
set(obj.jbtns.pan,'ActionPerformedCallback',@(~,~)obj.btnscallback('pan'));
obj.el_btnstates(4,1) = addlistener(obj.btns.pan,'Visible','PostSet',@(~,d)obj.monitor_btnsstate('pan',strcmp(d.NewValue,'on'),true));
set(obj.jbtns.pan,'PropertyChangeCallback',@(~,evt)propertychangefcn(obj,'pan',evt));

% select the current mode
obj.CurrentMode = obj.CurrentMode;

end

function [im,sz] = scaledimageicon(sz,icon)

import java.awt.MediaTracker
import java.awt.Image

% first try the resources subfolder in the current folder
im = javax.swing.ImageIcon(uiutil.iconpath(icon));

if im.getImageLoadStatus()==MediaTracker.ERRORED
   fprintf('Failed to load the icon image \n%s\n',icon);
end

% get size and scale if necessary
iconsz = max(im.getIconHeight(),im.getIconWidth);
if iconsz==sz
   sz = iconsz;
else % scale
   im = javax.swing.ImageIcon(im.getImage().getScaledInstance(sz,sz,java.awt.Image.SCALE_FAST));
end

end

function propertychangefcn(obj,name,evt)
% instead of PostSet event listening, use PropertyChangeCallback to monitor
% the Enabled state of Java JButton

   if strcmp(char(evt.getPropertyName()),'enabled')
      obj.monitor_btnsstate(name,logical(evt.getNewValue()),'Visible');
   end
end
