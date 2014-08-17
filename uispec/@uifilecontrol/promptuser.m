function promptuser(obj,combobox)
%UIFILECONTROL/PROMPTUSER   Button
%   PROMPTUSER(OBJ,COMBOBOX)

if ~strcmp(obj.Enable,'on'), return; end

% if history enabled, only proceed clicked in the non-pulldown section of
% popupmenu
if combobox
   ptrpos = getptrpixelposition(obj.hg);
   set(obj.hg,'Units','pixels');
   pos = get(obj.hg,'Position');
   if pos(3)-ptrpos(1)<16, return; end
   %set(obj.hg,'Enable','inactive')
end

if obj.getfile
   fcn = @uigetfile;
else
   fcn = @uiputfile;
end

oldfile = fullfile(obj.FolderPath,obj.FileName);
[newfilename,newfolderpath] = fcn(obj.filtspec,obj.dialogtitle{:},oldfile);
if isequal(newfilename,0) || isequal(newfolderpath,0), return; end % user canceled

newfile = fullfile(newfolderpath,newfilename);
if strcmp(oldfile,newfile) || (ispc && strcmpi(oldfile,newfile)), return; end % same file

% add old file to hist
if ~isempty(obj.FileName)
   
   % add the previously selected file to the history
   N = min(size(obj.histlist,1)+1,obj.histmax);
   obj.histlist(2:N,:) = obj.histlist(1:N-1,:);
   obj.histlist{1,1} = obj.FolderPath;
   obj.histlist{1,2} = obj.FileName;

   % if file from history is selected, remove it from the history
   I = strcmp(obj.histlist(:,1),newfolderpath) ...
      & strcmp(obj.histlist(:,2),newfilename);
   obj.histlist(I,:) = [];

end

obj.FolderPath = newfolderpath;
obj.FileName = newfilename;

% format hg with the new file (& history)
obj.format_hg();

notify(obj,'FilePathChanged');
