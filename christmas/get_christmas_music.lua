-- download_christmas.lua
-- ComputerCraft Downloader for Christmas NBS Songs

local BASE_URL = "https://github.com/petdono/nbs-music/raw/refs/heads/main/christmas/"
local DEST_DIR = "christmas"

local songs = {
    "Cranium - Frosty the Snowman.nbs",
    "Daniel Ingram - Winter Wrap Up.nbs",
    "Danny Elfman - A Nightmare Before Christmas.nbs",
    "Franz Xaver Gruber - Silent Night.nbs",
    "George Frideric Handel - Joy to the World.nbs",
    "James Lord Pierpont - Jingle Bells (Alt).nbs",
    "James Lord Pierpont - Jingle Bells.nbs",
    "Johnny Marks - Rudolph the Red-Nosed Reindeer.nbs",
    "Leroy Anderson - Sleigh Ride.nbs",
    "Mariah Carey - All I Want for Christmas Is You.nbs",
    "Meredith Willson - It's Beginning to Look a Lot Like Christmas.nbs",
    "Mykola Leontovych - Carol of the Bells (Alt).nbs",
    "Mykola Leontovych - Carol of the Bells.nbs",
    "Pyotr Ilyich Tchaikovsky - Nutcracker Dance of the Sugar Plum Fairies.nbs",
    "Pyotr Ilyich Tchaikovsky - Russian Dance.nbs",
    "Pyotr Ilyich Tchaikovsky - Waltz of the Flowers.nbs",
    "Robert Burns - Auld Lang Syne.nbs",
    "Traditional - Bells.nbs",
    "Traditional - The First Noel.nbs",
    "Traditional - Twelve Days of Christmas.nbs",
    "Traditional - We Wish You a Merry Christmas.nbs",
    "Trans-Siberian Orchestra - Wizards in Winter.nbs",
    "Wham! - Last Christmas.nbs"
}

-- Ensure HTTP is enabled in the ComputerCraft config
if not http then
    error("HTTP API is disabled in ComputerCraft config. Please enable it to download.")
end

-- Ensure destination directory exists
if not fs.exists(DEST_DIR) then
    fs.makeDir(DEST_DIR)
end

-- Simple URL encoder that converts spaces and special characters safely for GitHub raw URLs
local function urlEncode(str)
    return (str:gsub("([^%w%.%-%_])", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

print("=========================================")
print("  LumiControl Christmas Song Downloader  ")
print("=========================================")
print("Downloading " .. #songs .. " songs to '" .. DEST_DIR .. "/'...")
print("Please wait...\n")

local successCount = 0
for i, song in ipairs(songs) do
    local encodedSong = urlEncode(song)
    local url = BASE_URL .. encodedSong
    local destPath = fs.combine(DEST_DIR, song)
    
    write(string.format("[%2d/%2d] %s... ", i, #songs, song:sub(1, 24)))
    
    local response = http.get(url, nil, true) -- true for binary mode download
    if response then
        local data = response.readAll()
        response.close()
        
        local file = fs.open(destPath, "wb")
        if file then
            file.write(data)
            file.close()
            print("OK")
            successCount = successCount + 1
        else
            print("WRITE ERROR")
        end
    else
        print("HTTP ERROR")
    end
end

print("\nFinished! Successfully downloaded " .. successCount .. "/" .. #songs .. " songs.")
