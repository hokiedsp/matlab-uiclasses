function format_hg(obj)
%UIFILECONTROL/FORMAT_HG (protected)
%   FORMAT_HG(OBJ) updates the obj.hg controls to show OBJ data content
%
%   FORMAT_HG(OBJ,NEWFILENAME) updates obj.hg controls with the new file
%   name NEWFILENAME and NEWFILENAME gets assigned as the new OBJ.FileName
%   at the end of FORMAT_HG. Empty NEWFILENAME is allowed.
%
%   FORMAT_HG(OBJ,NEWFILENAME,NEWFOLDERPATH) also gets the new foler
%   location for the file. OBJ.FolderPath gets replaced by NEWFOLDERPATH at
%   the end of FORMAT_HG. NEWFOLDERPATH must contain a valid directory.

% only if HG shown
if ~obj.isattached(), return; end

% Get file name
file = obj.FileName;
if isempty(file)
   file = ''; % make sure it is empty char
   fullpath = '';
else
   fullpath = fullfile(obj.FolderPath,file);
end
p.TooltipString = fullpath;

if ~obj.nameonly
   file = fullpath;
end

if obj.histon % popupmenu
   p.Style = 'popupmenu';
   p.Value = 1;
   p.Enable = 'inactive';
   p.ButtonDownFcn = @(~,~)obj.promptuser(true);
   
   if isempty(obj.histlist)
      hist = {};
   else
      % get history
      if obj.nameonly
         hist = obj.histlist(:,2);
      else
         hist = fullfile(obj.histlist(:,1),obj.histlist(:,2));
      end
      
      % adjust hist according to the current file
      if ~isempty(file)
         p.Enable = 'on';
         p.ButtonDownFcn = [];
      end
   end
   
   %prepend currently selected file
   hist(2:end+1) = hist;
   if isempty(file)
      hist{1} = ' ';
   else
      hist{1} = file;
   end
   
   p.String = hist;
   p.Callback = @(~,~)obj.selectedhist();
else % edit
   p.Style = 'edit';
   p.String = file;
   p.Enable = 'inactive';
   p.ButtonDownFcn = @(~,~)obj.promptuser(false);
end

% update the HG object
set(obj.hg,p);
set(obj.aux_h,'TooltipString',p.TooltipString);
