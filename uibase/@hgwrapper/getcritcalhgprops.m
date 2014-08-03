function [HgGiven,prt,vis,args] = getcritcalhgprops(args,Iend)
% look for 'Parent' and 'Visible' properties

% convert all the property pair arguments to cell format
[proppairs,cellprops] = hgsetgetex.unifyproppairs(args(Iend+1:end));

if cellprops
   pn = proppairs{1};
   pv = proppairs{2};
else
   pn = proppairs(Iend+1:2:end);
   pv = proppairs(Iend+2:2:end);
end

% check if GraphicsHandle is specified
HgGiven = any(strcmpi(pn,'GraphicsHandle'));

if HgGiven
   % if GraphicsHandle is indeed specified, none of the HG properties in
   % the argument is not critical.
   prt = {};
   vis = {};
else
   % Look for Parent property
   I = find(strcmpi(pn,'Parent'));
   if isempty(I)
      prt = {};
   else
      prt = pv(:,I(end));
      pn(I) = [];
      pv(:,I) = [];
      
      for n = 1:numel(prt)
         p = prt{n};
         if isa(p,'hgwrapper')
            prt{n} = p.GraphicsHandle;
         end
      end
      
   end
   
   % Look for Visible property
   I = find(strcmpi(pn,'Visible'));
   if isempty(I)
      vis = {};
   else
      vis = pv(:,I(end)); % report the last value only
      pn(I) = [];
      pv(:,I) = [];
   end
   
   % Remove the Parent & Visible properties from input arguments
   if cellprops
      args = {pn pv};
   else
      args = cell(1,numel(pn)+numel(pv));
      args(1:2:end) = pn;
      args(2:2:end) = pv;
   end
end
