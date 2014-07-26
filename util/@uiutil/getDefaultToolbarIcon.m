function icon = getDefaultToolbarIcon(filename,alpha_th)
%UIUTIL/getDefaultToolbarIcon   Retrieve icon image from MATLAB folder
%   getDefaultToolbarIcon(filename)

filename = uiutil.iconpath(filename);
[icon,map,alpha] = imread(filename);

if isempty(map)
   if isinteger(icon)
      icon = double(icon)/double(intmax(class(icon)));
   end
else
   icon = ind2rgb(icon,map);
end

if nargin>1
   sz = size(icon);
   alpha = rgb2gray(icon)>(alpha_th/255);
   icon = reshape(icon,[numel(icon)/3 3]);
   icon(reshape(alpha,[sz(1)*sz(2) 1]),:) = nan;
   icon = reshape(icon,sz);
elseif ~isempty(alpha)
   sz = size(icon);
   icon = reshape(icon,[numel(icon)/3 3]);
   icon(alpha==0,:) = nan;
   icon = reshape(icon,sz);
end
