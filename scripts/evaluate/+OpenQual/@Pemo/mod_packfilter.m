function y = mod_packfilter(b,a,x,fs,fdem)
%filtrace napric prvni dimenzi pole pres koeficienty filtru
% a nasledna decimace z fs na fdem
%
% author: Ing. Martin Zalabák, FEL ČVUT
%
buf = zeros(1,size(x,2));
N = floor(fs/fdem);
y = zeros(size(x,1),ceil(size(x,2)/N));
for i = 1:size(x,1)
  buf(:) = real(filter(b,a,x(i,:)));
  y(i,:) = decimate(buf(:),N);
end
