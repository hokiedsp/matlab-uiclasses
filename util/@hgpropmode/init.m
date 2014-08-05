function init(obj)
%HGPROPMODE/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.valchg = false;

obj.propopts.GraphicsHandle = struct([]);
obj.propopts.PropertyName = struct([]);
obj.propopts.DefaultValue = struct([]);
obj.propopts.Enabled = struct(...
   'StringOptions',{{'on','off'}});
