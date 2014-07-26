function init(obj)
%HGAUXCTRL/INIT   Scalar-object one-time initialization during construction
%   INIT(OBJ) is called by the HGSETGETEX's constructor and shall
%   initialize OBJ's internal properties that are must be initialized prior
%   to setting any of its public properties or calling any of its public
%   methods. Before implementing necessary actions for the class, it should
%   call the INIT() of the superclass first.

obj.init@hgdisguise();

obj.aux_h = handle([]);
obj.aux_size = [20 20];
obj.aux_loc = 3;     % {1-'west',2-'south',3-'east',4-'north'}
obj.aux_halign = 1;  % {1-'left',2-'center',3-'right'}
obj.aux_valign = 3;  % {1-'bottom',2-'middle',3-'top'}
