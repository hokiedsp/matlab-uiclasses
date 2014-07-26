function init(obj)
%HGWRAPPER/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods.

obj.hg_listener = handle([]); % HG object event listeners
obj.detachable = true;
obj.attachable = false;
obj.indelete = false;

obj.propopts.GraphicsHandle = struct([]);
obj.propopts.AutoDetach = struct(...
      'StringOptions',{{'on','off'}},...
      'Default','off');
obj.propopts.HGDetachable = struct(...
      'StringOptions',{{'on','off'}});
obj.propopts.Parent = struct(...
   'OtherTypeValidator',@validateparent);
obj.nprops = 0; % clear just in case 
   
% update nprops 
obj.sortpropopts(4,false,false,true,true);
%sortpropopts(OBJ,Nsub,GROUP,SUB2TOP,MERGE,SORT)

obj.hg_listener = handle([]);

end

function validateparent(val)
   if ~isscalar(val)
      error('Parent object must be scalar.');
   end
   if isa(val,'hgwrapper')
      if ~val.isattached();
         error('Parent HGWRAPPER object must be attached to HG object.');
      end
   elseif ~ishghandle(val)
      error('Invalid Parent object.');
   end
end
