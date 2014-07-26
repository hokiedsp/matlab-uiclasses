classdef uidialog < handle
%UIDIALOG   Class to control a dialog figure with buttons

   properties (Dependent=true)
      AutoClose         % {'on'}|'off' - if 'on', figure closes when 'OK' or Cancel' is pressed
      CloseRequestFcnMode  % {'uidialog'}|'custom'
      ResizeFcnMode        % {'uidialog'}|'custom'

      OkBtnEnable    % {'on'}|'off'
      OkBtnVisible   % Show OK button: {'on'}|'off'
      OkBtnLabel     % OK button label: {'OK'}
      OkBtnMode      % {'default'}|'custom'
      
      CancelBtnEnable    % {'on'}|'off'
      CancelBtnVisible  % Show Cancel button: {'on'} | 'off'
      CancelBtnLabel    % Cancel button label: {'Cancel'}
      CancelBtnMode     % {'default'}|'custom'
      
      ApplyBtnEnable    % {'on'}|'off'
      ApplyBtnVisible   % Show Apply button: 'on' | {'off'}
      ApplyBtnLabel     % Apply Button label: {'Apply'}
      ApplyBtnMode      % {'default'}|'custom'
      
   end
   properties (Dependent=true,SetAccess=private)
      Figure            % Handle to figure object
      ControlPanel      % Handle to uipanel object to add user controls to
      
      Closed            % 'on'|{'off'} - turns 'on' when dialog is closed
      Canceled          % 'on'|{'off'} - turns 'on' when dialog is canceled
                        %    Cancelation conditions:
                        %    - press cancel button
                        %    - closing dialog
   end
   
   events
      OkPressed
      CancelPressed
      ApplyPressed
   end
   
   properties (Access=private)
      btnvis    = [true true false]
      btnlabels = {'OK','Cancel','Apply'};

      
      fig % FigMon object for the figure
      pnCtrlPanel
      pnButtonBox
      hOK
      hCancel
      hApply
      fm
      
      hg_listener   % HG object listeners
   end      
   
   methods
      
      function obj = uidialog(varargin)
%UIDIALOG/UIDIALOG() instantiates UIDIALOG class
%
%   OBJ = UIDIALOG() creates a new UIDIALOG object with a new dialog figure
%   HG object. The HG figure object is created using built-in DIALOG
%   command.
%
%   The dialog figure created will contain a uipanel to populate with
%   uicontrols for user's dialog box need. Handle to the uipanel object can
%   be obtained via UIDIALOG property ControlPanel
%
%   The function call may include parameter/value pairs at the end to
%   specify additional properties of both the UIDIALOG and its FIGURE HG
%   object. 

         Nargs = numel(varargin);
         if mod(Nargs,2)~=0
            error('Invalid parameter/value pair arguments.');
         end
         Nprops = Nargs/2;
         varargin = reshape(varargin,2,Nprops);
         varargin(1,:) = lower(varargin(1,:));
            
         % separate figure and uidialog properties
         pnames = properties(obj);
         [~,I,J] = intersect(lower(varargin(1,:)),lower(pnames),'stable');
         objprops = [pnames(J).';varargin(2,I)];
         varargin(:,I) = [];

         % create dialog
         obj.buildgui(varargin);
         obj.fm = figmon(obj.fig);
         
         
         % set event listeners
         obj.hg_listener = addlistener(handle(h),...
            'ObjectBeingDestroyed',@(~,~)obj.deletefcn());
         
         % Set properties
         if numel(objprops)>0
            set(obj,objprops{:});
         end

      end
   end
   
end
