function layout_panel(obj)
%HGANDLABELS/LAYOUT_PANEL   (protected) Layout panel components
%   LAYOUT_PANEL(OBJ) layouts the child objects of OBJ.hg according to the
%   current panel size.

if ~obj.isattached() || ~obj.autolayout, return; end

al = obj.autolayout;
obj.autolayout = false;

% get container size
u = get(obj.hpanel,'Units');
set(obj.hg,'Units','pixels');
set(obj.hpanel,'Units','pixels');
set(obj.aux_h,'Units','pixels');

% get current positions
posp = get(obj.hpanel,'Position');
posh = posp;
posl = [zeros(1,2) obj.aux_size(1) obj.aux_size(2)]; % lock position

showaux = strcmp(get(obj,'Visible'),'on');

%{1'left',2'right',3'bottom',4'top'}

%Determine the panel size requirements, start with hg limits
if showaux
   if obj.aux_loc<3 % left/right
      % set the HG size (fill the hpanel minus the checkbox)
      posh(3) = max(posp(3)-obj.aux_size(1),2);
      
      % set horizontal locations
      if obj.aux_loc==1 % left
         posl(1) = 1;
         posh(1) = 1+obj.aux_size(1);
      else % right
         posh(1) = 1;
         posl(1) = 1+posh(3);
      end
      
      % set vertical locations
      posh(2) = 1;
      switch obj.aux_valign
         case 1 % bottom
            posl(2) = 1;
         case 2 % middle
            posl(2) = 1 + (posh(4) - posl(4))/2;
         otherwise %case 3 % top
            posl(2) = 1 + (posh(4) - posl(4));
      end
   else
      % set the HG size (fill the hpanel minus the checkbox)
      posh(4) = max(posp(4)-obj.aux_size(2),2);
      
      % set vertical locations
      if obj.aux_loc==3 % bottom
         posl(2) = 1;
         posh(2) = 1+obj.aux_size(2);
      else % top
         posh(2) = 1;
         posl(2) = 1+posh(4);
      end
      
      % set horizontal locations
      posh(1) = 1;
      switch obj.aux_halign
         case 1 % left
            posl(1) = 1;
         case 2 % center
            posl(1) = 1 + (posh(3) - posl(3))/2;
         case 3 % right
            posl(1) = 1 + (posh(3) - posl(3));
      end
   end

   set(obj.aux_h,'Position',posl);
end

set(obj.hg,'Position',posh);

% revert the unit
set(obj.hpanel,'Units',u);

% revert the auto-layout property
obj.autolayout = al;
