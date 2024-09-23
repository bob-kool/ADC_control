function [shot,subshot] = parse_shot_specification(shot)
%PARSE_SHOT_SPECIFICATION Convert "48648a" to 48648 and a.

subshot = "";
if isstring(shot)
    % set the subshot to a
    re = regexp(shot,'^([0-9]+)([a-z]?)$','tokens');
    if isempty(re)
        error(strcat(shot, " is not a valid shot specification"))
    end
    shot = str2num(re{1}{1});
    if ~isempty(re{1}{2})
        subshot = re{1}{2};
    end
end

end

