function setcounterformat(obj,val)
%UIVIDEOVIEWER/SETCOUNTERFORMAT

obj.txformat = val;

% construct actual sprintf format string
regexp(val,'(?<pctsym>%%|(?<frame>%f+)|(?<second>%s+)|(?<minute>%m+)|(?<hour>%h+)|(?<pct>%p+)','names','ignorecase');
[I0,I1] = regexp(val,{'(?<!%)%f+','(?<!%)%s+','(?<!%)%m+','(?<!%)%h+'},'Start','End','ignorecase');

type = arrayfun(@(i,k)repmat(k{1},size(i{1})),I0,{1 2 3 4},'UniformOutput',false);
[I,idx] = sortrows([I0{:};I1{:}].',1);
type = [type{:}];
type = type(idx);
obj.txmode = max(type);
N = diff(I,[],2);

Nmax = zeros(4,1); %[f s m h]
if obj.txmode>2 % shows more than minutes
   Nmax(2) = 2; % limit seconds to 2 digits
   if obj.txmode>3 % shows hours
      Nmax(3) = 2; % limit minutes to 2 digits
   end
end
N = max(N,Nmax(type));

for i = size(I,1):-1:1
   if type(i)==2 % seconds
      val = sprintf('%s%%0%d.3f%s',val(1:I(i,1)-1),N(i)+4,val(I(i,2)+1:end));
   else % others
      val = sprintf('%s%%0%dd%s',val(1:I(i,1)-1),N(i),val(I(i,2)+1:end));
   end
end
obj.txfmtfcn = @(data)sprintf(val,data{type});

% update frame
if obj.isopen()
   obj.setcurrentframe();
end
