term.clear()
term.setCursorPos(1,1)

local version = "0.1.0"

local items_per_page = 6
local entries = {}

local current_page = none

local input = none

os.pullEvent = os.pullEventRaw

--Read Password
function read_password()
    if fs.exists("veb/config/password") then
        local password_read = fs.open("veb/config/password", "r")
        return password_read.readAll()
    else
        return none
    end
end
----------------
local password = read_password()
if password ~= none then
    print("Type password")
    input = read()
    if input == password then
        term.setTextColor(colors.lime)
        print("Password correct")
        term.setTextColor(colors.white)
        sleep(3)
    else
        term.setTextColor(colors.red)
        print("Password incorrect")
        sleep(3)
        os.reboot()
    end
end

-- Get entries
local function get_entries()
    local detected_entries = fs.find("veb/entries/*")
    local counter = 1
    for i in detected_entries, 1, table.getn(detected_entries) do
        table.insert(entries, counter, i)
    end
end

-- Print entry along with id
local function print_entry(id)
    print(string.format("%d: %s ", id, get_entries[id]))
end

-- Print entire page
local function print_page(page)
    
end

term.clear()
term.setCursorPos(1, 1)
print("Welcome to Veb bootloader!")
term.setCursorPos(45, 1)
print(version)
term.setCursorPos(1, 3)
print("Quit to terminal: Q")
term.setCursorPos(35, 3)
print("Switch page: A/D")
term.setCursorPos(1, 4)
term.setTextColor(colors.red)
print("Enter Vesh (VEb SHell)")
term.setCursorPos(1, 35)
print ("Vesh in W.I.P (locked)")
term.setCursorPos(1, 6)
print("Type an entry ID to boot into it")

