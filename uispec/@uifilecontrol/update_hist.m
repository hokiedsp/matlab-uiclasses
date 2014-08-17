function changed = update_hist(obj)
%UIFILECONTROL/UPDATE_HIST (protected)
%   UPDATE_HIST(OBJ,FORCE)
%   FORCE=true to update display regardless

% only keep unique files
N = size(obj.histlist,1);
dupfound = N>0;
if dupfound
   [filenames,I] = unique(fullfile(obj.histlist(:,1),obj.histlist(:,2)),'stable');
   obj.histlist = obj.histlist(I,:);
   dupfound = numel(filenames)~=N;
   
   % check every file in the history list to make sure all are comforming with
   % file type & IO direction
   N = numel(filenames);
   isbad = false(N,1);
   for n = 1:N
      try
         obj.validatefile(filenames{n},1);
      catch
         isbad(n) = true;
      end
   end
   obj.histlist(isbad,:) = [];
else
   isbad = false;
end

% do not exceed max # allowed
shrunk = size(obj.histlist,1)>obj.histmax;
obj.histlist(obj.histmax+1:end,:) = [];

% update displayed history if anything changed
changed = dupfound||shrunk||any(isbad);
