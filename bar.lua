local tokens = require('tokens');

local bar = {};

bar.State = { IsOpen = { true } };

bar.Render = function(self)
    if (self.State.IsOpen[1]) then
    
    end
end


return bar;