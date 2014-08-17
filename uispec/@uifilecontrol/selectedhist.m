function selectedhist(obj)
%UIFILECONTROL/SELECTEDHIST   Callback when file is selected from history 
%   SELECTEDHIST(OBJ)

I = get(obj.hg,'Value');
if I==1, return; end

% top item is the current file, adjust to obtain the index to obj.histlist
I = I - 1;

% store new file
[path,file] = deal(obj.histlist{I,:});

% add old file to hist
if ~isempty(obj.FileName)
   obj.histlist(2:I,:) = obj.histlist(1:I-1,:);
   obj.histlist{1,1} = obj.FolderPath;
   obj.histlist{1,2} = obj.FileName;
end

obj.FolderPath = path;
obj.FileName = file;

% format hg with the new file (& history)
obj.format_hg();

notify(obj,'FilePathChanged');
