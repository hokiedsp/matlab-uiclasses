function validatefile(obj,val,type)
%UIFILECONTROL/VALIDATEFILE   Validate new file name
%   VALIDATEFILE(OBJ,FILENAME,TYPE)
%   TYPE=1: full path
%   TYPE=2: file name
%   TYPE=3: folder path

% OK to be empty (except for the folder path)
if type~=3 && isempty(val), return; end

% first make sure it is a valid string data
if ~isempty(val)
   validateattributes(val,{'char'},{'row'});
end

if type==1
   [path,file,ext] = fileparts(val);
   file = strcat(file,ext);
elseif type==2
   file = val;
   path = '';
elseif type==3
   file = '';
   path = val;
end

% get full path
if isempty(file)
   file = obj.FileName;
else
   if ~isempty(regexp(file, '[/\*:?"<>|]', 'once'))
      error('Contains an invalid character');
   end
   
   expr = cellstr(obj.filtspec);
   expr = strcat('^',strrep(strrep(expr(:,1),'.','\.'),'*','.*?'),'$');
   if all(cellfun(@isempty,regexp(file,expr,'once')))
      error('File name does not match any spec given in the FileFilterSpec.');
   end
end

if isempty(path)
   path = obj.FolderPath;
else
   if ispc && ~isempty(regexp(path(1),'[a-zA-Z]','once')) && path(2)==':'
      path([1 2]) = []; % remove the drive letter
   end
   if ~isempty(regexp(path, ':[*?"<>|]', 'once'))
      error('Contains an invalid character');
   end
end

% if FileIODirection='get', the file must exist
if obj.getfile && ~exist(fullfile(path,file),'file')
   error('File and folder must exist if FileIODirection = ''get''.');
end

