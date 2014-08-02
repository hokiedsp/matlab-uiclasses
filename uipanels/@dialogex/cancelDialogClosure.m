function cancelDialogClosure(obj)
%DIALOGEX/CANCELDIALOGCLOSURE   Cancel pending dialog closure
%   CANCELDIALOGCLOSURE(OBJ) is to be called during XxxButtonPressed event
%   callback. Calling this method cancels pending dialog closure, which is
%   configured by XxxBtnCloseDlg property.

obj.BeingClosed = 'off';
