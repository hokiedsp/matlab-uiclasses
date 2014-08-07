function btncallback(obj,I)
%DIALOGEX/BTNCALLBACK   Callback function for Button Objects
%   BTNCALLBACK(OBJ,I,eventname)

if nargin==1 % default button action
   if obj.default_mode==1, return; % no default button set
   else I = obj.default_mode-1;
   end
end

switch I
   case 1 % ok
      eventname = 'OkButtonPressed';
   case 2 % cancel
      eventname = 'CancelButtonPressed';
   otherwise %case 3
      eventname = 'ApplyButtonPressed';
end

% get AutoDetach configuration for the later use
autodetach = obj.autodetach;

% If the pressed button is set up to close the figure
if obj.btnclose(I)
   obj.BeingClosed = 'on';
end

obj.Enable = 'inactive';
set(obj.hg,'Pointer','watch');

% trigger the event (assuming notify blocks the function call until all
% its listeners complete their callbacks)
notify(obj,eventname);

% if BeingClosed is still 'on', close the figure
% (event can call OBJ.cancelDialogClosure() method to cancel it)
if obj.BeingClosed(2)=='n'
   delete(obj.hg); % direct deletion to avoid triggering CloseRequestFcn
end

% if OBJ is still valid (if AutoDetach='off', OBJ is deleted at this
% point) clear BeingClosed flag.
if autodetach
   obj.BeingClosed = 'off';
   obj.Enable = 'on';
   set(obj.hg,'Pointer','arrow');
end
