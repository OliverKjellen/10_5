godMode = false
speedrunMode = false
infiniteLives = false
noEffects = false

konami.setWaitTime(0)

konami.newCode(
    {"g","o","d","m","o","d","e"},
    function()
        godMode = not godMode
    end
)

konami.newCode(
    {"s","p","e","e","d","r","u","n"},
    function()
        speedrunMode = not speedrunMode
        infiniteLives = speedrunMode
    end
)

konami.newCode(
    {"up","up","down","down","left","right","left","right","b","a"},
    function()
        infiniteLives = not infiniteLives
    end
)

konami.newCode(
    {"s","t","o","p"},
    function()
        godMode = false
        speedrunMode = false
        infiniteLives = false
    end
)

konami.newCode(
    {"e","f","f","o","f","f"},
    function()
        noEffects = true
        effect.disable(unpack(moonshineFilters))
    end
)

konami.newCode(
    {"e","f","f","o","n"},
    function()
        noEffects = false
        effect.enable(unpack(moonshineFilters))
    end
)
