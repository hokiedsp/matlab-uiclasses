function validatehg(obj,h)
%UIPANELEX/VALIDATEHG   Check for HG object compatibility
%   VALIDATEHG(OBJ,H) is called by HGWRAPPER/ATTACH() to make sure that the
%   HG object H is compatible with OBJ. VALIDATEHG errors out if H is not
%   supported by OBJ.

obj.validatehg@hgenable(h);

if ~all(uipanelex.ispanel(h))
   error('HG object must have ''Children'' property and has ObjectChildAdded event.');
end
