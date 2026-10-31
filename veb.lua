local version = "0.1.0"

local items_per_page = 8
local entries = {}

local current_page = 1
local num_pages =  nil
local page_limit = nil

os.pullEvent = os.pullEventRaw

--Read Password
local function read_password()
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

-- print top bar
local function print_top()
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
    term.setCursorPos(30, 4)
    print ("Vesh in W.I.P (locked)")
    term.setTextColor(colors.white)
    term.setCursorPos(1, 6)
    print("Type an entry ID to boot into it")
    term.setCursorPos(1, 30)
    print(string.format("Page: %d", current_page))
end

-- Get entries
local function get_entries()
    local detected_entries = fs.find("veb/os-entries/*")
    local counter = 1

    for i = 1, table.getn(detected_entries) do
        --table.insert(entries, counter, i)
        table.insert(entries, counter)
        counter = counter + 1
    end
    num_pages = math.floor((table.getn(entries) / 8) + 0.5)
end

-- Print entry along with id
local function print_entry(id)
    print(string.format("%d: %s ", id, entries[id]))
end

-- Print entire page
local function print_page(page)
    term.clear()
    print_top()

    local page_limit = nil
    local page_start = (page - 1) * items_per_page + 1
    local page_end = page * items_per_page

    page_limit =  math.min(page_end, table.getn(entries))

    for i = page_start, page_limit do
        print_entry(i)
    end
end

-- Switches page
local function turn_page(direction)
    if direction == "left" then
        if (current_page - 1) ~= 0 then
            current_page = current_page - 1
            print_page(current_page)
        end
    else
        if (current_page + 1) ~= (num_pages + 1) then
            current_page = current_page + 1
            print_page(current_page)
        end
    end
end

local function boot_into_key(key)
    print("soon")
end

-- Reads input
local function read_input(arg)
    if arg == "q" then
        return

    elseif arg == "a" then
        turn_page("left")

    elseif arg == "d" then
        turn_page("right")
    
    elseif type(arg) == "number" then
        if math.type(arg) == "integer" then
            if arg > 0 and arg < (table.getn(entries) +1) then
                boot_into_key(arg)
            end
        end

    else
        print("Input not detected")
    end
end



entries = get_entries()

print_page(1)

while true do
    read_input(read())
end