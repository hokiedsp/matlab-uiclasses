classdef uifilecontrol < hgauxctrl
   %UIFILECONTROL   Specialized HGANDLABELS for files
   %   UIFILECONTROL is an edit uicontrol with a leading label with a trailing
   %   pushbutton to open uigetfile/uisetfile dialog.
   %
   %   UIFILECONTROL properties.
   %      FileName        - (SetObservable) current file name
   %      FileFolder      - (SetObservable) current folder path
   %      FilePath        - full path to the current file
   %
   %      FileIODirection - {'set','put'} specify uisetfile/uiputfile
   %      FileFilterSpec  - file dialog filter specification
   %      FileHistory     - {'on' 'off'} enables popupmenu list of past
   %      FileHistoryList - previously accessed files
   %      FileHistoryDepth - maximum # of items in the list
   %      FileDialogTitle - file dialog title
   %
   %      Position        - position rectangle of hpanel
   %      Units           - units of hpanel
   %
   %      AutoDetach      - Simultaneous deletion of HG object
   %      AutoLayout      - [{'on'}|'off'] to re-layout panel automatically
   %                         if panel content has changed.
   %      Enable          - Enable or disable the panel and its contents
   %      Extent          - (Read-only) tightest position rectangel encompassing all Children
   %      HGDetachable    - (Read-only) Indicate whether attach/detach can be called
   %      GraphicsHandle  - Attached HG object handle
   %
   %   UIFILECONTROL methods:
   %   UIFILECONTROL object construction:
   %      @UIFILECONTROL/UIFILECONTROL   - Construct UIFILECONTROL object.
   %      delete                 - Delete UIFILECONTROL object.
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
   %      get              - Get value of UIFILECONTROL object property.
   %      set              - Set value of UIFILECONTROL object property.
   %
   %   Static methods:
   %      ispanel          - true if HG object can be wrapped by UIFILECONTROL
   properties (SetObservable,AbortSet)
      FileName = ''   % file name
      FolderPath = '' % folder path
   end
   properties (Dependent)
      FilePath        % full file path
      FileIODirection % {'get','put'} specify uisetfile/uiputfile
      FileDialogTitle % file dialog title
      FileFilterSpec  % file dialog filter specification
      FileHistory     % {'on' 'off'} enables popupmenu list of past
      FileHistoryList % previously accessed files
      FileHistoryDepth % maximum # of history items
      FileDisplayOption % {'nameonly' 'fullpath'}
   end
   properties (Access=protected)
   end
   properties (Access=private)
      hbtn        % handle to the file-open button
      nameonly    % true to show only name
      getfile     % true to force file to exist
      dialogtitle % FileDialogTitle
      filtspec    % FileFilterSpec
      histon      % true to turn on history (popupmenu)
      histlist    % cellstr of previously accessed files
      histmax     % max #
      format      % true to update the display when FileNme or FolderPath properties are modified
   end
   
   events
      FilePathChanged
   end
   
   methods
      
      function obj = uifilecontrol(varargin)
         %UIFILECONTROL/UIFILECONTROL   Construct UIFILECONTROL object.
         %
         %   UIFILECONTROL creates a detached scalar UIFILECONTROL object.
         %
         %   UIFILECONTROL(H) creates a UIFILECONTROL objects for all HG handle
         %   objects in H. H must be a uicontrol type.
         %
         %   UIFILECONTROL(N) creates an N-by-N matrix of UIFILECONTROL
         %   objects
         %
         %   UIFILECONTROL(M,N) creeates an M-by-N matrix of UIFILECONTROL
         %   objects
         %
         %   UIFILECONTROL(M,N,P,...) or UIFILECONTROL([M N P ....])
         %   creates an M-by-N-by-P-by-... array of UIFILECONTROL objects.
         %
         %   UIFILECONTROL(SIZE(A)) creates UIFILECONTROL objects with the
         %   same size as A.
         %
         %   UIFILECONTROL(...,'Prop1Name',Prop1Value,'Prop2Name',Prop2Value,...)
         %   sets the properties of the created UIFILECONTROL objects. All
         %   objects are set to the same property values.
         %
         %   UIFILECONTROL(...,pn,pv) sets the named properties specified in
         %   the cell array of strings pn to the corresponding values in the cell
         %   array pv for all objects created .  The cell array pn must be 1-by-N,
         %   but the cell array pv can be M-by-N where M is equal to numel(OBJ) so
         %   that each object will be updated with a different set of values for the
         %   list of property names contained in pn.
         
         varargin = hgenable.autoattach(mfilename,@uicontrol,{'uicontrol'},varargin);
         obj = obj@hgauxctrl(varargin{:});
      end
   end
   methods (Access=protected)
      init(obj) % (overriding)
      validatefile(obj,val,type) % check for file path related properties
      
      populate_panel(obj) % (overriding) changes trailing label to pushbutton
      layout_pane(obj)
      
      changed = update_hist(obj) % update file history (both data & display)
      format_hg(obj)             % format obj.hg to show the file data
      
      function types = supportedtypes(~) % supported HG object types
         % override this function to limit object types
         types = {'uicontrol'};
      end
   end
   methods
      % FileName        % file name
      function set.FileName(obj,val)
         obj.validateproperty('FileName',val);
         obj.FileName = val;
         obj.format_hg();
      end
      
      % FileFolder      % folder path
      function set.FolderPath(obj,val)
         obj.validateproperty('FolderPath',val);
         obj.FolderPath = val;
         obj.format_hg();
      end
      
      % FilePath        % full file path
      function val = get.FilePath(obj)
         if isempty(obj.FileName)
            val = '';
         else
            val = fullfile(obj.FolderPath,obj.FileName);
         end
      end
      function set.FilePath(obj,val)
         obj.validateproperty('FilePath',val);
         if isempty(val)
            obj.FileName = '';
         else
            [folder,val,ext] = fileparts(val);
            obj.FileName = '';
            obj.FolderPath = folder;
            obj.FileName = [val ext];
         end
         obj.format_hg();
      end
      
      % FileIODirection % {'get','put'} specify uisetfile/uiputfile
      function val = get.FileIODirection(obj)
         val = obj.propopts.FileIODirection.StringOptions{obj.getfile+1};
      end
      function set.FileIODirection(obj,val)
         [~,val] = obj.validateproperty('FileIODirection',val);
         obj.getfile = logical(val-1);
         
         % if getfile and current file does not exist, clear it
         if ~isempty(obj.FileName) && obj.getfile && ~exist(fullfile(obj.FolderPath,obj.FileName),'file')
            obj.FileName = '';
            obj.format_hg();
         end
      end
      
      % FileDialogTitle % file dialog title
      function val = get.FileDialogTitle(obj)
         val = char(obj.dialogtitle);
      end
      function set.FileDialogTitle(obj,val)
         obj.validateproperty('FileDialogTitle',val);
         if isempty(val)
            obj.dialogtitle = {};
         else
            obj.dialogtitle = cellstr(val);
         end
      end
      
      % FileFilterSpec  % file dialog filter specification
      function val = get.FileFilterSpec(obj)
         val = obj.filtspec;
      end
      function set.FileFilterSpec(obj,val)
         obj.validateproperty('FileFilterSpec',val);
         obj.filtspec = val;
         hist_changed = obj.update_hist(); % remove unsupported files in history
         file_cleared = false;
         file = obj.FileName;
         if ~isempty(file)
            try
               obj.validatefile(fullfile(obj.FolderPath,file),1);
            catch
               file_cleared = true;
               file = '';
            end
         end
         if hist_changed || file_cleared
            obj.FileName = file;
            obj.format_hg();
         end
      end
      
      % FileHistory     % {'on' 'off'} enables popupmenu list of past
      function val = get.FileHistory(obj)
         val = obj.propopts.FileHistory.StringOptions{obj.histon+1};
      end
      function set.FileHistory(obj,val)
         [~,val] = obj.validateproperty('FileHistory',val);
         obj.histon = logical(val-1);
         obj.format_hg();
      end
      
      % FileHistoryList % previously accessed files
      function val = get.FileHistoryList(obj)
         val = obj.histlist;
      end
      function set.FileHistoryList(obj,val)
         obj.validateproperty('FileHistoryList',val);
         obj.histlist = val;
         
         % expand max if exceeds it
         N = size(val,1);
         if N>obj.histmax
            obj.histmax = N;
         end
         
         if obj.update_hist()
            obj.format_hg();
         end
      end
      
      % FileHistoryDepth
      function val = get.FileHistoryDepth(obj)
         val = obj.histmax;
      end
      function set.FileHistoryDepth(obj,val)
         obj.validateproperty('FileHistoryDepth',val);
         obj.histmax = val;
         if size(obj.histlist,1)>obj.histmax && obj.update_hist()
            obj.format_hg();
         end
      end
      
      % FileDisplayOption % {'nameonly' 'fullpath'}
      function val = get.FileDisplayOption(obj)
         val = obj.propopts.FileDisplayOption.StringOptions{obj.nameonly+1};
      end
      function set.FileDisplayOption(obj,val)
         [~,val] = obj.validateproperty('FileDisplayOption',val);
         obj.nameonly = logical(val-1);
         obj.format_hg();
      end
   end
end
