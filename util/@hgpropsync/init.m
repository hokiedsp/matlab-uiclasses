function init(obj)
%HGPROPSYNC/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.srclis_prop_postset = handle([]);  % listens to property value change
obj.srclis_destroy = handle([]);      % listens to hg object destruction
obj.dstlis_destroy = handle([]);       % listens to hg object destruction

obj.propopts.SourceHandle = struct([]);
obj.propopts.SourceProperty = struct([]);
obj.propopts.TargetHandles = struct([]);
obj.propopts.TargetProperties = struct([]);
obj.propopts.Enabled = struct(...
   'StringOptions',{{'on','off'}});
