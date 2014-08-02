function subs = nextcellsubs(obj,Nadd)
%UIFLOWGRIDCONTAINER/NEXTCELLSUBS   Get next available cell subscripts
%   SUBS = NEXTCELLSUBS(OBJ,N) gets subscripts for the next N cell
%   elements on UIFLOWGRIDCONTAINER OBJ. If the grid is full, it
%   automatically expands if OBJ.AutoExpand = 'on'.

% Determine the last occupied cell
if obj.rowfirst
   [J,I] = find(obj.map.'==0);
else
   [I,J] = find(obj.map==0);
end
if isempty(I)
   Navail = 0;
   subs = zeros(0,2);
else
   Navail = min(numel(I),Nadd);
   subs = [I(:) J(:)];
end
subs(Nadd+1:end,:) = [];

if Navail<Nadd
   % more elements to add than available grid cells
   
   if ~obj.autoexpand
      error('Grid is full.');
   end
   
   % get cell locations for the new elements (expand grid if necessary)
   
   if obj.rowfirst
      sz = obj.gridsize(2);
   else
      sz = obj.gridsize(1);
   end
   
   Nextra = Nadd-Navail;
   x0 = numel(obj.map) - 1;
   x = (x0+1):(x0+Nextra);
   I = floor(x/sz)+1;
   J = mod(x,sz)+1;
   
   if obj.rowfirst
      subs(Navail+1:Nadd,:) = [I(:) J(:)];
   else
      subs(Navail+1:Nadd,:) = [J(:) I(:)];
   end
   
end
