function javainit(obj)
%UIZOOMCTRL/JAVAINIT   Initialize Java components on the panel
%   JAVAINIT(OBJ) must be called explicitly if any container handle (e.g.,
%   figure and uipanels) that contains OBJ is not visible at the time of
%   UIZOOMCTRL OBJ creation.

% format panel

if ~isempty(obj.btns), return; end % already initialized

% for these buttons to be visible, all its ancestors must be visible
if ~uiutil.isvisible(obj.hg), return; end

sz = obj.panelsize(2)-2; % button size
commonprops = {};

% create buttons
[j,h] = javacomponent('javax.swing.JToggleButton',[1 1 sz sz],obj.hg);
if isempty(h) % uizoomctrl is not visible, javainit must run after the ctrl is made visible
   delete(j);
   return
end
if ~isempty(commonprops)
   set(h,commonprops{:});
end
j.setToolTipText('Normal');
j.setIcon(scaledimageicon(sz,'tool_pointer.png'));
set(j,'ActionPerformedCallback',@(~,~)obj.btnscallback(1));
obj.jbtns = j;
obj.btns = h;

[j,h] = javacomponent('javax.swing.JToggleButton',[sz 1 sz sz],obj.hg);
if ~isempty(commonprops)
   set(h,commonprops{:});
end
j.setToolTipText('Zoom In');
j.setIcon(scaledimageicon(sz,'tool_zoom_in.png'));
set(j,'ActionPerformedCallback',@(~,~)obj.btnscallback(2));
obj.jbtns(2) = j;
obj.btns(2) = h;

[j,h] = javacomponent('javax.swing.JToggleButton',[2*sz 1 sz sz],obj.hg);
if ~isempty(commonprops)
   set(h,commonprops{:});
end
j.setToolTipText('Zoom Out');
j.setIcon(scaledimageicon(sz,'tool_zoom_out.png'));
set(j,'ActionPerformedCallback',@(~,~)obj.btnscallback(3));
obj.jbtns(3) = j;
obj.btns(3) = h;

[j,h] = javacomponent('javax.swing.JToggleButton',[3*sz 1 sz sz],obj.hg);
if ~isempty(commonprops)
   set(h,commonprops{:});
end
j.setToolTipText('Pan');
j.setIcon(scaledimageicon(sz,'tool_hand.png'));
set(j,'ActionPerformedCallback',@(~,~)obj.btnscallback(4));
obj.jbtns(4) = j;
obj.btns(4) = h;

% select the current mode
if obj.mode>0
   obj.jbtns(obj.mode).setSelected(true);
end

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
