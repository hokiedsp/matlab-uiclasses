function setdefaultbutton(obj)
%SETDEFAULTBUTTON Set default button for the dialog figure.
%   SETDEFAULTBUTTON(OBJ) sets the default button (the button and callback
%   used when the user hits "enter" or "return" when in a dialog box)  to
%   grow.

if obj.isattached() && obj.default_mode>1
   try
      % Get a UDD handle for the figure.
      % Call the setDefaultButton method on the figure handle
      obj.hg.setDefaultButton(obj.hBtns(obj.default_mode-1));
   catch
   end
end
