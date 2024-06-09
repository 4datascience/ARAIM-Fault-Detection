%%
function LogPrint(text, spaces)

if nargin == 1,
    spaces = 0;
end

for k=1:spaces,
    disp('');
end
disp([datestr(now, 'YYYY-mm-dd HH:MM:SS: '), text]);

end






























