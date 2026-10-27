local function write_file(path, data)
    local file = fs.open(path, "w")
    file.write(data)
    file.close()
end

local function loading_bar(speed)
    term.setTextColor(colors.white)
    textutils.slowPrint("##########", speed)
end

local function text_color(color)
    term.setTextColor(color)
end

local function reset_text_color()
    term.setTextColor(colors.white)
end

local function reset_cursor_pos()
    term.setCursorPos(1,1)
end

local function set_cursor_pos(x, y)
    term.setCursorPos(x,y)
end

local function clear_and_reset_cursor_pos()
    term.clear()
    term.setCursorPos(1,1)
end

local function file_exists(path)
    return fs.exists(path)
end

local function make_directory(path)
    fs.makeDir(path)
end
--
local install_successfull = false
local input = nil

local password = false


clear_and_reset_cursor_pos()
sleep(1)
print("Do you wish to install Veb? [Y/n]")
input = read()

if input == "y" then
    set_cursor_pos(1,6)
    print("Installing")

    if file_exists("startup/veb.lua") then
        text_color(colors.red)
        print("Critical: Installer detected already existing file at /startup/veb.lua")
        reset_text_color()
        print("Overwrite file (pressing no cancels Veb installer)? [Y/n]")
        input = read() 
        if input == "y" then
            fs.delete("startup/veb.lua")
        else
            return
        end
            
    end

    -- Generates directories
    sleep(1)
    if file_exists("startup/") == false then
        make_directory("startup/")
    end
    make_directory("veb/os-entries")
    make_directory("veb/config")

    shell.run("wget", "https://raw.githubusercontent.com/Lava51/Veb/refs/heads/main/veb.lua startup/veb.lua")

    -- Resets passwords from previous install
    if file_exists("veb/config/password") then
    fs.delete("veb/config/password")
    end
    
    -- Veb install done
    loading_bar(4)
    text_color(colors.lime)
    print("Veb succesfully installed, press enter to continue.")
    reset_text_color()
    read()
    
    -- Check for PMM
    if file_exists("pmm/") then
        -- PMM exists
        install_successfull = true
    else
        -- PMM not detected
        term.clear()
        term.setCursorPos(1,1)
        print("PMM not detected, but is heavily reccomended for veb")
        print("Install PMM? [Y/n]")
        input = read()
        
        -- Install PMM
        if input == "y" then
            term.setCursorPos(1,4)
            print("Installing PMM")
            textutils.slowPrint("##########", 5)
            term.setTextColor(colors.lime)
            shell.run("pastebin", "run", "1ciBiKbr")
            print("Successfully installed PMM")
            term.setTextColor(colors.white)
            term.setCursorPos(1, 9)
            print("Adding PPM entry") 
            
            -- Add PMM entry
            metadata_string = [[
                name = Veb
                id = veb-bootloader
                version = 1.0.0
                author = Lava
                type = 2

                directoryList = {"/veb"}
            ]]
            write_file("pmm/packages/veb/entry.lua", metadata_string)
            ----------------
            loading_bar(6)
            install_successfull = true
            text_color(colors.lime)
            print("Finished")
            reset_text_color()
            print("press enter button to continue")
            read()
        
        -- Skip PMM
        elseif input == "n" then
            install_successfull = true
            print("press enter button to countinue")
            read()
        else
            print("Input not valid. Aborting")
            return
        end            
    end

-- Cancel Veb install
elseif input == "n" then
    term.setCursorPos(1,4)
    term.setTextColor(colors.red)
    print("Aborting")
    return

else
    term.setCursorPos(1,4)
    print("Input not valid. Aborting")
    return
end

-- Ask user for requiring password on bootup
if install_successfull == true then
    term.clear()
    term.setCursorPos(1,1)
    print("Require password? [Y/n]")
    input = read()
    
    -- Ask for passwrod
    if input == "y" then
        print("Please type in password")
        password = read()
        
        --Store Password
        password_write = fs.open("veb/config/password", "w")
        password_write.write(password)
        password_write.close()
    end
    
    -- Reboot computer or exit to terminal.
    print("Type 'Q' to reboot into Veb")
    print("Type 'E' to exit to terminal")
end

    input = read()

    -- Reboot computer
    if input == 'q' then
        os.reboot()

    -- Exit to terminal
    elseif input == 'e' then
        return
    else
        return
    end
