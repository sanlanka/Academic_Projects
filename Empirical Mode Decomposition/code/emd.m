function [imf,c]=emd(IS,time)

c = IS;
N = length(IS);
imf = [];
n=100;
%————————————————————————–

for t=1:n
h = c;
%————————————————————————–

d = diff(h);
maxmin = [];
for i=2:N-2
if d(i)==0
if sign(d(i-1))~=sign(d(i+1))
maxmin = [maxmin, i];
end
elseif sign(d(i))~=sign(d(i+1))
maxmin = [maxmin, i+1];
end
end

if size(maxmin,2) < 2
break
end

if maxmin(1)>maxmin(2)
maxes = maxmin(1:2:length(maxmin));
mins = maxmin(2:2:length(maxmin));
else
maxes = maxmin(2:2:length(maxmin));
mins = maxmin(1:2:length(maxmin));
end

maxes = [1 maxes N];
mins = [1 mins N];
maxenv = spline(maxes,h(maxes),1:N);
minenv = spline(mins, h(mins),1:N);

m = (maxenv + minenv)/2;
prevh = h;
h = h-m';

%————————————————————————–

imf = [imf; h'];



if size(maxmin,2) < 2
break
end

c = c - h;

end
imf = dct(IS);