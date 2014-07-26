function tf = ispanel(h)
%UIPANELEX/ISPANEL   true if HG object can be attached to UIPANELEX
%   ISPANEL(H) returns a logical array that contains trues if where the
%   elements of H are HG objects which could be attached to OBJ and falses
%   where they are not.

narginchk(1,1);

tf = ishghandle(h);
tf(strcmp(get(h(tf),'Type'),'uicontrol')) = false;
for n = find(tf(:)).';
   % try to add a dummy event listener
   try
      lis = addlistener(h(n),'ObjectChildAdded',@(~,~)disp(''));
      delete(lis);
   catch
      tf(n) = false;
   end
end
