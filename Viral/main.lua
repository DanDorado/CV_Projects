--TO DO FOR WORKING PROTOTYPE
    -- dynamically change the ship layout in fringe cases such as one stat much larger than others.
        --create the hp room
    -- create the stats for starting virus based off of a normal distribution
        --levelup
        --starting level, with a higher level giving worse stats for that level.
 
    -- Create  either teleporters or a system to move around the ships in.
 
    --Create hp tanks.
 
    --Create ways for the player to move around the system.
 
    --Improve menu system
 
    --Only render the virus grid if it is on screen.
 
    --Make attack splitting.
 
    --Allow cunning attacks to make "uploads" in the system.
 
    -- Create actual balls for the impulse system.
 
    -- Insert sprites from internet
 
    -- Allow crossvirus attacks/interactions.

 
--Defined Variables from the very start
    --Window Size
    WINDOW_WIDTH = 1280
    WINDOW_HEIGHT = 680
--File location on computer ==TODO== dynamically solve for each computer. Check how to make a single exe file.
    flocation = "C:\\Users\\Dan\\Desktop\\Viraltrial\\"
--sizes used for panels
    tilewidth = 30
    tileheight = 20
    gap = tilewidth/10
--sets of stats for display in game, can be switched out depending on pickups etc.
    statnames = {
        {"INT", "SPEED", "STRENGTH", "TOUGHNESS", "TECHNIQUE", "FORTITUDE", "CUNNING", "WILL"},
        {"OPERATIONS", "LOGISTICS", "INDUSTRY", "ACCOUNTING", "R&D", "MARKETING", "CORPORATE ESPIONAGE", "I.T."}
    }
    -- the currently used statnames
    statmode = 1
    --Sets of colours used. 1 - 8 colours, 9 is white. Can be switched out for different styles.
    statcolors = {
        {{66, 33, 0}, {0, 0, 75}, {0, 75, 0}, {75, 0, 0}, {0, 50, 50}, {50, 0, 50}, {50, 50, 0}, {0, 66, 33}, {255, 255, 255}},
        {{25, 25, 25}, {30, 30, 30}, {35, 35, 35}, {40, 40, 40}, {45, 45, 45}, {15, 15, 15}, {20, 20, 20}, {50, 50, 50}, {155, 155, 155}}
    }
    -- The currently used colormode
    colormode = 1
-- to be used to keep track of the gamestate for the purposes of controls.
    gamestate = 1
--Used to keep track of the avatar
    avatarstate = {"TabletView"}
--
--------------------------AT GAME START----------------------------

function love.load()

    --Sets up a random seed for the run to use. ==TODO== have the option to set/save the seed.
    love.math.setRandomSeed(os.time())
    -- GLOBAL VARIABLES THAT ARE NOT DATABASES

        --used to keep track of time and trigger the first runners from the OperationsRoom
        tick = 0

        jerk = 0

        gridclickbuttoncreate = {}

        pause = false
        
        entry = ""

    -- Sets up the initial window size (WIDTH, HEIGHT, FULLSCREEN, VSYNC, RESIZE)
    windowset(WINDOW_WIDTH, WINDOW_HEIGHT, false, true, false)    
    --
    

    --overwrite manually written ID with generated one
    overwriteallvirusid()
      
    --Creats a list of stats for each player accessible from all areas.  THE MAIN HOLDER OF INFO TO USE. THIS STARTS EMPTY BUT IS ADDED TO SO THAT THE NOTES BELOW APPLY.
    player = {}
    --NOTES:
            -- player[x][1][n] is a list of stats for the nth virusof the xth player. Takes the form:
                --(id, lvl, virname, intelligence, speed, strength, toughness, technique, fortitude, cunning, will, maxhp, currenthp, progno)
            -- player[x][2][n] is the layout of the statroomsroom of the nth player of the xth player. Takes the form:
                --player[x][2][n][1][1] is the tileroom for int, player[x][2][n][1][2] is for speed, then str, tou, tech, fort, cunning, will.
                --player[x][2][n][2][1] is the progroom for int, player[x][2][n][2][2] is for speed, then str, tou, tech, fort, cunning, will.
                --player[x][2][n][3][1] is the heartbeatroom for int, player[x][2][n][3][2] is for speed, then str, tou, tech, fort, cunning, will.
                --A list of integers which correspond to tile types, 0 being locked tiles, 1 being blank tiles.
            -- player[x][3] is the name of the xth player.
            --player[x][4] is the ship loadouts for the xth player.
            --By convention player[1] is the human controlled player.
    --

    -- INITIALISING VALUES. These have a value set to them just so that there is a default option, but will be altered through the game.
    --Viewplayer is the "active player" for controlling/viewing. Begin this as the player.
        viewplayer = 1
    --Set which virus you want to watch/control.
        viewvirus = 1
    --sets the battlegrid that will be used for the map.
        activegrid = 1
end

-- Do this every frame to update the game for ongoing processes. Should be visual effects only.
function love.update(dt)
    -- ==TODO== have a background grid in the main menu with something visual happening?
    if pause == false then
        if gamestate == 1 then
        --Moves the "impulse" through the brainstem/virus.
        elseif gamestate == 2 then
            heartbeat(viewplayer, viewvirus)
        elseif gamestate == 3 then
            if button[3][1][10] == 1 then
                for i = 1, table.getn(turn[2]) do
                    heartbeat(turn[2][i][2], turn[2][i][3])
                end
            end
            if button[3][4][10] == 1 then
                    timeplus()
            end
        end
    end
end

--------------------Do this every frame and draw to the screen.-------------------
function love.draw()
    -- For each button for the current gamestate draw a rectangle in that position.
    buttondraw()
    -- For the main menu draws the 1st and second player with their viruses.
    if gamestate == 1 then
        if player[1] ~= nil then
            playerdraw(1, 0, "left")
        end
        if player[2] ~= nil then
            playerdraw(2, WINDOW_WIDTH - 100, "right")
        end
    end
    -- For the shipview menu draws the stats of the ship you are viewing.
    if gamestate == 2 then
        if avatarstate[1] == "TabletView" then
            OpGridDraw(viewplayer, viewvirus, 0, 0, 1)
        else    
            OpGridDraw(avatarstate[2][1], avatarstate[2][2], 0, 0, 1)
        end
        drawprogs()
        statdraw(player[viewplayer][1][viewvirus], 0, player[viewplayer][3])
    end
    -- For the battlegrid draws the panels of the battlegrid and the loaded viruses.
    if gamestate == 3 then
        battlegriddraw()
        OpGridDraw(1, 1, -15, 7, 0)
        OpGridDraw(2, 1, 15, 7, 0)
        turndraw()
        hpdraw(1, 1, WINDOW_WIDTH/2 - 250, 30, 40, 100)
        hpdraw(2, 1, WINDOW_WIDTH/2 + 250, 30, 40, 100)
    end
    -- Prints something center-top mainly for debugging purposes.
    statcolor(9, 1)
    centerprint(jerk)

    if gamestate == 5 then
        gamestartdraw()
    end

    if pause == true then
        pausedraw()
    end
end



--INPUT FUNCTIONS
-- Everything that is done when the mouse is clicked. x,y are coordinates of mousepointer, click is 0,2,.. leftclick/rightclick/...
    function love.mousepressed(x, y, click)
        --Stopcheck makes sure that one click can never trigger multiple buttons and stops checking after one is triggered.
        local stopcheck = 0
        --Check each button for the current gamestate.
        for i = 1, table.getn(button[gamestate]) do
            if stopcheck == 0 then
                --If the button is currently active.
                if button[gamestate][i][9] == 1 then
                    --If the click type has a response for that button then
                    if button[gamestate][i][7][click] ~= 0 then
                        if 
                        -- If you are within the x and y bounds of that button with your mouse.
                        (
                            (button[gamestate][i][1] < x) and (x < button[gamestate][i][1] + button[gamestate][i][3])
                        ) and (
                            (button[gamestate][i][2] < y) and y < (button[gamestate][i][2] + button[gamestate][i][4])
                        ) then
                            -- stop checking for buttons and trigger the embedded function without variables.
                            stopcheck = 1
                            button[gamestate][i][7][click]()
                        end
                    end
                end
            end
        end
        --if a button hasn't been pressed
        if stopcheck ~= 1 then
            -- if leftclick
            if click == 1 then
                for i = 1, table.getn(gridclickbuttoncreate) do
                    if --the mouse is over one of the panels
                    (
                        ( WINDOW_WIDTH/2 - gridclickbuttoncreate[i][1] / 2 + (gridclickbuttoncreate[i][3] * (gridclickbuttoncreate[i][1] + gridclickbuttoncreate[i][7])) + (gridclickbuttoncreate[i][1] + gridclickbuttoncreate[i][7]) * gridclickbuttoncreate[i][5] < x) 
                    and 
                        ( x < WINDOW_WIDTH/2 - gridclickbuttoncreate[i][1] / 2 + (gridclickbuttoncreate[i][3] * (gridclickbuttoncreate[i][1] + gridclickbuttoncreate[i][7])) + (gridclickbuttoncreate[i][1] + gridclickbuttoncreate[i][7]) * gridclickbuttoncreate[i][5] + gridclickbuttoncreate[i][1] )
                    )
                    and
                    (
                        ( WINDOW_HEIGHT/2 - gridclickbuttoncreate[i][2] / 2 + (gridclickbuttoncreate[i][4] * (gridclickbuttoncreate[i][2] + gridclickbuttoncreate[i][7])) + (gridclickbuttoncreate[i][2] + gridclickbuttoncreate[i][7]) * gridclickbuttoncreate[i][6] < y)
                    and 
                        ( y < WINDOW_HEIGHT/2 - gridclickbuttoncreate[i][2] / 2 + (gridclickbuttoncreate[i][4] * (gridclickbuttoncreate[i][2] + gridclickbuttoncreate[i][7])) + (gridclickbuttoncreate[i][2] + gridclickbuttoncreate[i][7]) * gridclickbuttoncreate[i][6] + gridclickbuttoncreate[i][2])
                    )
                    then
                        --if the mouse is holding something then
                        if grabbedvalue[1] ~= nil then
                            if checkpanelappropriate(viewplayer, viewvirus, grabbedvalue, button[2][2][10], i) == true then
                                player[viewplayer][2][viewvirus][2][button[2][2][10]][i] = {}
                                for statpart = 1, table.getn(grabbedvalue) do 
                                    player[viewplayer][2][viewvirus][2][button[2][2][10]][i][statpart] = grabbedvalue[statpart]
                                end
                                player[viewplayer][2][viewvirus][2][button[2][2][10]][i][4] = {}
                                for j = 1, table.getn(dbprog[grabbedvalue[1]][grabbedvalue[2]][grabbedvalue[3]][7]) do
                                    table.insert(player[viewplayer][2][viewvirus][2][button[2][2][10]][i][4], { tonumber(dbprog[grabbedvalue[1]][grabbedvalue[2]][grabbedvalue[3]][7][j]) })
                                end
                            end
                        else
                            player[viewplayer][2][viewvirus][2][button[2][2][10]][i] = 0
                        end
                    end
                end
            end
        end
        if gamestate == 2 then
            --if creating a virus then.
            if click == 1 then
                local progs = table.getn(player[viewplayer][1][viewvirus][15][button[2][2][10]])
                local width = 50
                local height = 50
                local gap = 6
                local stop = 0
                for i = 1, progs do
                    if stop == 0 then
                        if (y < WINDOW_HEIGHT - gap) and (y > WINDOW_HEIGHT - gap - height) then
                            if (x < WINDOW_WIDTH/2 + width/2 - ((width/2 + gap/2) * (progs-1)) + (width + gap) * (i - 1)) and (x > WINDOW_WIDTH/2 - width/2 - ((width/2 + gap/2) * (progs-1)) + (width + gap) * (i - 1)) then
                                stop = 1
                                

                                

                                if highlightprogs[i] == 1 then
                                    highlightprogs[i] = 0
                                    grabbedvalue = {nil}
                                else
                                    for j = 1, table.getn(highlightprogs) do
                                        highlightprogs[j] = 0
                                    end
                                    highlightprogs[i] = 1
                                    grabbedvalue = player[viewplayer][1][viewvirus][15][button[2][2][10]][i]
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    -- Depending on gamestate, do different things when keys are pressed. THESE ARE PRETTY MUCH TEST-ONLY TO MAKE SURE THINGS WILL WORK PROPERLY AND WILL NEED DEBUGGING.
    -- key is the key pressed, x can be ignored, denotes scanholder, rep returns true/false depending on if the computer thinks the keypress might have been an accidental repeat press.
    function love.keypressed(key, x, rep)
        if key == "escape" then
            if pause == false then
                entry = ""
                pause = true
            else
                --then exits the game completely.
                pause = false
            end
        end
        if pause == false then
            if key == "#" then
                writeall(player, "hero")
            end
            if key == ";" then
                player = readall("hero")
            end
            if key == "-" then
                --savegame(entry)
                savevirus(viewplayer, viewvirus, entry)
                --loadvirus(viewplayer, viewvirus, entry)
            end
            if key == "0" then
                loadstartingai(1, 1, 5, 1)
            end
            --IN THE SHIPVIEW MENU
            if gamestate == 2 then
                
                

                if avatarstate[1] == "TabletView" then
                    -- While holding down shift

                    if key == "return" then
                        if rep == false then
                            player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {5, 1, 1}
                            injectavatar(1, 1, 1)
                        end
                    end

                    if love.keyboard.isDown("lshift" or "rshift") then
                        --pressing the number of a player shifts to view/control that player
                        for playern = 1, table.getn(player) do
                            if key == tostring(playern) then
                                viewplayer = playern
                                --if this tries to switch to a nonexistant virus, switch to virus one instead.
                                if viewvirus > table.getn(player[playern]) then
                                    viewvirus = 1
                                end
                            end
                        end
                        --TEST ONLY -- increases intelligence by one.
                        if key == "g" then
                            if rep == false then
                                player[viewplayer][1][viewvirus][4] = math.max(player[viewplayer][1][viewvirus][4] + 1, 1)
                                player[viewplayer][2] = statroominit(player[viewplayer][1])
                                shipstitch(viewplayer, viewvirus)
                            end
                        -- TEST ONLY -- increases the size of panels.
                        elseif key == "p" then
                            if rep == false then
                                tilewidth = math.max(tilewidth + 3, 3)
                                tileheight = math.max(tileheight + 2, 2)
                            end
                        
                        -- TEST ONLY -- adds another player with a few viruses.
                        
                        -- TEST ONLY -- overwites the currently viewed virus with a virus saved to a txt file.
                        elseif key == "l" then
                            layoutfromfile(viewplayer, viewvirus, "pvirus.txt")
                            shipstitch(viewplayer, viewvirus)
                        -- TEST ONLY -- manually stimulates a heartbeat/impulse in all rooms of the current ship.
                        elseif key == "b" then
                            for statn = 1 , 8 do
                                -- This is done by inserting into the heartbeat overlay of all rooms a heartbeat of type 1 at place 0.
                                impulsetrigger(viewplayer, viewvirus, statn, {0, nil, nil, nil, nil})
                            end
                        
                        -- TEST ONLY -- switches the naming and current scheme to alternate versions.
                        elseif key == "c" then
                            colormode = 2
                            statmode = 2
                            -- and renames the current player/virus.
                            player[viewplayer][3] = "GregGreg"
                            player[viewplayer][1][viewvirus][3] = "Greg"
                        end

                        --IF SHIFT NOT HELD DOWN
                    else
                        -- if the key is a number corresponding to a virus held by the current player, then switch to its view/control.
                        for virusn = 1, table.getn(player[viewplayer][1]) do
                            if key == tostring(virusn) then
                                viewvirus = virusn
                            end
                        end
                        -- TEST ONLY -- decreases intelligence to a minimum of 1
                        if key == "g" then
                            if rep == false then
                                player[viewplayer][1][viewvirus][4] = math.max(player[viewplayer][1][viewvirus][4] -1, 1)
                                player[viewplayer][2] = statroominit(player[viewplayer][1])
                                shipstitch(viewplayer, viewvirus)
                            end
                        -- TEST ONLY -- decreases panelsize to a minimum of 3,2
                        elseif key == "p" then
                            if rep == false then
                                tilewidth = math.max(tilewidth -3, 3)
                                tileheight = math.max(tileheight - 2, 2)
                            end
                        
                        -- TEST ONLY -- removes the last player from the game, down to one player min.
                        elseif key == "h" then
                            if rep == false then
                                if table.getn(player) ~= 1 then
                                    table.remove(player)
                                end
                            end
                        -- TEST ONLY -- changes the colormode back to normal.
                        elseif key == "c" then
                            colormode = 1
                        -- TEST ONLY -- pauses and moves all heartbeats forwards by one.
                        elseif key == "r" then
                            loadrandomai(viewplayer, viewvirus, love.math.random(5), 1)
                        end
                    end
                elseif avatarstate[1] == "InCompany" then
                    local rows = player[avatarstate[2][1]][2][avatarstate[2][2]][1][avatarstate[2][3]][1]
                    if key == "right" then
                        avatarstate[2][5] = "right"
                        if not love.keyboard.isDown("lshift" or "rshift") then
                            if avatarstate[2][4]/rows ~= math.floor(avatarstate[2][4]/rows) then
                                if player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + 1] == 0 then
                                    if checkleftappropriatep(avatarstate[2][1], avatarstate[2][2], avatarstate[2][3], avatarstate[2][4] + 1) == true then
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] + 1
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar"}
                                    end
                                end
                            end
                        end
                    end

                    if key == "left" then
                        avatarstate[2][5] = "left"
                        if not love.keyboard.isDown("lshift" or "rshift") then
                            if (avatarstate[2][4] - 1)/rows ~= math.floor((avatarstate[2][4] - 1)/rows) then
                                if player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1] == 0 then
                                    if checkleftappropriatep(avatarstate[2][1], avatarstate[2][2], avatarstate[2][3], avatarstate[2][4] - 1) == true then
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] - 1
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar"}
                                    end
                                end
                            end
                        end
                    end
                    if key == "up" then
                        avatarstate[2][5] = "up"
                        if not love.keyboard.isDown("lshift" or "rshift") then
                            if avatarstate[2][4] > rows then
                                if player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - rows] == 0 then
                                    if checkleftappropriatep(avatarstate[2][1], avatarstate[2][2], avatarstate[2][3], avatarstate[2][4] - rows) == true then
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] - rows
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar"}
                                    end
                                end
                            end
                        end
                    end
                    if key == "down" then
                        avatarstate[2][5] = "down"
                        if not love.keyboard.isDown("lshift" or "rshift") then
                            if avatarstate[2][4] <= rows * (rows - 1) then
                                if player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + rows] == 0 then
                                    if checkleftappropriatep(avatarstate[2][1], avatarstate[2][2], avatarstate[2][3], avatarstate[2][4] + rows) == true then
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] + rows
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar"}
                                    end
                                end
                            end
                        end
                    end
                    if key == "return" then
                        if avatarstate[2][6] == nil then
                            avatarstate[2][6] = 0
                        end
                        if avatarstate[2][5] == "left" then
                            if (avatarstate[2][4] - 1)/rows ~= math.floor((avatarstate[2][4] - 1)/rows) then
                                if avatarstate[2][6] == 0 or checkpanelappropriate(avatarstate[2][1], avatarstate[2][2], avatarstate[2][6], avatarstate[2][3], avatarstate[2][4] - 1) == true then
                                    if type(player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1]) == "table" and player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1][1] == 5 then
                                        avatarstate[1] = "TabletView"
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] - 1
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar2"}
                                    else
                                        local tempvalue = player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1]
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1] = avatarstate[2][6]
                                        avatarstate[2][6] = tempvalue
                                    end
                                end
                            end
                        end
                        if avatarstate[2][5] == "up" then
                            if avatarstate[2][4] > rows then
                                if avatarstate[2][6] == 0 or checkpanelappropriate(avatarstate[2][1], avatarstate[2][2], avatarstate[2][6], avatarstate[2][3], avatarstate[2][4] - rows) == true then
                                    if type(player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - rows]) == "table" and player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - rows][1] == 5 then
                                        avatarstate[1] = "TabletView"
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] - rows
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar2"}
                                    else
                                        local tempvalue = player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - rows]
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - rows] = avatarstate[2][6]
                                        avatarstate[2][6] = tempvalue
                                    end
                                end
                            end
                        end
                        if avatarstate[2][5] == "down" then
                            if avatarstate[2][4] <= rows * (rows - 1) then
                                if avatarstate[2][6] == 0 or checkpanelappropriate(avatarstate[2][1], avatarstate[2][2], avatarstate[2][6], avatarstate[2][3], avatarstate[2][4] + rows) == true then
                                    if type(player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + rows]) == "table" and player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + rows][1] == 5 then
                                        avatarstate[1] = "TabletView"
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] + rows
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar2"}
                                    else
                                        local tempvalue = player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + rows]
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1] = avatarstate[2][6]
                                        avatarstate[2][6] = tempvalue
                                    end
                                end
                            end
                        end
                        if avatarstate[2][5] == "right" then
                            if avatarstate[2][4]/rows ~= math.floor(avatarstate[2][4]/rows) then
                                if avatarstate[2][6] == 0 or checkpanelappropriate(avatarstate[2][1], avatarstate[2][2], avatarstate[2][6], avatarstate[2][3], avatarstate[2][4] + 1) == true then
                                    if type(player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + 1]) == "table" and player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + 1][1] == 5 then
                                        avatarstate[1] = "TabletView"
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] + 1
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar2"}
                                    else
                                        local tempvalue = player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + 1]
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + 1] = avatarstate[2][6]
                                        avatarstate[2][6] = tempvalue
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- If in the battleroom
            if gamestate == 3 then
                if avatarstate[1] == "TabletView" then
                    local rows  = player[viewplayer][2][viewvirus][1][1][1]
                    -- TEST ONLY -- moves the currently selected virus on the battlegrid

                        if key == "q" then
                            player[viewplayer][2][viewvirus][3][9][2][2] = 2
                        end

                        if key == "e" then
                            player[viewplayer][2][viewvirus][3][9][2][2] = 1
                        end

                        local sanction = 0

                        if key == "up" then
                            player[viewplayer][2][viewvirus][3][9][2][1] = rows * 1
                            sanction = 1
                        end
                        if key == "right" then
                            player[viewplayer][2][viewvirus][3][9][2][1] = rows * 2
                            sanction = 1
                        end
                        if key == "down" then
                            player[viewplayer][2][viewvirus][3][9][2][1] = rows * 3
                            sanction = 1
                        end
                        if key == "left" then
                            player[viewplayer][2][viewvirus][3][9][2][1] = rows * 4
                            sanction = 1
                        end
                        if key == "w" then
                            player[viewplayer][2][viewvirus][3][9][2][1] = rows * 5
                            sanction = 1
                        end
                        if key == "s" then
                            player[viewplayer][2][viewvirus][3][9][2][1] = rows * 0
                            sanction = 1
                        end

                        if sanction == 1 then
                            if player[viewplayer][2][viewvirus][3][9][2][3][1] > 0 then
                                player[viewplayer][2][viewvirus][3][9][2][3][1] = player[viewplayer][2][viewvirus][3][9][2][3][1] - 1
                                impulsetrigger(viewplayer, viewvirus, 1, {player[viewplayer][2][viewvirus][3][9][2][1], nil, nil, nil, nil})
                                roomtrigger(viewplayer, viewvirus, 1)
                            end
                        end
                elseif avatarstate[1] == "InCompany" then --==TODO== clean this up
                    local rows = player[avatarstate[2][1]][2][avatarstate[2][2]][1][avatarstate[2][3]][1]
                    if key == "right" then
                        avatarstate[2][5] = "right"
                        if not love.keyboard.isDown("lshift" or "rshift") then
                            if avatarstate[2][4]/rows ~= math.floor(avatarstate[2][4]/rows) then
                                if player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + 1] == 0 then
                                    if checkleftappropriatep(avatarstate[2][1], avatarstate[2][2], avatarstate[2][3], avatarstate[2][4] + 1) == true then
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] + 1
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar"}
                                    end
                                end
                            end
                        end
                    end
                    if key == "left" then
                        avatarstate[2][5] = "left"
                        if not love.keyboard.isDown("lshift" or "rshift") then
                            if (avatarstate[2][4] - 1)/rows ~= math.floor((avatarstate[2][4] - 1)/rows) then
                                if player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1] == 0 then
                                    if checkleftappropriatep(avatarstate[2][1], avatarstate[2][2], avatarstate[2][3], avatarstate[2][4] - 1) == true then
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] - 1
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar"}
                                    end
                                end
                            end
                        end
                    end
                    if key == "up" then
                        avatarstate[2][5] = "up"
                        if not love.keyboard.isDown("lshift" or "rshift") then
                            if avatarstate[2][4] > rows then
                                if player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - rows] == 0 then
                                    if checkleftappropriatep(avatarstate[2][1], avatarstate[2][2], avatarstate[2][3], avatarstate[2][4] - rows) == true then
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] - rows
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar"}
                                    end
                                end
                            end
                        end
                    end
                    if key == "down" then
                        avatarstate[2][5] = "down"
                        if not love.keyboard.isDown("lshift" or "rshift") then
                            if avatarstate[2][4] <= rows * (rows - 1) then
                                if player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + rows] == 0 then
                                    if checkleftappropriatep(avatarstate[2][1], avatarstate[2][2], avatarstate[2][3], avatarstate[2][4] + rows) == true then
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                                        avatarstate[2][4] = avatarstate[2][4] + rows
                                        player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = {"avatar"}
                                    end
                                end
                            end
                        end
                    end
                    if key == "space" then
                        if avatarstate[2][4]/rows == rows then
                            player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4]] = 0
                            if avatarstate[2][3] == 8 then
                                injectavatar(1, 1, 1)
                            else
                                injectavatar(1, 1, avatarstate[2][3] + 1)
                            end
                        end
                    end
                    if key == "return" then
                        if avatarstate[2][6] == nil then
                            avatarstate[2][6] = 0
                        end
                        if avatarstate[2][5] == "left" then
                            if (avatarstate[2][4] - 1)/rows ~= math.floor((avatarstate[2][4] - 1)/rows) then
                                local tempvalue = player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1]
                                player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - 1] = avatarstate[2][6]
                                avatarstate[2][6] = tempvalue
                            end
                        end
                        if avatarstate[2][5] == "up" then
                            if avatarstate[2][4] > rows then
                                local tempvalue = player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - rows]
                                player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] - rows] = avatarstate[2][6]
                                avatarstate[2][6] = tempvalue
                            end
                        end
                        if avatarstate[2][5] == "down" then
                            if avatarstate[2][4] <= rows * (rows - 1) then
                                local tempvalue = player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + rows]
                                player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + rows] = avatarstate[2][6]
                                avatarstate[2][6] = tempvalue
                            end
                        end
                        if avatarstate[2][5] == "right" then
                            if avatarstate[2][4]/rows ~= math.floor(avatarstate[2][4]/rows) then
                                local tempvalue = player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + 1]
                                player[avatarstate[2][1]][2][avatarstate[2][2]][2][avatarstate[2][3]][avatarstate[2][4] + 1] = avatarstate[2][6]
                                avatarstate[2][6] = tempvalue
                            end
                        end
                    end
                    --
                    -- Change players and virus ==TODO== why does changing to a player without a virus for the chosen virus give an error?
                    if love.keyboard.isDown("lshift" or "rshift") then
                        for playern = 1, table.getn(player) do
                            if key == tostring(playern) then
                                if viewvirus > table.getn(player[playern]) then
                                    viewvirus = 1
                                end
                                viewplayer = playern
                            end
                        end
                    else
                        for virusn = 1, table.getn(player[viewplayer][1]) do
                            if key == tostring(virusn) then
                                viewvirus = virusn
                            end
                        end
                    end
                end
            end
        else
            if key ~= "escape" then
                entry = entry..key
            end
        end
    end
--

--CREATED FUNCTIONS -- FUNCTIONS ONLY CALLED WITHIN OTHER FUNCTIONS

--LOAD AND SAVE from txt files
    function writeall(tablew, floc)
        local filename = (flocation..floc..".txt")
        filer = io.open(filename, "w")
        filer:close()
        local filename = (flocation..floc..".txt")
        filer = io.open(filename, "a")
        writeit(tablew)
        filer:close()
    end

    function savestarter(playern, virusn, floc)
        writeall(player[playern][1][virusn], floc.."1")
        writeall(player[playern][1][virusn], floc.."2")
        writeall(player[playern][1][virusn], floc.."3")
        writeall(avatarstate, floc.."a")
    end

    function savevirus(playern, virusn, floc)
        writeall(player[playern][1][virusn], player[playern][1][virusn][3].."\\"..player[playern][1][virusn][2].."\\"..floc.."1")
        writeall(player[playern][2][virusn], player[playern][1][virusn][3].."\\"..player[playern][1][virusn][2].."\\"..floc.."2")
        writeall(player[playern][4][virusn], player[playern][1][virusn][3].."\\"..player[playern][1][virusn][2].."\\"..floc.."3")
    end

    function savegame(floc)
        writeall(player, floc)
        writeall(avatarstate, floc.."a")
    end

    function loadvirus(playern, virusn, floc)
        player[playern][1][virusn] = readall(floc.."1")
        player[playern][2][virusn] = readall(floc.."2")
        player[playern][4][virusn] = readall(floc.."3")
    end

    function loadgame(floc)
        player = readall(floc)
        avatarstate = readall(floc.."a")
    end
    
    function writeit(tablew)
        if type(tablew) == "table" then
            filer:write("&")
            for i = 1, table.getn(tablew) do
                writeit(tablew[i])
            end
            filer:write(">")
        elseif tablew == nil then
            filer:write("@")
        elseif type(tablew) == "number" then
            filer:write("^"..string.len(tostring(tablew))..tablew)
        elseif type(tablew) == "string" then
            filer:write("%"..string.len(string.len(tablew))..string.len(tablew)..tablew)
        elseif type(tablew) == "boolean" then
            filer:write("*"..string.len(tostring(tablew))..tablew)
        else
            filer:write("$")
        end
        
    end

    function readall(floc)
        local checkkk = ("C:\\Users\\Dan\\Desktop\\Viraltrial\\check.txt")
        filec = io.open(checkkk, "w")
        filec = io.open(checkkk, "a")
        local filename = (flocation..floc..".txt")
        filec:write(filename.."\n\n")
        filer = io.open(filename, "r")
        reader = 0
        strike = 0
        positions = {}
        local tabler = {}
        tabler = readit(tabler)
        tabler = tabler[1]
        filer:close()
        filec:close()
        return tabler
    end

    function readit(tabler)
        local esc = 0
        local entries = 0
        while esc == 0 do
            reader = reader + 1
            char = filer:read(1)
            if char == nil then
                break
            end
            filec:write("                          AT POSITION "..reader.."LOOKING AT"..char.."\n")
            

            if char == "&" then
                
                table.insert(tabler, {})
                entries = entries + 1
                table.insert(positions, entries)
                filec:write("FOUND A TABLE AT POSITION "..reader.."\n")
                filec:write("                                                                THIS IS NOW  ")
                for i = 1, table.getn(positions) do
                    filec:write("["..positions[i].."]")
                end
                filec:write("\n")
                readit(tabler[table.getn(tabler)])
            elseif char == "^" then
                entries = entries + 1
                
                filec:write("FOUND A NUMBER AT POSITION "..reader.."\n")
                reader = reader + 1
                char = filer:read(1)
                
                filec:write("THE NUMBER IS OF SIZE"..tonumber(char).."\n")
                reader = reader + tonumber(char)
                char = filer:read(tonumber(char))
                
                filec:write("THE NUMBER IS"..tonumber(char).."\n")
                table.insert(tabler, tonumber(char))
                filec:write("                                                                THIS IS NOW  ")
                for i = 1, table.getn(positions) do
                    filec:write("["..positions[i].."]")
                end
                filec:write(entries)
                filec:write("\n")

            elseif char == "%" then
                entries = entries + 1
                
                filec:write("FOUND A STRING AT POSITION "..reader.."\n")
                reader = reader + 1
                char = filer:read(1)
                reader = reader + tonumber(char)
                filec:write("THE STRING SIZE IS OF SIZE"..tonumber(char).."\n")
                char = filer:read(tonumber(char))
                reader = reader + tonumber(char)
                filec:write("THE STRING IS OF SIZE"..tonumber(char).."\n")
                char = filer:read(tonumber(char))
                
                filec:write("THE STRING IS"..tostring(char).."\n")
                table.insert(tabler, char)
                filec:write("                                                                THIS IS NOW  ")
                for i = 1, table.getn(positions) do
                    filec:write("["..positions[i].."]")
                end
                filec:write(entries)
                filec:write("\n")

            elseif char == "*" then
                entries = entries + 1
                
                filec:write("FOUND A BOOL AT POSITION "..reader.."\n")
                reader = reader + 1
                char = filer:read(1)
                
                filec:write("THE BOOL IS OF SIZE"..tonumber(char).."\n")
                reader = reader + tonumber(char)
                char = filer:read(tonumber(char))
                
                filec:write("THE BOOL IS"..tonumber(char).."\n")
                table.insert(tabler, toboolean(char))
                filec:write("                                                                THIS IS NOW  ")
                for i = 1, table.getn(positions) do
                    filec:write("["..positions[i].."]")
                end
                filec:write(entries)
                filec:write("\n")

            elseif char == "@" then
                char = nil
                table.insert(tabler, char)

            elseif char ~= ">" then
                filec:write("weird FOUND"..tostring(char).." AT POSITION "..reader.."\n")
                char = filer:read(1)
                reader = reader + 1
            
            
            else
                esc = 1
                filec:write("READY TO LEAVE"..reader.."\n")
                table.remove(positions, table.getn(positions))
            end
        end
        filec:write("                                                                ENDING: NOW  ")
        for i = 1, table.getn(positions) do
            filec:write("["..positions[i].."]")
        end
        filec:write("\n")
        return tabler
    end

    function loadrandomai(playern, virusn, level, virusid)
        local virtype = dbvirus[virusid][2]
        local ai = dbvirus[virusid][4][level][3][love.math.random(table.getn(dbvirus[virusid][4][level][3]))]
        loadvirus(playern, virusn, virtype.."\\"..tostring(level).."\\"..ai)
        return ai
    end

    function loadstartingai(playern, virusn, level, virusid)

        loadgame(playern, virusn, "houndmicrostart")
    end
--


--Load parts of the game
    function grabstats(id, lvl)
        --Will return a bunch of stats for a given virus id and level.
        --When queried it calls the getstat functions on every relevant stat of a virus on the db and returns it as a list.
        local virname = virnameget(id)
        local intelligence = statintget(id, lvl)
        local speed = statspeget(id, lvl)
        local strength = statstrget(id, lvl)
        local toughness = stattouget(id, lvl)
        local technique = stattecget(id, lvl)
        local fortitude = statforget(id, lvl)
        local cunning = statcunget(id, lvl)
        local will = statwilget(id, lvl)
        local progno = statprognumget(id, lvl)
        -- HP is set as equal to toughness * 100 + fortitude + 100
        local maxhp = (toughness + fortitude) * 100
        local currenthp = maxhp
        local virusstats = {id, lvl, virname, intelligence, speed, strength, toughness, technique, fortitude, cunning, will, maxhp, currenthp, progno}
        return virusstats
    end

    function amendvirusimpstart()
        for playern = 1, table.getn(player) do
            for virusn = 1, table.getn(player[playern][2]) do
                player[playern][2][virusn][3][9] = {}
                for i = 1, 8 do
                    player[playern][2][virusn][3][9][i] = {}
                    player[playern][2][virusn][3][9][i][1] = 0
                    player[playern][2][virusn][3][9][i][2] = 1
                    player[playern][2][virusn][3][9][i][3] = {}
                    player[playern][2][virusn][3][9][i][3][1] = 0
                    player[playern][2][virusn][3][9][i][3][2] = 5
                end
            end
        end
    end

    function getdefaultprogs(startwith)
        --Gets all of the progs that the virus has learned up to this level.
        --these initialise global values for the buttons to be displayed.
        grabbedvalue = {}
        highlightprogs = {}
        --for each player
        for playern = 1, table.getn(player) do
            --for each virus
            for virusn = 1, table.getn(player[playern][1]) do
                --if that player has no programmes loaded (it is newly loaded in the system at a certain level)
                if player[playern][1][virusn][15] == nil then
                    local virid = player[playern][1][virusn][1]
                    --eliminate the list of viruses that they know ==TODO== make a seperate function for levelups.
                    player[playern][1][virusn][15] = { {}, {}, {}, {}, {}, {}, {}, {}, {} }
                    --for each level that virus has
                    if startwith == true then
                        for k = 1, player[playern][1][virusn][2] do
                            --for each programme hardcoded to be learned that level
                            for l = 1, table.getn(dbvirus[virid][4][k][2]) do
                                for m = 1, table.getn(dbprog[dbvirus[virid][4][k][2][l][1]][dbvirus[virid][4][k][2][l][2]][dbvirus[virid][4][k][2][l][3]][2]) do
                                    local progroomtofit = dbprog[dbvirus[virid][4][k][2][l][1]][dbvirus[virid][4][k][2][l][2]][dbvirus[virid][4][k][2][l][3]][2][m]
                                    --insert that programme into the list of that viruses known programmes
                                    table.insert(player[playern][1][virusn][15][progroomtofit], dbvirus[virid][4][k][2][l])
                                    --put an off switch for button highlight
                                    table.insert(highlightprogs, 0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    function battlegridvirusload()
        --Loads the battlegrid being initialised with starting viruses for each player.
        --For each player allowed on the map.
        for i = 1, table.getn(battlegrid[activegrid][2]) do
            --if there aren't enough players then remove that placement
            if i > table.getn(player) then
                battlegrid[activegrid][2][i] = {}
            else
                --For each virus allowed for that player
                for j = 1, table.getn(battlegrid[activegrid][2][i]) do
                    --If they don't have enough viruses remove that starting point.
                    if j > table.getn(player[i][1]) then
                        table.remove(battlegrid[activegrid][2][i], table.getn(battlegrid[activegrid][2][i]))
                    end
                end
            end
        end
        --Place the viruses in their starting places.
        for i = 1, table.getn(battlegrid[activegrid][2]) do
            for j = 1, table.getn(battlegrid[activegrid][2][i]) do
                battlegrid[activegrid][1][battlegrid[activegrid][2][i][j][2]][battlegrid[activegrid][2][i][j][1]] = {i,j}
            end
        end
    end

    function overwritestats(virusid, level, statn)
        if statn == "all" then
            for stat = 1, 8 do
                dbvirus[virusid][4][level][1][stat] = math.ceil(dbprogstats[virusid][stat] * (level / 100))
            end
        else
            dbvirus[virusid][4][level][1][statn] = math.ceil(dbprogstats[virusid][statn] * (level / 100))
        end
    end
    
    function overwriteallvirusid()
        for id = 1, 3 do--table.getn(dbprog) do
            for level = 1, table.getn(dbvirus[id][4]) do
                overwritestats(id, level, "all")
            end
        end
    end

    -- STATGET FUNCTIONS
        --A bunch of functions that can fetch specific stats from a virus id and level.
        function virnameget(id)
            local virname = dbvirus[id][2]
            return virname
        end
        function statintget(id, lvl)
            local int = dbvirus[id][4][lvl][1][1]
            return int
        end
        function statspeget(id, lvl)
            local int = dbvirus[id][4][lvl][1][2]
            return int
        end
        function statstrget(id, lvl)
            local int = dbvirus[id][4][lvl][1][3]
            return int
        end
        function stattouget(id, lvl)
            local int = dbvirus[id][4][lvl][1][4]
            return int
        end
        function stattecget(id, lvl)
            local int = dbvirus[id][4][lvl][1][5]
            return int
        end
        function statforget(id, lvl)
            local int = dbvirus[id][4][lvl][1][6]
            return int
        end
        function statcunget(id, lvl)
            local int = dbvirus[id][4][lvl][1][7]
            return int
        end
        function statwilget(id, lvl)
            local int = dbvirus[id][4][lvl][1][8]
            return int
        end
        function statprognumget(id, lvl)
            local int = table.getn(dbvirus[id][4][lvl][2])
            return int
        end
    --

    function windowset(WIDTH, HEIGHT, FULLSCREEN, VSYNC, RESIZE)
        -- sets the screen details, takes a width, height in pixels and sets some settings.
        love.window.setMode(WIDTH, HEIGHT, {
            fullscreen = FULLSCREEN,
            vsync = VSYNC,
            resizable = RESIZE
        })
    end

    function insertstats(playerr)
        -- for a given player, grabs the stats for that persons first virus, repeat for all viruses, then assign them to that person.
        local pviruses = {}
        
        for playern = 2, table.getn(playerr) do
            local insertvstats = grabstats(playerr[playern][1], playerr[playern][2])
            table.insert(pviruses, insertvstats)
        end
        return pviruses
    end

    function insertplayer(playeradd)
        --Adds a new player to the player table.
        --Makes an empty table.
        local playern = {}
        --Add a stat table
        table.insert(playern, insertstats(playeradd))
        --Create rooms from those stats and add them.
        table.insert(playern, statroominit(playern[1]))
        --Add a name
        playern[3] = playeradd[1]
        playern[4] = {}
        local virusntotal = table.getn(playern[1])
        playern[5] = {}
        for i = 1, virusntotal do
            table.insert(playern[5], {})
        end
        playern[6] = {}
        for i = 1, virusntotal do
            table.insert(playern[6], { {0.25, 0.25}, {0.25, 0.25}, {1, 1}, {1, 1}, {1, 1}, {1, 1}, {1, 1}, {1, 1} })
        end
        --Add all this to the list of current players
        table.insert(player, playern)
    end

    function statroominit(playert)
        -- for a given player, for each virus that player has, for each stat of that virus, create a list representing that statroom and return it.
        -- ==TODO== standardise this so it just takes in a player number, same with the earlier virus thing.
        --empty tables to build in
        local proomlayoutallvirus = {}
        local proomlayoutsinglevirus = {}
        local prox = {}
        local statroom = {}
        --for each virus of the player.
        for playern = 1, table.getn(playert) do
            prox = {}
            -- Create 4 empty rooms for the stat to store panels/programmes/heartbeats/temporary stuff.
            for kl = 1, 4 do
                proomlayoutsinglevirus = {}
                --For each stat
                for statn = 1,8 do
                    statroom = createstatroom(playert[playern], (statn + 3))
                    --Nest the tables in the correct order.
                    table.insert(proomlayoutsinglevirus, statroom[kl])
                end
                table.insert(prox, proomlayoutsinglevirus)
            end
            table.insert(proomlayoutallvirus, prox)
        end
        return proomlayoutallvirus
    end

    function createstatroom(virus, statid)
        -- Creates a list when asked to produce one. List represents a room with a number of tiles equal to the stat, walls of the upper edge of the square root of the stat, missing tiles in bottom right corner.
        --==TODO== standardise this also.
        local stat = virus[statid]
        --Find the dimensions of the room
        local rows = math.ceil(math.sqrt(stat))
        --Find the number of empty panels that will remain.
        local remove = rows*rows - stat
        --Set up proggrid which will contain values for different layers of the room.
        --[[
            1, dimensions followed by tile layout.
            2, programmes - currently empty,
            3, impulses ==TODO== is this unused?
            4, temporary things, currently empty
        ]]
        local proggrid = {
            {},
            {},
            {},
            {}
        }
        table.insert(proggrid[1],rows)
        table.insert(proggrid[3],{})
        
        --for each column
        for i = 1, rows do
            --for each row
            for j = 1, rows do
                -- if in the room then mark the tile with 1 if its 'in', and 0 if its 'out'
                if (i < (rows + 0.5 - remove / 2) or j < (rows - remove /2)) or (j ~= rows and i ~= rows) then
                    table.insert(proggrid[1], 1)
                else
                    table.insert(proggrid[1], 0)
                end
                -- also fill the empty impulse room.
                table.insert(proggrid[3], 0)
                table.insert(proggrid[2], 0)
            end
        end
        return proggrid
    end
--


--Draw related functions
    function hpdraw(playern, virusn, x, y, width, height)
        statcolor(9, 0.7)
        love.graphics.rectangle("line", x - (width/2), y, width, height)
        local hpmax = player[playern][1][virusn][12]
        local currenthp = player[playern][1][virusn][13]
        local hplevel = math.floor(height * currenthp/hpmax)
        local gap = 3
        love.graphics.rectangle("fill", x + gap - (width/2), y + (height - hplevel) + gap, width - gap*2, hplevel - gap*2)
        love.graphics.printf(currenthp, x + gap - (width/2), y + (height - hplevel) + gap - 20, width - gap*2,"center")
        statcolor(9, 0)
        love.graphics.printf(hpmax, x + gap - (width/2), y + height - 20, width - gap*2,"center")
    end

    function pausedraw()
        statcolor(9, 0.4)
        love.graphics.rectangle("fill", WINDOW_WIDTH / 4, WINDOW_HEIGHT / 4, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
        statcolor(9, 0.1)
        love.graphics.printf(entry, WINDOW_WIDTH / 2 - 200, WINDOW_HEIGHT / 2 - 6, 400, "center")
    end

    function playerdraw(playern, x, side)
        --Draws a list of stats on the screen.
        -- playern is the player to draw, x is the offset, side draws to either side of the title and accepts "left" or "right"
        -- i is the y position, j is the amount to incrememnt y by, offset moves the secondary text
        local offset = 0
        if side == "left" then
            offset = 5
        end
        if side == "right" then
            offset = -105
        end
        local i = 100
        local j = 25
        --THIS PART IS WEIRD BECAUSE ITS FORMATTING THE PLAYERS
        -- Draw the name of the player
        if player[playern][1] ~= "none" then
            statcolor(playern, 1.8)
            love.graphics.printf(player[playern][1], x, i, 100,"center")
            i = i + j
        end
        
        --For each virus draws the name and level of the virus, higher levels are drawn brighter.
        for k = 2, table.getn(player[playern]) do
            if player[playern][2] ~= nil then
                statcolor(playern, 1 + player[playern][k][2]/10)
                love.graphics.printf(
                    "virus: "..dbvirus[player[playern][k][1]][2]..
                    " level "..player[playern][k][2], x + offset, i, 200,"center")
                i = i + j
            end
        end
    end
    
    function statdraw(virus, x, name)
        --Draws the stats of the current virus to the screen, virus is the table to draw, x is the offset, name is the player name.
        -- i is the y position, j is the amount to incrememnt y by, h is a counter used to read stats.
        local i = 10
        local j = 20
        local h = 0
        -- Draw the headers of the virus
        love.graphics.printf(name, x, i, 200,"center")
        i = i + j
        h = h + 1
        love.graphics.printf("ID: "..virus[h], x, i, 200,"center")
        i = i + j
        h = h + 1
        love.graphics.printf("level: "..virus[h], x, i, 200,"center")
        i = i + j
        h = h + 1
        love.graphics.printf(virus[h], x, i, 200,"center")
        i = i + j
        h = h + 1
        --draw the stats in statcolor
        for p = 1, 8 do
            statcolor(p, 2)
            love.graphics.printf(statnames[statmode][p]..": "..virus[h], x, i, 200,"center")
            i = i + 20
            h = h + 1
        end
        --reset the color and draw the hp and programmes learnt this level.
        statcolor(9, 1)
        love.graphics.printf("HP: "..virus[h+1].."/"..virus[h], x, i, 200,"center")
        i = i + 40
        h = h + 2
        love.graphics.printf("Programmes:", x, i, 200,"center")
        local progno = virus[h]
        for inc = 1, progno do
            i = i + 20
            love.graphics.printf(
                dbprog[dbvirus[virus[1]][4][virus[2]][2][inc][1]][dbvirus[virus[1]][4][virus[2]][2][inc][2]][dbvirus[virus[1]][4][virus[2]][2][inc][3]][1][1]
                , x + 15, i, 200)
        end
    end

    function turndraw()
        statcolor(9, 0.8)
        love.graphics.printf("TURN: "..tostring(turn[1]), WINDOW_WIDTH/2 - 100, 1, 200, "center")
        for i = 1, table.getn(turn[2]) do
            statcolor(9, 0.8)
            love.graphics.rectangle("line", WINDOW_WIDTH/2 - 150, i * 21, 300, 20)
            love.graphics.rectangle("fill", WINDOW_WIDTH/2 - 150, i * 21, turn[3], 20)
            statcolor(i, 1.0)
            for j = 1, table.getn(turn[2][i][1]) do
                love.graphics.rectangle("fill", WINDOW_WIDTH/2 -149 + turn[2][i][1][j], i * 21, 3, 20)
            end
        end
    end

    function drawprogs()
        local progs = table.getn(player[viewplayer][1][viewvirus][15][button[2][2][10]])
        local width = 50
        local height = 50
        local gap = 6
        local style = "line"
        for i = 1, progs do
            if highlightprogs[i] == 1 then
                style = "fill"
            end
            love.graphics.rectangle(style, WINDOW_WIDTH/2 - width/2 - ((width/2 + gap/2) * (progs-1)) + (width + gap) * (i - 1), WINDOW_HEIGHT - height - gap, width, height)
            if highlightprogs[i] == 1 then
                style = "line"
                statcolor(9, 0.1)
            end
            love.graphics.printf(dbprog[player[viewplayer][1][viewvirus][15][button[2][2][10]][i][1]][player[viewplayer][1][viewvirus][15][button[2][2][10]][i][2]][player[viewplayer][1][viewvirus][15][button[2][2][10]][i][3]][1][1], WINDOW_WIDTH/2 - width/2 - ((width/2 + gap/2) * (progs-1)) + (width + gap) * (i - 1), WINDOW_HEIGHT - gap - height/2 - 10 , width, "center")
            if highlightprogs[i] == 1 then
                statcolor(9, 1.0)
            end
            if highlightprogs[i] == 1 then
                love.graphics.rectangle("line", WINDOW_WIDTH/2 - 200, (WINDOW_HEIGHT - height * 2) - (gap * 2), 400, height)
                love.graphics.printf(dbprog[player[viewplayer][1][viewvirus][15][button[2][2][10]][i][1]][player[viewplayer][1][viewvirus][15][button[2][2][10]][i][2]][player[viewplayer][1][viewvirus][15][button[2][2][10]][i][3]][1][2], WINDOW_WIDTH/2 - 200, (WINDOW_HEIGHT - height * 2) - (gap * 2), 400, "center")
            end
        end
    end
    
    function buttondraw()
        --Draws each relevant button from the button table.
        --For each button of the current gamestate
        for i = 1, table.getn(button[gamestate]) do
            --if the button is set to 'visible'
            if button[gamestate][i][9] == 1 then
                --grab the colour of the button and the intensity
                statcolor(button[gamestate][i][5], button[gamestate][i][6])
                --draw the button
                love.graphics.rectangle("line", button[gamestate][i][1], button[gamestate][i][2], button[gamestate][i][3], button[gamestate][i][4])
                if button[gamestate][i][8] ~= "none" then
                    --Print any text stored in the button in the center.
                    love.graphics.printf(button[gamestate][i][8], button[gamestate][i][1], button[gamestate][i][2] + button[gamestate][i][4]/4 - 8, button[gamestate][i][3], "center")
                end
            end
        end
    end

    function OpGridDraw(playern, virusn, offsetx, offsety, mode)
        -- offsetx,offsety is from the centre, reversed is 1,2,3,4 style of order, stat is 1..8.
        -- Draws the grid of a room to the screen.
        --sets the variables to draw the room.
        local incx = 1
        local incy = 1

        if mode == 1 then
            offsetx = offsetx - player[playern][2][virusn][1][1][1] / 2
        end
        --sets the counter to increment in different directions depending on reversed style. ==TODO= also make sure that reversed rooms still end up centred in the same place somehow. Or dump them.
       
        
        -- For each panel in the room decide how to draw it.
        local i = 0
        local j = 0
        
        --==TODO== only do this when it actually needs to be updated....
        gridclickbuttoncreate = {}
                
        for c = 2, table.getn(player[playern][2][virusn][1][1]) do
            -- If it is blank 
            table.insert(gridclickbuttoncreate, {tilewidth, tileheight, offsetx, offsety, i, j, gap})
            if player[playern][2][virusn][1][1][c] == 1 then
                statcolor(1, 1.5)
                paneldraw("line", tilewidth, tileheight, offsetx, offsety, i, j, gap)
            end
            -- If it is empty
            if player[playern][2][virusn][1][1][c] == 0 then
                statcolor(1, 0.2)
                paneldraw("fill", tilewidth, tileheight, offsetx, offsety, i, j, gap)
            end
            --If it has a heartbeat above it.
            for impn = 1, table.getn(player[playern][2][virusn][3][1][1]) do
                if player[playern][2][virusn][3][1][1][impn][1] == c - 1 then
                    statcolor(1, 1)
                    paneldraw("fill", tilewidth, tileheight, offsetx, offsety, i, j, gap)
                end
            end
            --If it has a programme installed.
            if player[playern][2][virusn][2][1][c - 1] ~= 0 then
                if type(player[playern][2][virusn][2][1][c - 1][1]) == "string" then
                    if player[playern][2][virusn][2][1][c - 1][1] == "avatar" then
                        statcolor(9, 1)
                        paneldraw3("line", tilewidth, tileheight, offsetx, offsety, i, j, gap, 0.3, 1)
                    end
                    if player[playern][2][virusn][2][1][c - 1][1] == "avatar2" then
                        statcolor(5, 1)
                        paneldraw3("fill", tilewidth, tileheight, offsetx, offsety, i, j, gap, 0.3, 1)
                    end
                else
                    local intensity = 1
                    if player[playern][2][virusn][2][1][c - 1][5] == "d" then
                        intensity = 0.5
                    end
                    local progwidth = dbprog[player[playern][2][virusn][2][1][c - 1][1]][player[playern][2][virusn][2][1][c - 1][2]][player[playern][2][virusn][2][1][c - 1][3]][6]
                    statcolor(player[playern][2][virusn][2][1][c - 1][1], 2)
                    paneldraw2("fill", tilewidth, tileheight, offsetx, offsety, i, j, gap, 0.7 * intensity, progwidth)
                    statcolor(player[playern][2][virusn][2][1][c - 1][2], 2)
                    paneldraw2("fill", tilewidth, tileheight, offsetx, offsety, i, j, gap, 0.5 * intensity, progwidth)
                    statcolor(player[playern][2][virusn][2][1][c - 1][3], 2)
                    paneldraw2("fill", tilewidth, tileheight, offsetx, offsety, i, j, gap, 0.2 * intensity, progwidth)
                end
            end
            -- If you haven't reached the end of the row then increment x, otherwise reset x and increment y.
            if i * incx < player[playern][4][virusn][table.getn(player[playern][4][virusn])][1] - 1 then
                i = i + incx
            else
                i = 0
                j = j + incy
            end
        end
        --then reset the colour to white.
        love.graphics.setColor(255/255,255/255,255/255)
    end

    function centerprint(string)
        -- prints something centered at the top of the page
        love.graphics.printf(string, WINDOW_WIDTH/2 - 400, 5, 200,"center")
    end

    function battlegriddraw()
        --Draw the currently selected battlegrid with players.
        --For each panel, row by row.
        for i = 1, table.getn(battlegrid[activegrid][1][1]) do
            for j = 1, table.getn(battlegrid[activegrid][1]) do
                -- If the tile is blank then draw it.
                if battlegrid[activegrid][1][j][i] == 1 then
                    statcolor(9, 0.5)
                    paneldraw('fill', tilewidth, tileheight, -table.getn(battlegrid[activegrid][1])/2, -table.getn(battlegrid[activegrid][1]) + 3, i, j, 2)
                end
                -- For each player on the grid.
                for k = 1, table.getn(battlegrid[activegrid][2]) do
                    for l = 1, table.getn(battlegrid[activegrid][2][k]) do
                        --Draw a filled panel occuring to the player at the coordinates.
                        statcolor(k, 1.0)
                        paneldraw('fill', tilewidth, tileheight, -table.getn(battlegrid[activegrid][1][1])/2, -table.getn(battlegrid[activegrid][1]) + 3, battlegrid[activegrid][2][k][l][1], battlegrid[activegrid][2][k][l][2], 2)
                        statcolor(9, 0.5)
                        paneldraw('line', tilewidth, tileheight, -table.getn(battlegrid[activegrid][1][1])/2, -table.getn(battlegrid[activegrid][1]) + 3, battlegrid[activegrid][2][k][l][1], battlegrid[activegrid][2][k][l][2], 2)
                        statcolor(9, 0.01)
                        facingdraw('fill', tilewidth, tileheight, -table.getn(battlegrid[activegrid][1][1])/2, -table.getn(battlegrid[activegrid][1]) + 3, battlegrid[activegrid][2][k][l][1], battlegrid[activegrid][2][k][l][2], 2,  battlegrid[activegrid][2][k][l][3])
                        
                    end
                end
            end
        end
    end

    function statcolor(stat, offset)
        -- Sets the colour to write in as equal to the statcolours list. stat = 1,8 stats. offset multiplies how bright it is.
        love.graphics.setColor((statcolors[colormode][stat][1] * offset)/255,(statcolors[colormode][stat][2] * offset)/255,(statcolors[colormode][stat][3] * offset)/255)
    end

    function paneldraw(style, tilewidth, tileheight, offsetx, offsety, j, i, gap)
        --Draws panel
        love.graphics.rectangle(
            -- style takes "fill"/"line"/or...
            style,
            --the centre of the screen, x 
            WINDOW_WIDTH / 2 - tilewidth / 2
                --the offset centred point
                + (offsetx * (tilewidth + gap))
                    -- the position relative to the centred position.
                    + (tilewidth + gap) * j,
            WINDOW_HEIGHT / 2 - tileheight / 2
                + (offsety * (tileheight + gap))
                    + (tileheight + gap) * i,
            --dimensions of the panel        
            tilewidth,
            tileheight
        )
    end

    function paneldraw3(style, tilewidth, tileheight, offsetx, offsety, j, i, gap, size, progwidth)
        love.graphics.circle( style, 
        WINDOW_WIDTH / 2 - tilewidth / 2
        --the offset centred point
        + (offsetx * (tilewidth + gap))
        -- the position relative to the centred position.
        + (tilewidth + gap) * j
        --offset to account for size
        + (1 - size)/2 * tilewidth
        + 0.5 * (tilewidth * size + (progwidth - 1) * tilewidth), 
        
        WINDOW_HEIGHT / 2 - tileheight / 2
        + (offsety * (tileheight + gap))
        + (tileheight + gap) * i
        + (1 - size)/2 * tileheight + 0.5 *(tileheight * size),
        
        tileheight * size )
    end
    
    function paneldraw2(style, tilewidth, tileheight, offsetx, offsety, j, i, gap, size, progwidth)
        --Draws panel
        
        love.graphics.rectangle(
            -- style takes "fill"/"line"/or...
            style,
            --the centre of the screen, x 
            WINDOW_WIDTH / 2 - tilewidth / 2
                --the offset centred point
                + (offsetx * (tilewidth + gap))
                    -- the position relative to the centred position.
                    + (tilewidth + gap) * j
                    --offset to account for size
                    + (1 - size)/2 * tilewidth
                    ,
            WINDOW_HEIGHT / 2 - tileheight / 2
                + (offsety * (tileheight + gap))
                    + (tileheight + gap) * i
                    
                    + (1 - size)/2 * tileheight,
            --dimensions of the panel        
            tilewidth * size + (progwidth - 1) * tilewidth,
            tileheight * size
        )
    end
    
    function facingdraw(style, tilewidth, tileheight, offsetx, offsety, j, i, gap, facing)
        --Draws panel
        if facing == "l" then
            love.graphics.rectangle(
                -- style takes "fill"/"line"/or...
                style,
                --the centre of the screen, x 
                (WINDOW_WIDTH / 2 - tilewidth / 2
                    --the offset centred point
                    + (offsetx * (tilewidth + gap))
                        -- the position relative to the centred position.
                        + (tilewidth + gap) * j)
                        
                            - tilewidth / 20,
                (WINDOW_HEIGHT / 2 - tileheight / 2
                    + (offsety * (tileheight + gap))
                        + (tileheight + gap) * i)
                            
                            + (tileheight / 4),
                --dimensions of the panel        
                tilewidth / 10,
                tileheight / 2
            )
        end
        if facing == "r" then
            love.graphics.rectangle(
                -- style takes "fill"/"line"/or...
                style,
                --the centre of the screen, x 
                (WINDOW_WIDTH / 2 - tilewidth / 2
                    --the offset centred point
                    + (offsetx * (tilewidth + gap))
                        -- the position relative to the centred position.
                        + (tilewidth + gap) * j)
                        
                            - tilewidth / 20 + tilewidth,
                (WINDOW_HEIGHT / 2 - tileheight / 2
                    + (offsety * (tileheight + gap))
                        + (tileheight + gap) * i)
                            
                            + (tileheight / 4),
                --dimensions of the panel        
                tilewidth / 10,
                tileheight / 2
            )
        end
        if facing == "u" then
            love.graphics.rectangle(
                -- style takes "fill"/"line"/or...
                style,
                --the centre of the screen, x 
                (WINDOW_WIDTH / 2 - tilewidth / 2
                    --the offset centred point
                    + (offsetx * (tilewidth + gap))
                        -- the position relative to the centred position.
                        + (tilewidth + gap) * j)
                        
                            + tilewidth / 4,
                (WINDOW_HEIGHT / 2 - tileheight / 2
                    + (offsety * (tileheight + gap))
                        + (tileheight + gap) * i)
                            
                            - (tileheight / 20),
                --dimensions of the panel        
                tilewidth / 2,
                tileheight / 10
            )
        end
        if facing == "d" then
            love.graphics.rectangle(
                -- style takes "fill"/"line"/or...
                style,
                --the centre of the screen, x 
                (WINDOW_WIDTH / 2 - tilewidth / 2
                    --the offset centred point
                    + (offsetx * (tilewidth + gap))
                        -- the position relative to the centred position.
                        + (tilewidth + gap) * j)
                        
                            + tilewidth / 4,
                (WINDOW_HEIGHT / 2 - tileheight / 2
                    + (offsety * (tileheight + gap))
                        + (tileheight + gap) * i)
                            
                            - (tileheight / 20) + tileheight,
                --dimensions of the panel        
                tilewidth / 2,
                tileheight / 10
            )
        end
    end

    function gamestartdraw()
     --==TODO==
    end

    --ShipStitch
    function shipstitch(playern, virusn)
        --takes the view player's viewvirus and stitches the rooms together for viewing.
        local statsize = {}
        local stat = 0
        --For each stat store the width in a table. ==TODO== just grab these directly from the player table?
        for statn = 1, 8 do
            stat = player[playern][2][virusn][1][statn][1]
            table.insert(statsize, stat)
        end
        -- change these into a series of coordinates so that the rooms of the ship are in the right place.
        
        local x1 = -(statsize[1] + 1)
        local y1 = -math.floor(statsize[1]/2) -1

        local x2 = -statsize[1] - statsize[2] - 2
        local y2 = -math.floor(statsize[1]/2)

        local x3 = math.min(math.floor(statsize[7]/2) - statsize[3], -1)
        local y3 = math.min(-math.ceil(statsize[1]/2), -2 -statsize[7]) - statsize[3] - 1

        local x4 = math.max(math.ceil(statsize[7]/2) + 2 + statsize[4], statsize[7] + 2, statsize[8] + 2, math.ceil(statsize[8]/2) + statsize[6] + 2) - statsize[4]
        local y4 = -statsize[7] - statsize[4] - 3

        local x5 = math.min(math.ceil(statsize[8]/2) - statsize[5], -1)
        local y5 = math.max(math.ceil(statsize[1]/2), 2 + statsize[8]) + 1
        
        
        local x6 = math.max(math.ceil(statsize[7]/2) + 2 + statsize[4], statsize[7] + 2, statsize[8] + 2, math.ceil(statsize[8]/2) + statsize[6] + 2) - statsize[6]
        local y6 = statsize[8] + 3

        local x7 = 1
        local y7 = -2 -statsize[7]

        local x8 = 1
        local y8 = 1

        local ship = {
            {x1, y1, 1},
            {x2, y2, 1},
            {x3, y3, 1},
            {x4, y4, 1},
            {x5, y5, 1},
            {x6, y6, 1},
            {x7, y7, 1},
            {x8, y8, 1},
        }

        --player[playern][2][virusn][4] = corridoorroomcreate(ship)
        local corridoor = corridoorcreate(ship)

        --store the widths alongside these coordinates and return them.
        table.insert(ship, statsize)
        player[playern][4][virusn] = ship
    end

    function corridoorcreate(ship)
        local corridoor = {
            {}
        }


        local ship = {
            {x1, y1, 1},
            {x2, y2, 1},
            {x3, y3, 1},
            {x4, y4, 1},
            {x5, y5, 1},
            {x6, y6, 1},
            {x7, y7, 1},
            {x8, y8, 1},
        }
    end
    
    function stitchall()
        for playern = 1, table.getn(player) do
            for virusn = 1, table.getn(player[playern][1]) do
                shipstitch(playern, virusn)
            end
        end
    end
--


--Check Battlegrid
    function checkpanelappropriate(playern, virusn, prog, statn, location)
        --location is the nth panel on the programming grids.
        --Checks whether a panel can be placed.
        local appropriate = true
        
        local rightempty = checkrightp(playern, virusn, statn, location, 0)
        
        if checkleftappropriatep(playern, virusn, statn, location) == false then
            appropriate = false
        elseif rightempty < dbprog[prog[1]][prog[2]][prog[3]][6] - 1 then
            appropriate = false
        else
            for progwidth = 1, dbprog[prog[1]][prog[2]][prog[3]][6] do
                if player[playern][2][virusn][1][statn][location + progwidth] ~= 1 or player[playern][2][virusn][2][statn][location + progwidth - 1] ~= 0 then
                    appropriate = false
                end
            end
        end
        return appropriate
    end

    function truthbox(bool, syntax)
        if syntax == "is" then
            return bool
        elseif syntax == "not" then
            if bool == false then
                return true
            else
                return false
            end
        else
            return false
        end
    end
    
    function checkonmap(playern, virusn, x, y)
        if battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y] ~= nil then 
            if battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x] ~= nil then
                return true
            end
        end
        return false
    end
    
    function checkempty(playern, virusn, x, y)
        if checkonmap(playern, virusn, x, y) == true then
            if battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x] == 1 then
                return true
            end
        end
        return false
    end
    
    function checkenemy(playern, virusn, x, y)
        if checkonmap(playern, virusn, x, y) == true then
            if type(battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x]) == "table" then
                if battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][1] ~= playern then
                    return true
                end
            end
        end
        return false
    end
    
    function checkfriendly(playern, virusn, x, y)
        if checkonmap(playern, virusn, x, y) == true then
            if type(battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x]) == "table" then
                if battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][1] == playern then
                    return true
                end
            end
        end
        return false
    end
    
    function checkwoundup(playern, virusn, x, y)
        if checkonmap(playern, virusn, x, y) == true then
            if type(battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x]) == "table" then
                if type(player[battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][1]][5][battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][2]]) == "table" then
                    if player[battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][1]][5][battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][2]][4] == true then
                        return true
                    end
                end
            end
        end
        return false
    end
    
    function checksub50hp(playern, virusn, x, y)
        boole = checkbelowhp(playern, virusn, x, y, 0.5)
        return boole
    end
    
    function checksub20hp(playern, virusn, x, y)
        boole = checkbelowhp(playern, virusn, x, y, 0.2)
        return boole
    end
    
    function checkbelowhp(playern, virusn, x, y, mult)
        if checkonmap(playern, virusn, x, y) == true then
            if type(battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x]) == "table" then
                if player[battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][1]][1][battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][2]][13] < player[battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][1]][1][battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][2]][12] * mult then
                    return true
                end
            end
        end
        return false
    end
    
    function checkrighti(playern, virusn, statn, impn, lookfor)
        local currentplace = player[playern][2][virusn][3][statn][1][impn][1]
        local placesr = 0
        local leaveloop = false
        while leaveloop == false do
            if currentplace + placesr / player[playern][2][virusn][1][statn][1] ~= math.floor(currentplace + placesr / player[playern][2][virusn][1][statn][1]) then
                if player[playern][2][virusn][2][statn][currentplace + placesr] == lookfor then
                    placesr = placesr + 1
                else
                    leaveloop = true
                end
            else
                leaveloop = true
            end
        end
        return placesr
    end
    
    function checkrightp(playern, virusn, statn, place, lookfor)
        local currentplace = place
        local placesr = 1
        local rows = player[playern][2][virusn][1][statn][1]
        local leaveloop = false
        while leaveloop == false do
            if (currentplace + placesr - 1) / rows ~= math.floor((currentplace + placesr - 1) / rows) then
                if type(lookfor) == "table" then
                    local checkit = 0
                    if type (player[playern][2][virusn][2][statn][currentplace + placesr]) == "table" then
                        if player[playern][2][virusn][2][statn][currentplace + placesr][1] == lookfor[1] then
                            if player[playern][2][virusn][2][statn][currentplace + placesr][2] == lookfor[2] then
                                if player[playern][2][virusn][2][statn][currentplace + placesr][3] == lookfor[3] then
                                    placesr = placesr + 1
                                    checkit = 1
                                end
                            end
                        end
                    end
                    if checkit == 0 then
                        leaveloop = true
                    end
                elseif player[playern][2][virusn][2][statn][currentplace + placesr] == lookfor then
                    placesr = placesr + 1
                else
                    leaveloop = true
                end
            else
                leaveloop = true
            end
        end
        return placesr - 1
    end
    
    function checkleftappropriatep(playern, virusn, statn, place)
        --checks for any programmes to the left, and returns true if none found or the programme size isn't enough to block this square
        local currentplace = place
        local placesr = -1
        local rows = player[playern][2][virusn][1][statn][1]
        local leaveloop = false
        local appro = true
        while leaveloop == false do
            if (currentplace + placesr) == 1 then
                leaveloop = true
            elseif (currentplace + placesr) / rows ~= math.floor((currentplace + placesr) / rows) then
                if type (player[playern][2][virusn][2][statn][currentplace + placesr]) == "table" then
                    if type (player[playern][2][virusn][2][statn][currentplace + placesr][1]) ~= "string" then
                        if dbprog[player[playern][2][virusn][2][statn][currentplace + placesr][1]][player[playern][2][virusn][2][statn][currentplace + placesr][2]][player[playern][2][virusn][2][statn][currentplace + placesr][3]][6] > placesr * -1 then
                            appro = false
                        end
                    end
                    leaveloop = true
                else
                    placesr = placesr - 1
                end
            else
                leaveloop = true
            end
        end
        return appro
    end
--


--Action Battlegrid
    function bgridmove(playern, virusn, x, y, prog)
        -- Executes a move command if the destination is clear.
        --Checks that the active virus is still on the active grid. ==TODO== This check will probably become unnecessary.
        if battlegrid[activegrid][2][playern][virusn] ~=nil then
            if battlegrid[activegrid][2][playern][virusn][2] ~= 1 then  --==TODO== check why this is needed.
                if y < -0.1 then battlegrid[activegrid][2][playern][virusn][3] = "u" end
                if y > 0.1 then battlegrid[activegrid][2][playern][virusn][3] = "d" end
                if x < -0.1 then battlegrid[activegrid][2][playern][virusn][3] = "l" end
                if x > 0.1 then battlegrid[activegrid][2][playern][virusn][3] = "r" end
                    -- if the panel of the current battlespace which corresponds to the value held by this virus + the movement values is clear then
                if checkempty(playern, virusn, x, y) == true then
                    
                    -- the tile currently standing on becomes clear.
                    battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2]][battlegrid[activegrid][2][playern][virusn][1]] = 1
                    -- the coordinates stored in the virus change by the movement values.
                    battlegrid[activegrid][2][playern][virusn][2] = battlegrid[activegrid][2][playern][virusn][2] + y
                    
                    battlegrid[activegrid][2][playern][virusn][1] = battlegrid[activegrid][2][playern][virusn][1] + x
                    --The tile where the virus is now standing holds the virus in its grid.
                    battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2]][battlegrid[activegrid][2][playern][virusn][1]] = {playern,virusn}
                end
            end
        end
    end

    function bgridattack(playern, virusn, x, y, prog)
        -- Executes a move command if the destination is clear.
        --Checks that the active virus is still on the active grid. ==TODO== This check will probably become unnecessary.
        if battlegrid[activegrid][2][playern][virusn] ~=nil then
            if battlegrid[activegrid][2][playern][virusn][2] ~= 1 then  --==TODO== check why this is needed.
                if y < -0.1 then battlegrid[activegrid][2][playern][virusn][3] = "u" end
                if y > 0.1 then battlegrid[activegrid][2][playern][virusn][3] = "d" end
                if x < -0.1 then battlegrid[activegrid][2][playern][virusn][3] = "l" end
                if x > 0.1 then battlegrid[activegrid][2][playern][virusn][3] = "r" end
                    -- if the panel of the current battlespace which corresponds to the value held by this virus + the movement values is clear then
                if type(battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x]) == "table" then
                    local oplayern = battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][1]
                    local ovirusn = battlegrid[activegrid][1][battlegrid[activegrid][2][playern][virusn][2] + y][battlegrid[activegrid][2][playern][virusn][1] + x][2]
                    for i = 1, table.getn(prog[3][1][6]) do
                        local statgive = (prog[3][1][6][i][1] * 2) + 1
                        local statgiveno = player[playern][1][virusn][statgive + 3]
                        local statrecieve = (prog[3][1][6][i][1] * 2) + 2
                        local statrecieveno = player[oplayern][1][ovirusn][statrecieve + 3]
                        if statgive == 3 then
                            local damage = math.ceil(prog[3][1][6][i][3] * statgiveno/math.sqrt(statrecieveno))
                            impulsetrigger(playern, virusn, statgive, {0, damage, oplayern, ovirusn, nil})
                            -- player[oplayern][1][ovirusn][13] = player[oplayern][1][ovirusn][13] - damage
                            -- impulsetrigger(oplayern, ovirusn, statrecieve, {0, damage, nil, nil, nil})
                        end
                        if statgive == 5 then
                            local damage = math.ceil(prog[3][1][6][i][3] * statgiveno/math.sqrt(statrecieveno))
                            impulsetrigger(playern, virusn, statgive, {0, damage, oplayern, ovirusn, nil})
                        end
                    end
                end
            end
        end
    end

    function randominject(playern, virusn, x, y, prog)
        local statn = prog[3][1][6][1]
        local inprog = prog[3][1][6][2]
        local location = {}
        local totallocs = table.getn(player[playern][2][virusn][2][statn])
        for i = 1, totallocs do
            table.insert(location, i)
        end
        local injected = false
        local rinject = 1
        while injected == false do
            rinject = table.remove(location, love.math.random(totallocs))
            totallocs = totallocs - 1
            if checkpanelappropriate(viewplayer, viewvirus, inprog, statn, rinject) == true then
                player[viewplayer][2][viewvirus][2][statn][rinject] = {}
                for statpart = 1, table.getn(inprog) do 
                    player[viewplayer][2][viewvirus][2][statn][rinject][statpart] = inprog[statpart]
                end
                player[viewplayer][2][viewvirus][2][statn][rinject][4] = {}
                for j = 1, table.getn(dbprog[inprog[1]][inprog[2]][inprog[3]][7]) do
                    table.insert(player[viewplayer][2][viewvirus][2][statn][rinject][4], { tonumber(dbprog[inprog[1]][inprog[2]][inprog[3]][7][j]) })
                end
                injected = true
                if prog[3][1][6][3] ~= nil then
                    player[playern][5][virusn][prog[3][1][6][3]] = true
                end
            end
            if totallocs == 0 then
                injected = true
            end
        end
    end

    function injectavatar(playern, virusn, statn)
        local inprog = {1, 1, 1}
        local location = {}
        local totallocs = table.getn(player[playern][2][virusn][2][statn])
        for i = 1, totallocs do
            table.insert(location, i)
        end
        local injected = false
        local rinject = 1
        while injected == false do
            rinject = table.remove(location, love.math.random(totallocs))
            totallocs = totallocs - 1
            if checkpanelappropriate(viewplayer, viewvirus, inprog, statn, rinject) == true then
                player[viewplayer][2][viewvirus][2][statn][rinject] = {"avatar"}
                avatarstate[1] = "InCompany"
                avatarstate[2] = {playern, virusn, statn, rinject}
                injected = true
            end
            if totallocs == 0 then
                injected = true
            end
        end
    end

    function bgridwait(playern, virusn, x, y, prog)
        local xd = 1
    end
--


--Impulse Functions
    function heartbeat(playern, virusn)
        --Increments the heartbeat/impulse along a room.
        --For each room
        for statn = 1, 8 do
            if player[playern][6][virusn][statn][1] < 0.999 then
                player[playern][6][virusn][statn][1] = player[playern][6][virusn][statn][1] + player[playern][6][virusn][statn][2]
            else
                for i = 1, player[playern][6][virusn][statn][1] do
                    player[playern][6][virusn][statn][1] = player[playern][6][virusn][statn][2]
                    --Get the dimensions of the room
                    local beatstotal = table.getn(player[playern][2][virusn][3][statn][1])
                    --For each impulse counter active in the room
                    local rows = math.ceil(math.sqrt(player[playern][1][virusn][statn+3] + 0.1))
                    local removev = {}
                    for impn = 1, beatstotal do
                        if player[playern][2][virusn][3][statn][1][impn][1] > rows * rows then
                            table.insert(removev, impn)
                        end
                    end
                    for i = 1, table.getn(removev) do
                        rem = table.remove(removev)
                        table.remove(player[playern][2][virusn][3][statn][1], rem)
                    end
                    beatstotal = table.getn(player[playern][2][virusn][3][statn][1])
                    
                    for impn = 1, beatstotal do
                        local normalpass = false
                        -- if the impulse doesn't have a special counter or is set to turn right
                        if type(player[playern][2][virusn][3][statn][1][impn]) == "table" then
                            if player[playern][2][virusn][3][statn][1][impn][5] == nil then
                                normalpass = true
                            elseif player[playern][2][virusn][3][statn][1][impn][5] == "ir"  then
                                normalpass = true
                            end
                            if normalpass == true then
                                --increment it by one
                                player[playern][2][virusn][3][statn][1][impn][1] = player[playern][2][virusn][3][statn][1][impn][1] + 1
                                --if it has a down counter
                            elseif player[playern][2][virusn][3][statn][1][impn][5] == "id" then
                                -- increment it by rows
                                player[playern][2][virusn][3][statn][1][impn][1] = player[playern][2][virusn][3][statn][1][impn][1] + rows
                            end

                            --If the spot you're on is inside the grid then
                            if player[playern][2][virusn][3][statn][1][impn][1] <= rows * rows then
                                --if the programmegrid has something on it then
                                if player[playern][2][virusn][2][statn][player[playern][2][virusn][3][statn][1][impn][1]] ~= 0 then
                                    if player[playern][2][virusn][2][statn][player[playern][2][virusn][3][statn][1][impn][1]] ~= nil then
                                        local deg = ("C:\\Users\\Dan\\Desktop\\Beuracrobots\\debug.txt")
                                        filedb = io.open(deg, "w")
                                        filedb:close()
                                        filedb = io.open(deg, "a")
                                        --interact
                                        
                                        hbproginteract(playern, virusn, statn, impn, player[playern][2][virusn][2][statn][player[playern][2][virusn][3][statn][1][impn][1]])
                                    end
                                end
                            else
                                --do by the impulsepass
                                impulsepass(playern, virusn, statn, player[playern][2][virusn][3][statn][1][impn])
                                --remove this impulse
                            end
                        end
                    end
                end
            end
        end
    end

    function impulsetrigger(playern, virusn, statn, impulse)
        table.insert(player[playern][2][virusn][3][statn][1], 1, impulse)
    end

    function impulsepass(playern, virusn, statn, impulse)
        --If its the speedroom then start an impulse in the int room
        if statn == 2 then
            if player[playern][2][virusn][3][9][statn][2] == 1 then
                local startrow = player[playern][2][virusn][3][9][statn][1]
                impulsetrigger(playern, virusn, 1, {startrow, nil, nil, nil, nil})
                roomtrigger(playern, virusn, 1)
            elseif player[playern][2][virusn][3][9][statn][2] == 2 then
                if player[playern][2][virusn][3][9][statn][3][1] < player[playern][2][virusn][3][9][statn][3][2] then
                    player[playern][2][virusn][3][9][statn][3][1] = player[playern][2][virusn][3][9][statn][3][1] + 1
                end
            end
        end
        --If its the strength room then send an impulse with damage on it to the opposing toughness room
        if statn == 3 then
            impulsetrigger(impulse[3], impulse[4], 4, {0, impulse[2], nil, nil, nil})
        end
        --if its the toughness room then take the damage
        if statn == 4 then
            player[playern][1][virusn][13] = player[playern][1][virusn][13] - impulse[2]
            --                  {0, damage, oplayern, ovirusn, nil}
                            -- player[oplayern][1][ovirusn][13] = player[oplayern][1][ovirusn][13] - damage
                            -- impulsetrigger(oplayern, ovirusn, statrecieve, {0, damage, nil, nil, nil})
        end
    end

    function roomtrigger(playern, virusn, statn)
        for panelposition = 1, table.getn(player[playern][2][virusn][2][statn]) do
            if type(player[playern][2][virusn][2][statn][panelposition]) == "table" then
                if type(player[playern][2][virusn][2][statn][panelposition][4]) == "table" then
                    for effectn = 1, table.getn(player[playern][2][virusn][2][statn][panelposition][4]) do
                        dbprogroom[player[playern][2][virusn][2][statn][panelposition][4][effectn][1]](playern, virusn, statn, panelposition, effectn)
                    end
                    local totaleffect = table.getn(player[playern][2][virusn][2][statn][panelposition][4])
                    for effectn = 1, totaleffect do
                        if player[playern][2][virusn][2][statn][panelposition][4][effectn][3] == "remove" then
                            table.remove(player[playern][2][virusn][2][statn][panelposition][4], effectn)
                            effectn = effectn - 1
                            totaleffect = totaleffect - 1
                        end
                    end
                end
            end
        end
    end

    function softerror(playern, virusn, statn, impn, totalpanel)
        local rows = math.floor(math.sqrt(totalpanel+ 0.5))
        local currentrow = math.ceil(player[playern][2][virusn][3][statn][1][impn][1]/rows)
        if currentrow == rows then
            harderror(playern, virusn, statn, impn, totalpanel) 
        else
            player[playern][2][virusn][3][statn][player[playern][2][virusn][3][statn][1][impn][1] + 1] = 0
            player[playern][2][virusn][3][statn][1][impn] = {}
            player[playern][2][virusn][3][statn][1][impn][1] = rows * currentrow
        end
    end

    function harderror(playern, virusn, statn, impn, totalpanel)
        player[playern][2][virusn][3][statn][player[playern][2][virusn][3][statn][1][impn][1] + 1] = 0
        table.remove(player[playern][2][virusn][3][statn][1], impn) --==TODO== handle having more than one impulse on screen where not the last one recieves hard error
    end

    function hbproginteract(playern, virusn, statn, impn, progno)
        
        local paneltotal = table.getn(player[playern][2][virusn][2][statn])

        if progno[1] == "avatar" then
            softerror(playern, virusn, statn, impn, paneltotal)
        else

            local prog = dbprog[progno[1]][progno[2]][progno[3]]

            if progno[1] == 1 then   --executable
                executableinteract(playern, virusn, statn, impn, progno, prog, paneltotal)
            elseif progno[1] == 2 then --range
                rangeinteract(playern, virusn, statn, impn, progno, prog, paneltotal)
            elseif progno[1] == 3 then --condition
                conditioninteract(playern, virusn, statn, impn, progno, prog, paneltotal)
            elseif progno[1] == 4 then --orderer
                ordererinteract(playern, virusn, statn, impn, progno, prog, paneltotal)
            elseif progno[1] == 5 then
                
            elseif progno[1] == 6 then -- if it is an upload then
                uploadinteract(playern, virusn, statn, impn, progno, prog, paneltotal)
            elseif progno[1] == 7 then -- if it is a syntax then
                syntaxinteract(playern, virusn, statn, impn, progno, prog, paneltotal)
            end
        end
    end

    --proginteract subfunctions
        function executableinteract(playern, virusn, statn, impn, progno, prog, paneltotal) --1
            if progno[5] == "d" then
                softerror(playern, virusn, statn, impn, paneltotal)
            else
                                                                                                                                                    filedb:write(playern.." virus "..virusn.." stat "..statn.." impn "..impn.." progno "..progno[1]..progno[2]..progno[3].."\n")
                if player[playern][2][virusn][3][statn][1][impn][2] == nil then     -- if the impulse has no executable files
                    player[playern][2][virusn][3][statn][1][impn][2] = {}           --store them
                    player[playern][2][virusn][3][statn][1][impn][2][1] = prog[1]         --name
                    player[playern][2][virusn][3][statn][1][impn][2][2] = prog[2]         --element
                    player[playern][2][virusn][3][statn][1][impn][2][3] = prog[3][1][1]   --exe e.g. move
                    player[playern][2][virusn][3][statn][1][impn][2][4] = prog[3][1][2]   --number executed     --==TODO== Taking up multiple actions
                    player[playern][2][virusn][3][statn][1][impn][2][5] = prog[3][1][3]   --"a" for absolute ranges, "re" for relative changes.
                    player[playern][2][virusn][3][statn][1][impn][2][6] = prog[3][1][4]   --list of accepted ranges as pairs of xy coordinates.
                    if prog[4] ~= nil then           -- if the programme gives ranges then
                                                                                                                                                                    filedb:write("Ranges given\n")
                        if prog[4][1] == "h" or player[playern][2][virusn][3][statn][1][impn][3] == nil then        -- if the ranges are hardlocked or the impulse has no loaded ranges
                                                                                                                                                        filedb:write("Writing ranges\n")
                            if prog[4][2] == "r" then                         -- if the ranges are chosen randomly then.
                                                                                                                                                                    filedb:write("Choosing randomly\n")
                                local ranges = table.getn(prog[4][3])
                                                                                                                                                            filedb:write("Ranges"..ranges.."\n")
                                local insert = 0
                                local vholder = {}
                                for i = 1, ranges do
                                    table.insert(vholder, i)
                                end
                                player[playern][2][virusn][3][statn][1][impn][3] = {}        --set the ranges as empty
                                for i = 1, table.getn(prog[4][3]) do
                                    insert = table.remove(vholder, love.math.random(ranges))
                                    ranges = ranges - 1
                                                                                                                                                            filedb:write("  INSERTING .."..insert.."\n")
                                    if prog[4][4] == "a" then                                       --if absolute ranges then only flip the x coordinate if starting on opposite side.
                                                                                                                                                                filedb:write("Absolute range\n")
                                        local convert = {}
                                        convert[1] = prog[4][3][insert][1]
                                        convert[2] = prog[4][3][insert][2]
                                        if playern == 2 then
                                            convert[1] = convert[1] * -1
                                        end
                                                                                                                                                            filedb:write("INSERT COORDS"..convert[1]..".."..convert[2].."\n")
                                        table.insert(player[playern][2][virusn][3][statn][1][impn][3], convert)
                                    elseif prog[4][4] == "re" then                                   --if relative ranges then tranform accordingly
                                                                                                                                                                        filedb:write("Relative Range\n")
                                        local convert = {}
                                        if battlegrid[activegrid][2][playern][virusn][3] == "r" then
                                            convert[1] = prog[4][3][insert][1]
                                            convert[2] = prog[4][3][insert][2]
                                        end
                                        if battlegrid[activegrid][2][playern][virusn][3] == "l" then
                                            convert[1] = prog[4][3][insert][1] * -1
                                            convert[2] = prog[4][3][insert][2] * -1
                                        end
                                        if battlegrid[activegrid][2][playern][virusn][3] == "d" then
                                            convert[1] = prog[4][3][insert][2] * - 1
                                            convert[2] = prog[4][3][insert][1]
                                        end
                                        if battlegrid[activegrid][2][playern][virusn][3] == "u" then
                                            convert[1] = prog[4][3][insert][2]
                                            convert[2] = prog[4][3][insert][1] * -1
                                        end
                                        
                                        table.insert(player[playern][2][virusn][3][statn][1][impn][3], convert)
                                    end
                                end
                            elseif prog[4][2] == "l" then
                                                                                                                                                    filedb:write("STRIGHT INSERT\n")
                                player[playern][2][virusn][3][statn][1][impn][3] = prog[4][3]
                            end
                        else
                            player[playern][2][virusn][3][statn][1][impn][4] = "overridden"
                        end
                    end
                    if prog[5] ~= nil then                  --if the programme gives conditions then
                                                                                                                                                    filedb:write("THERE ARE CONDITIONS\n")
                        if prog[5][1] == "h" or player[playern][2][virusn][3][statn][1][impn][4] == nil then      --if they are hardlocked or have the impulse has none
                            local syntax = "is"
                            for j = 1, table.getn(prog[5][2]) do
                                if type(prog[5][2][j]) == "string" then
                                    syntax = prog[5][2][j]
                                else
                                    local rangesize = table.getn(player[playern][2][virusn][3][statn][1][impn][3])
                                    for i = 1, rangesize do  --Then remove any ranges that don't fit the condition
                                        if type(player[playern][2][virusn][3][statn][1][impn][3][i]) == "string" then
                                            table.remove(player[playern][2][virusn][3][statn][1][impn][3], rangesize - i + 1)
                                        elseif truthbox(dbconditions[tonumber(prog[5][2][j])](playern, virusn, player[playern][2][virusn][3][statn][1][impn][3][rangesize - i + 1][1], player[playern][2][virusn][3][statn][1][impn][3][rangesize - i + 1][2]), syntax) == false then
                                            table.remove(player[playern][2][virusn][3][statn][1][impn][3], rangesize - i + 1)
                                        end
                                    end
                                    if table.getn(player[playern][2][virusn][3][statn][1][impn][3]) == 0 then
                                        softerror(playern, virusn, statn, impn, paneltotal)
                                        return
                                    end
                                end
                            end
                        end
                    end
                    --==TODO== put this at the actual end of the line DELETE DEBUGNOTES
                    local actioned = 0      --Then check if the topmost range is accepted by the exe, and if so execute it. ==TODO== repeat x times based off of the exe number
                    if player[playern][2][virusn][3][statn][1][impn][3][1] == nil then
                        harderror(playern, virusn, statn, impn, totalpanel)
                    else
                                                                                                                                                filedb:write("\n\n\n"..player[playern][2][virusn][3][statn][1][impn][3][1][1].."\n"..player[playern][2][virusn][3][statn][1][impn][3][1][2].."\n\n\n")
                        local rantable = {}
                                                                                                                                                            filedb:write("CHECKING "..table.getn(prog[3][1][4]).." RANGES\n")
                        local check = table.getn(prog[3][1][4])
                        for i = 1, table.getn(prog[3][1][4]) do
                            table.insert(rantable, i)
                        end

                        local ransize = table.getn(rantable)
                        for i = 1, table.getn(prog[3][1][4]) do
                            local ranrange = table.remove(rantable, love.math.random(ransize))
                            ransize = ransize - 1                                                                                                                        filedb:write("OOOOOOOOOOOOO\n")
                            if prog[3][1][4][ranrange][1] == nil then
                                                                                                                                                filedb:write(" progrange is nil, number "..i.."\n")
                            end
                            if player[playern][2][virusn][3][statn][1][impn][3][1][1] == nil then
                                                                                                                                                    filedb:write(" imprange is nil, number "..i.."\n")
                            end
                                                                                                                                                                    filedb:write("GGGGGG\n")
                            if actioned == 0 then
                                                                                                                                            filedb:write("CHECKING progrange "..prog[3][1][4][i][1].." against storedrange ".."\n")
                                if prog[3][1][4][ranrange][1] == player[playern][2][virusn][3][statn][1][impn][3][1][1] then
                                                                                                                                                        filedb:write("MACHED X CHECKING progrange "..prog[3][1][4][i][2].." against storedrange "..player[playern][2][virusn][3][statn][1][impn][3][1][2].."\n")
                                    if prog[3][1][4][ranrange][2] == player[playern][2][virusn][3][statn][1][impn][3][1][2] then
                                                                                                                                                            filedb:write("Matched Y so calling interaction\n")
                                        player[playern][2][virusn][3][statn][1][impn][2][3](playern, virusn, player[playern][2][virusn][3][statn][1][impn][3][1][1], player[playern][2][virusn][3][statn][1][impn][3][1][2], prog)
                                        if prog[8] ~= 0 then
                                            table.insert(progno[4], {3, prog[8]})
                                            progno[5] = "d"
                                        end
                                        actioned = 1
                                    end
                                end
                            end 
                        end
                        if actioned == 0 then
                            harderror(playern, virusn, statn, impn, totalpanel)
                        end
                    end
                end
            end
        end

        function rangeinteract(playern, virusn, statn, impn, progno, prog, paneltotal) --2
            if prog[3] ~= nil then-- if the programme gives ranges then
                if progno[2] == 3 then           
                    if prog[3][1] == "1Before" then
                        if type(player[playern][2][virusn][3][statn][1][impn][3]) == "table" then --if it is set up to have ranges inside
                            local refinedrange = {}
                            local convert = {}
                            
                            for rangen = 1, table.getn(player[playern][2][virusn][3][statn][1][impn][3]) do

                                local refiney = 0
                                if player[playern][2][virusn][3][statn][1][impn][3][rangen][2] < 0 then
                                    refiney = 1
                                elseif player[playern][2][virusn][3][statn][1][impn][3][rangen][2] > 0 then
                                    refiney = -1
                                end

                                if refiney ~= 0 then
                                    convert[1] = player[playern][2][virusn][3][statn][1][impn][3][rangen][1] 
                                    convert[2] = player[playern][2][virusn][3][statn][1][impn][3][rangen][2] + refiney
                                    table.insert(refinedrange, {convert[1], convert[2]})
                                end

                                local refinex = 0
                                if player[playern][2][virusn][3][statn][1][impn][3][rangen][1] < 0 then
                                    refinex = 1
                                elseif player[playern][2][virusn][3][statn][1][impn][3][rangen][1] > 0 then
                                    refinex = -1
                                end
                                if refinex ~= 0 then
                                    convert[1] = player[playern][2][virusn][3][statn][1][impn][3][rangen][1] + refinex
                                    convert[2] = player[playern][2][virusn][3][statn][1][impn][3][rangen][2]
                                    table.insert(refinedrange, {convert[1], convert[2]})
                                
                                end
                                
                            end

                            player[playern][2][virusn][3][statn][1][impn][3] = {}
                            local insertno = table.getn(refinedrange)

                            local insertt = 0
                            for i = 1, insertno do
                                
                                insertt = love.math.random(insertno)
                                refinedrangeinsert = table.remove(refinedrange, insertt)
                                insertno = insertno - 1
                                table.insert(player[playern][2][virusn][3][statn][1][impn][3], refinedrangeinsert)
                            end
                        end
                    elseif prog[3][1] == "1towards" then
                        if type(player[playern][2][virusn][3][statn][1][impn][3]) == "table" then --if it is set up to have ranges inside
                            local refinedrange = {}
                            local convert = {}
                            
                            for rangen = 1, table.getn(player[playern][2][virusn][3][statn][1][impn][3]) do

                                local refiney = 0
                                if player[playern][2][virusn][3][statn][1][impn][3][rangen][2] < 0 then
                                    refiney = 1
                                elseif player[playern][2][virusn][3][statn][1][impn][3][rangen][2] > 0 then
                                    refiney = -1
                                end

                                if refiney ~= 0 then
                                    convert[1] = 0
                                    convert[2] = -refiney
                                    table.insert(refinedrange, {convert[1], convert[2]})
                                end

                                local refinex = 0
                                if player[playern][2][virusn][3][statn][1][impn][3][rangen][1] < 0 then
                                    refinex = 1
                                elseif player[playern][2][virusn][3][statn][1][impn][3][rangen][1] > 0 then
                                    refinex = -1
                                end
                                if refinex ~= 0 then
                                    convert[1] = -refinex
                                    convert[2] = 0
                                    table.insert(refinedrange, {convert[1], convert[2]})
                                
                                end
                                
                            end

                            player[playern][2][virusn][3][statn][1][impn][3] = {}
                            local insertno = table.getn(refinedrange)

                            local insertt = 0
                            for i = 1, insertno do
                                
                                insertt = love.math.random(insertno)
                                refinedrangeinsert = table.remove(refinedrange, insertt)
                                insertno = insertno - 1
                                table.insert(player[playern][2][virusn][3][statn][1][impn][3], refinedrangeinsert)
                            end
                            
                        end
                    elseif prog[3][1] == "1away" then
                        if type(player[playern][2][virusn][3][statn][1][impn][3]) == "table" then --if it is set up to have ranges inside
                            local refinedrange = {}
                            local convert = {}
                            
                            for rangen = 1, table.getn(player[playern][2][virusn][3][statn][1][impn][3]) do

                                local refiney = 0
                                if player[playern][2][virusn][3][statn][1][impn][3][rangen][2] < 0 then
                                    refiney = 1
                                elseif player[playern][2][virusn][3][statn][1][impn][3][rangen][2] > 0 then
                                    refiney = -1
                                end

                                if refiney ~= 0 then
                                    convert[1] = 0
                                    convert[2] = refiney
                                    table.insert(refinedrange, {convert[1], convert[2]})
                                end

                                local refinex = 0
                                if player[playern][2][virusn][3][statn][1][impn][3][rangen][1] < 0 then
                                    refinex = 1
                                elseif player[playern][2][virusn][3][statn][1][impn][3][rangen][1] > 0 then
                                    refinex = -1
                                end
                                if refinex ~= 0 then
                                    convert[1] = refinex
                                    convert[2] = 0
                                    table.insert(refinedrange, {convert[1], convert[2]})
                                
                                end
                                
                            end

                            player[playern][2][virusn][3][statn][1][impn][3] = {}
                            local insertno = table.getn(refinedrange)

                            local insertt = 0
                            for i = 1, insertno do
                                
                                insertt = love.math.random(insertno)
                                refinedrangeinsert = table.remove(refinedrange, insertt)
                                insertno = insertno - 1
                                table.insert(player[playern][2][virusn][3][statn][1][impn][3], refinedrangeinsert)
                            end
                            
                        end
                    end
                    
                elseif prog[3][3][1] == "OnMap" then
                    local xcheck = 0
                    local ycheck = 0
                    
                    local convert = {}
                    jerk = nil
                    
                    player[playern][2][virusn][3][statn][1][impn][3] = {}

                    while checkonmap(playern, virusn, xcheck, 0) == true do
                        ycheck = 0
                        while checkonmap(playern, virusn, xcheck, ycheck) == true do
                            convert[1] = xcheck
                            convert[2] = ycheck
                            table.insert(player[playern][2][virusn][3][statn][1][impn][3], {convert[1], convert[2]} )
                            ycheck = ycheck + 1
                        end
                        ycheck = -1
                        while checkonmap(playern, virusn, xcheck, ycheck) == true do
                            convert[1] = xcheck
                            convert[2] = ycheck
                            table.insert(player[playern][2][virusn][3][statn][1][impn][3], {convert[1], convert[2]})
                            ycheck = ycheck -1
                        end
                        xcheck = xcheck + 1
                    end
                    xcheck = -1
                    while checkonmap(playern, virusn, xcheck, 0) == true do
                        ycheck = 0
                        while checkonmap(playern, virusn, xcheck, ycheck)  == true do
                            convert[1] = xcheck
                            convert[2] = ycheck
                            table.insert(player[playern][2][virusn][3][statn][1][impn][3], {convert[1], convert[2]})
                            ycheck = ycheck + 1
                        end
                        ycheck = -1
                        while checkonmap(playern, virusn, xcheck, ycheck) == true do
                            convert[1] = xcheck
                            convert[2] = ycheck
                            table.insert(player[playern][2][virusn][3][statn][1][impn][3], {convert[1], convert[2]})
                            ycheck = ycheck -1
                        end
                        xcheck = xcheck -1
                    end

                    jerk = table.getn(player[playern][2][virusn][3][statn][1][impn][3])



                elseif prog[3][2] == "r" then                         -- if the ranges are chosen randomly then.
                    local ranges = table.getn(prog[3][3])
                    local insert = 0
                    local vholder = {}
                    for i = 1, ranges do
                        table.insert(vholder, i)
                    end
                    player[playern][2][virusn][3][statn][1][impn][3] = {}
                    for i = 1, table.getn(prog[3][3]) do
                        insert = table.remove(vholder, love.math.random(ranges))
                        ranges = ranges - 1
                        if prog[3][4] == "a" then
                            
                            local convert = {}
                            convert[1] = prog[3][3][insert][1]
                            convert[2] = prog[3][3][insert][2]
                            if playern == 2 then
                                convert[1] = convert[1] * -1
                            end
                            table.insert(player[playern][2][virusn][3][statn][1][impn][3], convert)
                        elseif prog[3][4] == "re" then
                            local convert = {}
                            if battlegrid[activegrid][2][playern][virusn][3] == "r" then
                                convert[1] = prog[3][3][insert][1]
                                convert[2] = prog[3][3][insert][2]
                            end
                            if battlegrid[activegrid][2][playern][virusn][3] == "l" then
                                convert[1] = prog[3][3][insert][1] * -1
                                convert[2] = prog[3][3][insert][2] * -1
                            end
                            if battlegrid[activegrid][2][playern][virusn][3] == "d" then
                                convert[1] = prog[3][3][insert][2] * - 1
                                convert[2] = prog[3][3][insert][1]
                            end
                            if battlegrid[activegrid][2][playern][virusn][3] == "u" then
                                convert[1] = prog[3][3][insert][2]
                                convert[2] = prog[3][3][insert][1] * -1
                            end
                            table.insert(player[playern][2][virusn][3][statn][1][impn][3], convert)
                            
                        end
                    end
                elseif prog[3][2] == "l" then
                    player[playern][2][virusn][3][statn][1][impn][3] = prog[3][3]
                end
            end
        end

        function conditioninteract(playern, virusn, statn, impn, progno, prog, paneltotal) --3
            if progno[5] ~= "d" then
                if prog[3] ~= nil then           -- if the impulse gives conditions then
                    local syntax = "is"
                    for j = 1, table.getn(prog[3]) do
                        if player[playern][2][virusn][3][statn][1][impn][3] ~= nil then
                            local rangesize = table.getn(player[playern][2][virusn][3][statn][1][impn][3])
                            for i = 1, rangesize do  --Then remove any ranges that don't fit the condition
                                if type(player[playern][2][virusn][3][statn][1][impn][3][rangesize - i + 1]) == "string" then
                                    syntax = player[playern][2][virusn][3][statn][1][impn][3][rangesize - i + 1]
                                    table.remove(player[playern][2][virusn][3][statn][1][impn][3], rangesize - i + 1)
                                elseif truthbox(dbconditions[tonumber(prog[3][j])](playern, virusn, player[playern][2][virusn][3][statn][1][impn][3][rangesize - i + 1][1], player[playern][2][virusn][3][statn][1][impn][3][rangesize - i + 1][2]), syntax) == false then
                                    table.remove(player[playern][2][virusn][3][statn][1][impn][3], rangesize - i + 1)
                                end
                            end --if no ranges pass the test then softerror
                            if table.getn(player[playern][2][virusn][3][statn][1][impn][3]) == 0 then
                                softerror(playern, virusn, statn, impn, paneltotal)
                                return false --Why return anything needed?
                            end
                        end
                    end
                end
            end
        end

        function ordererinteract(playern, virusn, statn, impn, progno, prog, paneltotal) --4
            if progno[5] ~= "d" then --if not deactivated then
                if prog[3] == "r" then -- if its a splitter type
                    player[playern][2][virusn][3][statn][1][impn][5] = "id" -- change the direction of the impulse downwards
                end
            else
                player[playern][2][virusn][3][statn][1][impn][5] = "ir"
            end
        end

        --5

        function uploadinteract(playern, virusn, statn, impn, progno, prog, paneltotal) --6
            if progno[2] == 1 then
                if progno[5] ~= "d" then
                    if prog[5] ~= nil then
                        if prog[5][1] == "windup" then
                            if type(player[playern][2][virusn][3][statn][1][impn][2]) == "number" then
                                player[playern][2][virusn][3][statn][1][impn][2] = math.floor(player[playern][2][virusn][3][statn][1][impn][2] * 1.5)
                            end
                        end
                        if prog[5][2] == "undo" then
                            player[playern][5][virusn][prog[5][3]] = nil
                        end
                        if prog[5][4] == "destroyme" then
                            player[playern][2][virusn][2][statn][player[playern][2][virusn][3][statn][1][impn][1]] = 0
                        end
                    end
                end
            end
        end

        function syntaxinteract(playern, virusn, statn, impn, progno, prog, paneltotal) --7
            if progno[5] ~= "d" then
                if prog[5] ~= nil then
                    for i = 1, table.getn(prog[5]) do
                        local insert = tostring(prog[5][i])
                        table.insert(player[playern][2][virusn][3][statn][1][impn][3], insert)
                    end
                end
            end
        end
    --

    function deactivate(playern, virusn, statn, panelposition, effectn)
        player[playern][2][virusn][2][statn][panelposition][4][effectn][2] = player[playern][2][virusn][2][statn][panelposition][4][effectn][2] - 1
        if player[playern][2][virusn][2][statn][panelposition][4][effectn][2] <= 0 then
            player[playern][2][virusn][2][statn][panelposition][5] = nil
            player[playern][2][virusn][2][statn][panelposition][4][effectn][3] = "remove"
        end  
    end

    function randomise(playern, virusn, statn, panelposition, effectn)
        local chance = love.math.random(2)
        if chance == 1 then
            player[playern][2][virusn][2][statn][panelposition][5] = nil
        else
            player[playern][2][virusn][2][statn][panelposition][5] = "d"
        end
    end

    function alternate(playern, virusn, statn, panelposition, effectn) 
                    --==TODO set this to check left instead to facilitate destructible programs
        if player[playern][2][virusn][2][statn][panelposition][4][effectn][3] == nil then
            lwidth = checkrightp(playern, virusn, statn, panelposition, player[playern][2][virusn][2][statn][panelposition])
            for i = 1, lwidth do
                for j = 1, table.getn(player[playern][2][virusn][2][statn][panelposition + i][4]) do
                    if player[playern][2][virusn][2][statn][panelposition + i][4][j][1] == player[playern][2][virusn][2][statn][panelposition][4][j][1] then
                        player[playern][2][virusn][2][statn][panelposition + i][4][j][2] = i
                        player[playern][2][virusn][2][statn][panelposition + i][5] = "d"
                        player[playern][2][virusn][2][statn][panelposition + i][4][j][3] = lwidth
                    end
                end
            end
            player[playern][2][virusn][2][statn][panelposition][4][effectn][2] = 0
            player[playern][2][virusn][2][statn][panelposition][4][effectn][3] = lwidth
        end

        if player[playern][2][virusn][2][statn][panelposition][4][effectn][2] == 0 then
            player[playern][2][virusn][2][statn][panelposition][5] = nil
            player[playern][2][virusn][2][statn][panelposition][4][effectn][2] = player[playern][2][virusn][2][statn][panelposition][4][effectn][3]
        else
            player[playern][2][virusn][2][statn][panelposition][5] = "d"
            player[playern][2][virusn][2][statn][panelposition][4][effectn][2] = player[playern][2][virusn][2][statn][panelposition][4][effectn][2] - 1
        end
    end

    function reboot(playern, virusn, statn, panelposition, effectn)
        
    end

    function timeplus()
        if turn[3] < 300 then
            turn[3] = turn[3] + 1
            for i = 1, table.getn(turn[2]) do
                if turn[3] == turn[2][i][1][1] then
                    table.remove(turn[2][i][1], 1)
                    impulsetrigger(turn[2][i][2], turn[2][i][3], 2, {0, nil, nil, nil, nil})
                    
                    --==TODO== Set up a function that pauses time.
                end
            end
        else
            turnstart()
        end
    end

    function turninit()
        turn = {0, {}, 0}
        turnstart()
    end

    function turnstart()
        turn[1] = turn[1] + 1
        turn[3] = 0
        local inserttable = {}
        turn[2] = {}
        for i = 1, table.getn(battlegrid[activegrid][2]) do
            for j = 1, table.getn(battlegrid[activegrid][2][i]) do
                inserttable = {{}}
                inserttable[4] = math.floor(math.sqrt(player[i][1][j][5]))
                for k = 1, inserttable[4] do
                    table.insert(inserttable[1], math.ceil((300/(math.sqrt(player[i][1][j][5])))) * k)
                end
                inserttable[2] = i
                inserttable[3] = j
                table.insert(turn[2], inserttable)
            end
        end
    end
--



dbvirus = 
{
    {
    --ID
        1,
    --NAME
        "Hound",
    --TYPES
        {Tnormal},
    --STATS                         
        {
            --LEVEL 1                       
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level 
                {{1, 1, 1}, {1, 3, 1}},
            --EXAMPLE LOADOUTS     
                {"rabid", "wanderer"}
            },
            
            --LEVEL 2                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level 
                { {4, 1, 1} },
            --EXAMPLE LOADOUTS  
                {"balanced", "rabid", "wanderer"}
            },
            --LEVEL 3                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level    
                {{1, 1, 2}, {2, 1, 1}, {1, 1, 3}, {2, 1, 3}, {2, 1, 4}, {2, 1, 5}},
            --EXAMPLE LOADOUTS  
                {"linestutterer", "charger", "rabid", "sloth", "wanderhitter"}
            },
            --LEVEL 4                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level   
                { {2, 2, 3}, },
            --EXAMPLE LOADOUTS             
                {"goalie", "siege", "wanderlite"}
            },
            --LEVEL 5                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level         
                { {1, 3, 2}, {4, 1, 2} },
            --EXAMPLE LOADOUTS            
                {"blip", "brawler", "siege", "spiral", "wanderhit"}
            },
            --LEVEL 6                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level        
                { {2, 2, 1}, {3, 1, 1} },
            --EXAMPLE LOADOUTS            
                {"achillesheel", "charger", "hitnrunner"}
            },
            --LEVEL 7                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                { {7, 1, 1}, {2, 1, 2}, {1, 2, 1}, {3, 1, 3} },
            --EXAMPLE LOADOUTS
                {"coward", "despairer", "strangeadvance", "winduphitter"}
            },
            --LEVEL 8                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {"heavyhitter", "prioritiser", "twostrain"}
            },
            --LEVEL 9                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                { {2, 3, 1}, {2, 2, 2}},
            --EXAMPLE LOADOUTS
                {"challenger", "persuer", "strongrabid"}
            },
        --LEVEL 10                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                { {3, 1, 4}, {2, 1, 3}},
            --EXAMPLE LOADOUTS
                {"truerabid", "truewanderhitter", "wobbleforward"}
            },
            --LEVEL 11
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    { {2, 3, 2} },
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 12
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    { {2, 1, 4}, {2, 1, 5}},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 13
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 14
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 15
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 16
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {{3, 1, 4}, {3, 1, 5}},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 17
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 18
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 19
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 20
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 21
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 22
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 23
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 24
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 25
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 26
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 27
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 28
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 29
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 30
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 31
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 32
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 33
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 34
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 35
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 36
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 37
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 38
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 39
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 40
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 41
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 42
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 43
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 44
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 45
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 46
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 47
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 48
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 49
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 50
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 51
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 52
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 53
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 54
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 55
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 56
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 57
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 58
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 59
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 60
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 61
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 62
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 63
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 64
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 65
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 66
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 67
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 68
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 69
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 70
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 71
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 72
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 73
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 74
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 75
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 76
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 77
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 78
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 79
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 80
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 81
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 82
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 83
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 84
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 85
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 86
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 87
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 88
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 89
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 90
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 91
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 92
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 93
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 94
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 95
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 96
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 97
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 98
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 99
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 100
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        }
    },
    {
    --ID
        1,
    --NAME
        "Golem",
    --TYPES
        {Tnormal},
    --STATS                         
        {
            --LEVEL 1                       
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level 
                {},
            --EXAMPLE LOADOUTS     
                {}
            },
            
            --LEVEL 2                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level 
                {},
            --EXAMPLE LOADOUTS  
                {}
            },
            --LEVEL 3                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level    
                {},
            --EXAMPLE LOADOUTS  
                {}
            },
            --LEVEL 4                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level   
                {},
            --EXAMPLE LOADOUTS             
                {}
            },
            --LEVEL 5                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level         
                {},
            --EXAMPLE LOADOUTS            
                {}
            },
            --LEVEL 6                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level        
                {},
            --EXAMPLE LOADOUTS            
                {}
            },
            --LEVEL 7                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {}
            },
            --LEVEL 8                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {}
            },
            --LEVEL 9                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {}
            },
        --LEVEL 10                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {}
            },
            --LEVEL 11
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 12
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 13
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 14
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 15
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 16
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 17
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 18
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 19
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 20
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 21
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 22
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 23
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 24
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 25
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 26
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 27
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 28
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 29
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 30
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 31
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 32
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 33
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 34
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 35
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 36
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 37
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 38
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 39
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 40
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 41
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 42
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 43
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 44
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 45
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 46
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 47
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 48
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 49
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 50
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 51
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 52
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 53
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 54
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 55
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 56
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 57
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 58
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 59
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 60
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 61
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 62
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 63
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 64
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 65
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 66
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 67
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 68
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 69
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 70
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 71
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 72
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 73
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 74
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 75
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 76
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 77
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 78
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 79
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 80
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 81
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 82
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 83
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 84
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 85
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 86
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 87
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 88
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 89
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 90
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 91
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 92
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 93
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 94
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 95
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 96
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 97
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 98
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 99
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 100
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        }
    },
    {
    --ID
        1,
    --NAME
        "Zephyr",
    --TYPES
        {Tnormal},
    --STATS                         
        {
            --LEVEL 1                       
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level 
                {},
            --EXAMPLE LOADOUTS     
                {}
            },
            
            --LEVEL 2                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level 
                {},
            --EXAMPLE LOADOUTS  
                {}
            },
            --LEVEL 3                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level    
                {},
            --EXAMPLE LOADOUTS  
                {}
            },
            --LEVEL 4                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level   
                {},
            --EXAMPLE LOADOUTS             
                {}
            },
            --LEVEL 5                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level         
                {},
            --EXAMPLE LOADOUTS            
                {}
            },
            --LEVEL 6                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level        
                {},
            --EXAMPLE LOADOUTS            
                {}
            },
            --LEVEL 7                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {}
            },
            --LEVEL 8                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {}
            },
            --LEVEL 9                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {}
            },
        --LEVEL 10                      
            {
            --stats inserted by inserter
                {},
            --Programmes Learnt this Level
                {},
            --EXAMPLE LOADOUTS
                {}
            },
            --LEVEL 11
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 12
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 13
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 14
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 15
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 16
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 17
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 18
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 19
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 20
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 21
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 22
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 23
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 24
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 25
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 26
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 27
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 28
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 29
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 30
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 31
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 32
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 33
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 34
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 35
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 36
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 37
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 38
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 39
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 40
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 41
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 42
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 43
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 44
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 45
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 46
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 47
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 48
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 49
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 50
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 51
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 52
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 53
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 54
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 55
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 56
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 57
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 58
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 59
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 60
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 61
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 62
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 63
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 64
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 65
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 66
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 67
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 68
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 69
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 70
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 71
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 72
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 73
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 74
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 75
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 76
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 77
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 78
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 79
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 80
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 81
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 82
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 83
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 84
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 85
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 86
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 87
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 88
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 89
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 90
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 91
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 92
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 93
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 94
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 95
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 96
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 97
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 98
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
            --LEVEL 99
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        --LEVEL 100
            {
                --stats inserted by inserter
                    {},
                --Programmes Learnt this Level
                    {},
                --EXAMPLE LOADOUTS
                    {}
            },
        }
    },
}


dbprog = 
    --DATABASE SECTIONS 
        --dbprog[1] is for Executable actions
        --dbprog[2] is for Gridranges
        --dbprog[3] is for Conditions
        --dbprog[4] is for Orderers
        --dbprog[5] is for Passives
        --dbprog[6] is for UpLoads
        --dbprog[7] is for Syntax
    {
        -- more syntax
            --EXECUTABLE ACTIONS upload at least 3 parts to an impulse -- Action -- Gridrange -- Condition
            -- dbprog[1] is for EXs classified as 1 = movement, 2 = Special, 3 = Attack
                -- Action dbprog[1][1,3][n]..
                --                          [1] = name
                --                          [2] = element
                --                          [3][m].. = Actions
                --                                [1] = action move/attack
                --                                [2] = number of times executed ==todo
                --                                [3] = "a" for absolute ranges, "r" for relative ranges,
                --                                [4] = [n] of x, y ranges that can be accepted.
                --                                [5] = ?
                --                                [6][n] list of attacks to be sent to the chosen range
                --                                      [1] type -- 1 = physical, 2 = special, 3 = hack
                --                                      [2] element
                --                                      [3] power 
                --                                  --for specials
                --                                          [1] statroom to inject to
                --                                          [2] the programme to inject
                --                                          [3] the status to be applied if necessary
                --                          [4][n].. = GRIDRANGE (If applicable)
                --                                [1] = "h" for hardlock = overrides any current gridranges, "s" = softlock, only injected if no griddranges are there.
                --                                [2] = "r" for randomly injected, "l" for left to right.
                --                                [3][n] x, y ranges to offer
                --                                [4][n] = "re" for relative ranges, "a" for absolute ranges.
                --                          [5][n].. = Conditions (If applicable)
                --                                [1] = "h" for hardlock = overrides any current gridranges, "s" = softlock, only injected if no griddranges are there.
                --                                [2][n] condition needed
                --                          [6] Programme size on the grid
                --                          [7] Cooldown, 0 means no cooldown initiated
            --                                                
        --
        {   --[1]Executables
            {   --Movement
                {
                    --ID  dbprog[1][1][1]
                    --Name
                    {"Wander", "Moves to a random empty tile."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {bgridmove, 1, "a", { {0, -1}, {1, 0}, {0, 1}, {-1, 0} }, 1, { } }
                    },
                    --GRIDRANGE
                    {"h", "r", { {0, -1}, {1, 0}, {0, 1}, {-1, 0} }, "a" },
                    --CONDITIONS
                    {"h", {1} },
                    --PROGSIZE
                    1,
                    --progroomkey
                    {},
                    --Cooldown
                    1,
                },
                {
                    --ID  dbprog[1][1][2]
                    --Name
                    {"Move", "Moves to a given adjacent tile."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {bgridmove, 1, "a", { {0, -1}, {1, 0}, {0, 1}, {-1, 0} }, 1, { } }
                    },
                    --GRIDRANGE
                    {"s", "r", {}, "a" },
                    --CONDITIONS
                    {"s", {} },
                    --PROGSIZE
                    1,
                    --progroomkey
                    {},
                    --Cooldown
                    1,
                },
                {
                    --ID  dbprog[1][1][3]
                    --Name
                    {"Wait", "Do nothing."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {bgridwait, 1, "a", { {0, 0} }, 1, { } } --==TODO== make wait function
                    },
                    --GRIDRANGE
                    {"h", "r", { {0, 0}}, "a" },
                    --CONDITIONS
                    {"s", {} },
                    --PROGSIZE
                    1,
                    --progroomkey
                    {},
                    --COOLDOWN
                    0,
                },
                {
                    --ID  dbprog[1][1][4]
                    --Name
                    {"Leap", "Moves the tile 2 in the direction facing, ignoring anything in between."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {bgridmove, 1, "re", { {2, 0}, }, 1, { } }
                    },
                    --GRIDRANGE
                    {"h", "r", { {2, 0}, }, "re" },
                    --CONDITIONS
                    {"h", {1} },
                    --PROGSIZE
                    1,
                    --progroomkey
                    {},
                    --Cooldown
                    2,
                },
                {
                    --ID  dbprog[1][1][5]
                    --Name
                    {"Blink", "Moves up to 3 tiles in any direction, ignoring anything in between."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {bgridmove, 1, "a", { {0, 1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {0, 0}, {2, 0}, {-2, 0}, {0, 2}, {0, -2}, {0, 3}, {3, 0}, {0, -3}, {-3, 0}, {2, 1}, {-2, 1}, {-2, -1}, {2, -1}, {1, 2}, {-1, 2}, {-1, -2}, {1, -2} }, 1, { } }
                    },
                    --GRIDRANGE
                    {"h", "r", { {0, 1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {0, 0}, {2, 0}, {-2, 0}, {0, 2}, {0, -2}, {0, 3}, {3, 0}, {0, -3}, {-3, 0}, {2, 1}, {-2, 1}, {-2, -1}, {2, -1}, {1, 2}, {-1, 2}, {-1, -2}, {1, -2} }, "re" },
                    --CONDITIONS
                    {"h", {1} },
                    --PROGSIZE
                    1,
                    --progroomkey
                    {},
                    --Cooldown
                    10,
                },
            },
            {   --Specials
                {
                    --ID  dbprog[1][2][1]
                    --Name
                    {"WindUp", "The next physical attack the virus make has 1.5x power."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {   --Dothis     --
                        {randominject, 1, "a", { {0, 0} }, 1, {3, {6, 1, 1}, 4} }
                    },
                    --GRIDRANGE
                    {"h", "r", { {0, 0}}, "a" },
                    --CONDITIONS
                    {"h", {"not", 4} },
                    --PROGSIZE
                    2,
                    --progroomkey
                    {},
                    --COOLDOWN
                    0, 
                },
                {
                    --ID  dbprog[1][2][1]
                    --Name
                    {"Reboot", "Recover 5% HP per turn until at 50% health or damaged. Take no actions until then."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {randominject, 1, "a", { {0, 0} }, 1, {1, {6, 1, 1}, 4} }
                    },
                    --GRIDRANGE
                    {"h", "r", { {0, 0}}, "a" },
                    --CONDITIONS
                    {"h", {5} },
                    --PROGSIZE
                    3,
                    --progroomkey
                    {},
                    --COOLDOWN
                    0, 
                },
            },
            {   --Attacks
                {
                    --ID  dbprog[1][3][1]
                    --Name
                    {"Attack", "80 Power - attack an adjacent tile range. If no range is given attacks the facing direction."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {bgridattack, 1, "a", { {0, -1}, {1, 0}, {0, 1}, {-1, 0}, {0, 0} }, 1, { {1, "BLUNT", 80 } } }
                    },
                    --GRIDRANGE
                    {"s", "r", { {1, 0} }, "re"},
                    --CONDITIONS
                    {"s", {"not", 3} },
                    --PROGSIZE
                    1,
                    --progroomkey
                    {},
                    --COOLDOWN
                    1
                },
                {
                    --ID  dbprog[1][3][2]
                    --Name
                    {"HeavyHit", "110 Power - attack an adjacent tile range. After use needs one turn to recharge. If no range is given attacks the facing direction."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {bgridattack, 1, "a", { {0, -1}, {1, 0}, {0, 1}, {-1, 0}, {0, 0} }, 2, { {1, "BLUNT", 110 } } }
                    },
                    --GRIDRANGE
                    {"s", "r", { {1, 0} }, "re"},
                    --CONDITIONS
                    {"s", {"not", 3} },
                    --SIZE
                    2,
                    --progroomkey
                    {},
                    --COOLDOWN
                    2,
                },
                {
                    --ID  dbprog[1][3][3]
                    --Name
                    {"Snipe", "100 Power - attack an adjacent tile range. After use needs one turn to recharge. If no range is given attacks the facing direction."},
                    --Statroom
                    {1, 2},
                    --ACTIONS
                    {
                        {bgridattack, 1, "a", { {0, 1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {0, 0}, {2, 0}, {-2, 0}, {0, 2}, {0, -2}, {0, 3}, {3, 0}, {0, -3}, {-3, 0}, {2, 1}, {-2, 1}, {-2, -1}, {2, -1}, {1, 2}, {-1, 2}, {-1, -2}, {1, -2} }, 2, { {1, "PIERCE", 100 } } }
                    },
                    --GRIDRANGE
                    {"s", "r", { {0, 1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {0, 0}, {2, 0}, {-2, 0}, {0, 2}, {0, -2}, {0, 3}, {3, 0}, {0, -3}, {-3, 0}, {2, 1}, {-2, 1}, {-2, -1}, {2, -1}, {1, 2}, {-1, 2}, {-1, -2}, {1, -2} }, "a"},
                    --CONDITIONS
                    {"s", {} },
                    --SIZE
                    2,
                    --progroomkey
                    {},
                    --COOLDOWN
                    4,
                }
            }
        },
        {   --[2]Ranges
            { --1Space
                {
                    --ID dbprog[2][1][1]
                    --Name
                    {"Forward", "The range in front of this virus."},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {1, 0} }, "a" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][1][2]
                    --Name
                    {"Self", "The range underneath this virus"},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {0, 0} }, "a" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][1][3]
                    --Name
                    {"Back", "The range behind this virus"},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {-1, 0} }, "a" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][1][4]
                    --Name
                    {"Up", "The range above this virus"},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {0, -1} }, "a" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][1][5]
                    --Name
                    {"Down", "The range below this virus"},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {0, 1} }, "a" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][1][6]
                    --Name
                    {"Facing", "The range that the virus is facing"},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {1, 0} }, "re" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][1][7]
                    --Name
                    {"Behind", "The range that the virus is facing away from"},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {-1, 0} }, "re" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][1][8]
                    --Name
                    {"Sides", "To range on either side of the virus"},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {0, 1}, {0, -1} }, "re" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
            },
            { --MultipleRanges
                {
                    --ID dbprog[2][2][1]
                    --Name
                    {"Distance_1", "Gives all ranges one tile away."},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {0, -1}, {1, 0}, {0, 1}, {-1, 0} }, "a" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    2,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][2][2]
                    --Name
                    {"Distance_2", "Gives all ranges two tiles away."},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {2, 0}, {1, 1}, {0, 2}, {-1, 1}, {-2, 0}, {-1, -1}, {0, -2}, {1, -1} }, "a" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    2,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][2][3]
                    --Name
                    {"OnMap", "Gives a range for every tile on the map."},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { "OnMap" }, "a" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    2,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][2][4]
                    --Name
                    {"3A ahead", "Gives all ranges three tiles ahead of the company in a line."},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"none", "r", { {1, 0}, {2, 0}, {3, 0} }, "re" },
                    --
                    {},
                    --
                    {},
                    --SIZE
                    3,
                    --progroomkey
                    {}
                },
            },
            { --SpecialRanges
                {
                    --ID dbprog[2][3][1]
                    --Name
                    {"Towards", "Takes in any range and outputs a range 1 tile towards it."},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"1towards"},
                    --
                    {},
                    --
                    {},
                    --SIZE
                    2,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[2][3][2]
                    --Name
                    {"Away", "Takes in any range and outputs a range 1 tile away from it."},
                    --Statroom
                    {1, 3},
                    --gridranges
                    {"1away"},
                    --
                    {},
                    --
                    {},
                    --SIZE
                    2,
                    --progroomkey
                    {}
                },
            },
        },
        {   --[3]Conditions
            {
                {
                    --ID dbprog[3][1][1]
                    --Name
                    {"CheckEnemy", "Accepts ranges with a Virus with a different Owner to this one."},
                    --Statroom
                    {1, 4},
                    --conditions
                    {2},
                    --blank
                    {},
                    --blank
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[3][1][2]
                    --Name
                    {"CheckFriendly", "Accepts any range with a Virus with the same Owner as this one."},
                    --Statroom
                    {1, 4},
                    --conditions
                    {3},
                    --blank
                    {},
                    --blank
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[3][1][3]
                    --Name
                    {"CheckWoundUp", "Accepts any range with a Virus with the 'WoundUp' status."},
                    --statroom
                    {1, 4},
                    --conditions
                    {4},
                    --blank
                    {},
                    --blank
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[3][1][3]
                    --Name
                    {"CheckEmpty", "Accepts any range with empty tiles"},
                    --statroom
                    {1, 4},
                    --conditions
                    {1},
                    --blank
                    {},
                    --blank
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[3][1][4]
                    --Name
                    {"CheckSub50%HP", "Accepts any range with a virus below 50%HP"},
                    --statroom
                    {1, 4},
                    --conditions
                    {5},
                    --blank
                    {},
                    --blank
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
                {
                    --ID dbprog[3][1][5]
                    --Name
                    {"CheckSub20%HP", "Accepts any range with a virus below 20%HP"},
                    --statroom
                    {1, 4},
                    --conditions
                    {6},
                    --blank
                    {},
                    --blank
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {}
                },
            }
        },
        {   --[4]Orderers
            {
                {
                    --ID  dbprog[4][1][1]
                    --Name
                    {"RANDOMISE", "50% chance to turn the impulse downward."},
                    --TYPE
                    {1, 5},
                    --selection    --"r" means that the change to do it is 1/n where n is the number of the same to the right + 1 -- s is split 1/2
                    "r",
                    --give to hb - "id" will make it go downwards
                    "id",
                    --
                    {},
                    --SIZE
                    1,
                    --progroomkey
                    {2}
                },
                {
                    --ID  dbprog[4][1][2]
                    --Name
                    {"ALTERNATE", "Turns an impulse downwards when active. Each turn, the activated one is one to the right"},
                    --TYPE
                    {1, 5},
                    --selection    --"a" means that
                    "r",
                    --give to hb - "id" will make it go downwards
                    "id",
                    --
                    {},
                    --Size
                    1,
                    --progroom
                    {1}
                }
            }
        },
        {   --[5]Passives
            {
                {
                --ID  dbprog[5][1][1]
                    --Name
                    {"ControlHub", "You can enter this in order to control the flow of impulses."},
                    --TYPE
                    {1, 6},
                    --type
                    {},
                    --blank
                    {},
                    --dothis [1] unused so far
                    {},
                    --Size
                    1,
                    --progroom
                    {}
                },
            }
        },
        {   --[6]Uploads
            {   --DO ON HBINTERACT
                {
                --ID  dbprog[6][1][1]
                    --Name
                    {"WoundUp", "1.5x physical damage stored by impulse."},
                    --TYPE
                    {7},
                    --type
                    {"friendly"},
                    --blank
                    {},
                    --dothis [1] unused so far
                    {"unwind", "undo", 4, "destroyme"},
                    --Size
                    1,
                    --progroom
                    {}
                },
            },
            {
                {
                    --ID  dbprog[6][2][1]
                    --Name
                    {"Rebooting", "Recovering 5% health every turn until up to 50%HP or damage is taken."},
                    --TYPE
                    {1, 7},
                    --type
                    {"friendly"},
                    --blank
                    {},
                    --dothis
                    {},
                    --Size
                    2,
                    --progroom
                    {4}
                },
            }
        },
        {   --[7]Syntax
            {
                {
                    --ID  dbprog[7][1][1]
                    --Name//Desc
                    {"NOT", "The next time a condition checks the loaded ranges it will accept anything that it would normally reject and reject anything it would normally accept."},
                    --TYPE
                    {1, 8},
                    --blank
                    {},
                    --blank
                    {},
                    --dothis
                    {"not"},
                    --Size
                    1,
                    --progroom
                    {1}
                }
            }
        }
    }
--Initialise battlegrid table
battlegrid = 
--battlegrid[n] is the nth battlegrid
{
    {
        --battlegrid[n][1] is the layout of the panels
        {
            --default battlegrid
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 1, 1, 0, 0, 0, 1, 1, 0},
            {0, 1, 1, 1, 0, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 0, 1, 1, 1, 0},
            {0, 1, 1, 0, 0, 0, 1, 1, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0}
        },
        --battkegrid[n][2] is the layout of the starting positions
        --battlegrid[n][2][1][1] is the {x, y} position of the first virus of the first player
        {
            {
                {2, 5, "r"},
                {2, 3, "r"}, 
                {2, 7, "r"},
                {2, 4, "r"},
                {2, 6, "r"}, 
            },
            {
                {8, 5, "l"},
                {8, 3, "l"},
                {8, 7, "l"},
                {8, 4, "l"},
                {8, 6, "l"}, 
            },
            {
                {5, 5, "d"}
            }
        }
    },
    {
        {
            --practice battlegrid
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0}
        },
        --battkegrid[n][2] is the layout of the starting positions
        --battlegrid[n][2][1][1] is the {x, y} position of the first virus of the first player
        {
            {
                {3, 5, "r"},
                {3, 7, "r"},
                {3, 3, "r"}
            },
            {
                {7, 5, "l"},
                {7, 7, "l"},
                {7, 3, "l"},
            },
            {
                {5, 2, "d"}
            }
        }
    }
}
--

--Initialise table of buttons
    -- functions called within buttons

    function loadstarter1(i)
        local startplayer = 
        
            {
                --player name
                {"Player"},
                {i, 8, 0}
            }
        
        player = {}
        
        insertplayer(startplayer)
    end

    function starterpick1()
        loadstarter1(1)
        stitchall()
        getdefaultprogs(false)
        for i =2, 4 do
            button[5][i][9] = 0
        end
        button[5][5][9] = 1
        button[5][5][10] = 1
        button[5][5][8] = gamestarttext[4][1]
        button[5][6][9] = 1
        button[5][6][10] = 1
        button[5][6][8] = gamestarttext[4][2]
        button[5][1][8] = gamestarttext[2][6]
    end

    function starterpick2()
        loadstarter1(2)
        stitchall()
        getdefaultprogs(false)
        for i =2, 4 do
            button[5][i][9] = 0
        end
        button[5][5][9] = 1
        button[5][5][10] = 2
        button[5][5][8] = gamestarttext[4][1]
        button[5][6][9] = 1
        button[5][6][10] = 2
        button[5][6][8] = gamestarttext[4][2]
        button[5][1][8] = gamestarttext[2][6]
    end

    function starterpick3()
        loadstarter1(3)
        stitchall()
        getdefaultprogs(false)
        for i =2, 4 do
            button[5][i][9] = 0
        end
        button[5][5][9] = 1
        button[5][5][10] = 3
        button[5][5][8] = gamestarttext[4][1]
        button[5][6][9] = 1
        button[5][6][10] = 3
        button[5][6][8] = gamestarttext[4][2]
        button[5][1][8] = gamestarttext[2][6]
    end

    function micropackpick()
        local pack = { {1, 1, 2}, {1, 3, 1}, {2, 1, 1}, {2, 1, 3}, {2, 1, 4}, {2, 1, 5}, {1, 1, 3}, {5, 1, 1} }
        for i = 1, table.getn(pack) do
            table.insert(player[1][1][1][15][1], pack[i])
        end
        if button[5][6][10] == 1 then
            loadgame("houndmicrostart")
        elseif button[5][6][10] == 2 then
            loadgame("golemmicrostart")
        elseif button[5][6][10] == 3 then
            loadgame("zephyrmicrostart")
        end
        gamestate = 2
        
    end

    function macropackpick()
        local pack = { {2, 2, 3}, {3, 1, 1}, {2, 3, 1}, {1, 1, 2}, {2, 2, 1}, {1, 3, 1} }
        for i = 1, table.getn(pack) do
            table.insert(player[1][1][1][15][1], pack[i])
        end
        if button[5][6][10] == 1 then
            loadgame("houndmacrostart")
        elseif button[5][6][10] == 2 then
            loadgame("golemmacrostart")
        elseif button[5][6][10] == 3 then
            loadgame("zephyrmacrostart")
        end
        gamestate = 2
    end

    function starttextincrement()
        button[5][1][8] = gamestarttext[2][button[5][1][10]]
        if button[5][1][10] == 5 then
            button[5][1][4] = WINDOW_HEIGHT/4
            for i =2, 4 do
                button[5][i][9] = 1
                button[5][i][10] = 2
                button[5][i][8] = gamestarttext[3][i - 1]
            end
            
        else
            button[5][1][10] = button[5][1][10] + 1
        end
    end

    function leavemainmenu()
        --goes to shipview
        local totalplayers = table.getn(player)
        --for each player thats been chosen, load them properly and remove duplicates, then move to shipview.
        for i = 1, totalplayers do
            insertplayer(player[i])
            player[i] = player[1 + totalplayers]
            table.remove(player, totalplayers + 1)
        end
        stitchall()
        getdefaultprogs(true)
        gamestate = 2
    end

    function mmplayervirus()
        --Selection of player virus, initialises the player if selected and coordinates the up/down buttons and gateways proceeding to shipview and opponent virus.
        if player[1] == nil then 
            player[1] = {
                {"player"}
            }
            button[1][11][9] = 0
        end
        if button[1][3][10] == "none" then
            button[1][3][8] = dbvirus[1][2]..":    "..dbvirus[1][1]
            button[1][5][9] = 1
            button[1][3][10] = 1
        else
            button[1][3][9] = 0
            button[1][9][9] = 1
            button[1][5][9] = 1
            button[1][4][9] = 0
            button[1][9][10] = 1
            button[1][9][8] = "LEVEL"..":\n"..button[1][9][10]
        end
    end

    function mmquickstart()
        --Loads in the below viruses for the below players and heads to shipview
        local pinit = 
        {
            {
                --player name
                {"player"},
                {1, 1, 0}
                
            },
            {
                {"rogue virus"},
                {1, 1, 0},
                {1, 2, 0}
            },
            {
                {"James=MrNotCool"},
                {1, 2, 0}
            }
        }
        
        player = {}
        for i= 1,table.getn(pinit) do
            insertplayer(pinit[i])
        end
        stitchall()
        getdefaultprogs(true)
        
        gamestate = 2
        
    end

    function mmopponentvirus()
        --Loads viruses for player 2, like above.
        if player[2] == nil then 
            player[2] = {
                {"Rogue Virus"}
            }
        end
        if button[1][6][10] == "none" then
            button[1][6][8] = dbvirus[1][2]..":    "..dbvirus[1][1]
            button[1][8][9] = 1
            button[1][6][10] = 1
        else
            button[1][6][9] = 0
            button[1][10][9] = 1
            button[1][8][9] = 1
            button[1][7][9] = 0
            button[1][10][10] = 1
            button[1][10][8] = "LEVEL"..":\n"..button[1][10][10]
        end
    end

    function mmpvincrease()
        --Increments player values depending on the buttons active. Shuts down when at max.
        if button[1][3][9] == 1 then
            if button[1][3][10] == 1 then
                button[1][4][9] = 1
            end
            button[1][3][10] = button[1][3][10] + 1
            if button[1][3][10] == table.getn(dbvirus) then
                button[1][5][9] = 0
            end
            button[1][3][8] = dbvirus[button[1][3][10]][2]..":\n"..dbvirus[button[1][3][10]][1]
        else
            if button[1][9][10] == 1 then
                button[1][4][9] = 1
            end
            button[1][9][10] = button[1][9][10] + 1
            if button[1][9][10] == 100 then
                button[1][5][9] = 0
            end
            button[1][9][8] = "LEVEL"..":\n"..button[1][9][10]
        end
    end

    function mmovincrease()
        --Increments opponent values depending on the buttons active. Shuts down when at max.
        if button[1][6][9] == 1 then
            if button[1][6][10] == 1 then
                button[1][7][9] = 1
            end
            button[1][6][10] = button[1][6][10] + 1
            if button[1][6][10] == table.getn(dbvirus) then
                button[1][8][9] = 0
            end
            button[1][6][8] = dbvirus[button[1][6][10]][2]..":\n"..dbvirus[button[1][6][10]][1]
        else
            if button[1][10][10] == 1 then
                button[1][7][9] = 1
            end
            button[1][10][10] = button[1][10][10] + 1
            if button[1][10][10] == 100 then
                button[1][8][9] = 0
            end
            button[1][10][8] = "LEVEL"..":\n"..button[1][10][10]
        end
    end

    function mmpvdecrease()
        if button[1][3][9] == 1 then
            if button[1][3][10] == table.getn(dbvirus) then
                button[1][5][9] = 1
            end
            button[1][3][10] = button[1][3][10] - 1
            if button[1][3][10] == 1 then
                button[1][4][9] = 0
            end
            button[1][3][8] = dbvirus[button[1][3][10]][2]..":\n"..dbvirus[button[1][3][10]][1]
        else
            if button[1][9][10] == 100 then
                button[1][5][9] = 1
            end
            button[1][9][10] = button[1][9][10] - 1
            if button[1][9][10] == 1 then
                button[1][4][9] = 0
            end
            button[1][9][8] = "LEVEL"..":\n"..button[1][9][10]
        end
    end

    function mmovdecrease()
        --Decreases opponent values depending on the buttons active. Shuts down when at 1.
        if button[1][6][9] == 1 then
            if button[1][6][10] == table.getn(dbvirus) then
                button[1][8][9] = 1
            end
            button[1][6][10] = button[1][6][10] - 1
            if button[1][6][10] == 1 then
                button[1][7][9] = 0
            end
            button[1][6][8] = dbvirus[button[1][6][10]][2]..":\n"..dbvirus[button[1][6][10]][1]
        else
            if button[1][10][10] == 100 then
                button[1][8][9] = 1
            end
            button[1][10][10] = button[1][10][10] - 1
            if button[1][10][10] == 1 then
                button[1][7][9] = 0
            end
            button[1][10][8] = "LEVEL"..":\n"..button[1][10][10]
        end
    end

    function mmplayervlevel()
        --Takes over from virus select, adds the chosen virus at the chosen level to the player and allows to leave main menu.
        local virusid = button[1][3][10]
        local viruslvl = button[1][9][10]
        local tablet = {virusid, viruslvl, 0}
        table.insert(player[1], tablet)
        button[1][9][9] = 0
        button[1][3][9] = 1
        button[1][3][8] = "Player:\nadd virus"
        button[1][3][10] = "none"
        button[1][4][9] = 0
        button[1][5][9] = 0
        button[1][2][9] = 1
        button[1][6][9] = 1
    end

    function mmopponentvlevel()
        --Takes over from virus select, adds the chosen virus at the chosen level to the opponent.
        local virusid = button[1][6][10]
        local viruslvl = button[1][10][10]
        local tablet = {virusid, viruslvl, 0}
        table.insert(player[2], tablet)
        button[1][10][9] = 0
        button[1][6][9] = 1
        button[1][6][8] = "Player:\nadd virus"
        button[1][6][10] = "none"
        button[1][7][9] = 0
        button[1][8][9] = 0
        button[1][2][9] = 1
    end

    function leaveshipview()
        --Loads up the current battlegrid and moves to it.
        activegrid = 2
        if player[2] == nil then
            player[2] = {}
        end
        if player[2][1] == nil then
            player[2][1] = {}
            player[2][2] = {}
            player[2][4] = {}
            player[2][6] = {}
            player[2][6][1] = { {0.25, 0.25}, {0.25, 0.25}, {1, 1}, {1, 1}, {1, 1}, {1, 1}, {1, 1}, {1, 1} }
        end
        if player[2][1][1] == nil then

            loadrandomai(2, 1, love.math.random(10), 1)
        end
        battlegridvirusload()
        amendvirusimpstart()
        gamestate = 3
        turninit()
    end

    function hbcontrol()
        if  button[3][1][10] == 0 then
            button[3][1][10] = 1
        else
            button[3][1][10] = 0
        end
    end

    function timecontrol()
        if  button[3][4][10] == 0 then
            button[3][4][10] = 1
        else
            button[3][4][10] = 0
        end
    end

    function hbincrement()
        for i = 1, table.getn(turn[2]) do
            heartbeat(turn[2][i][2], turn[2][i][3])
        end
    end

    function timeincrement()
        timeplus()
    end

    function statroomincrease()
        --Alters the statroom displayed -- if you've just clicked increase
        if button[2][2][9] == 1 then --if statdraw is visible then
            if button[2][2][10] == 9 then --if its at "all rooms"
                button[2][3][9] = 1 --draw the decrease button
            end

            local progtypetext = {"All Chips", ".EXE Actions", "Gridranges", "Conditions", "Orderers", "Passives", "Uploads", "Syntax", "..."}
                
            if button[2][2][10] == 9 then 
                button[2][2][10] = 1
            else
                button[2][2][10] = button[2][2][10] + 1 --increase the room level
            end

            if button[2][2][10] == 8 then -- if its at "all rooms"
                button[2][4][9] = 0 --unshow the increase button 
            end
            button[2][2][8] = progtypetext[button[2][2][10]] -- set the text to the stat
        end
    end

    function statroomdecrease()
        --Alters the statroom displayed --if you've pressed decrease

        if button[2][2][9] == 1 then -- if the statroom main box is showing
            if button[2][2][10] == 8 then --if its at the top
                button[2][4][9] = 1 --draw the increase button
            end

            if button[2][2][10] == 1 then 
                button[2][2][10] = 9 
            else
                button[2][2][10] = button[2][2][10] - 1 --decrease the room level
            end

            if button[2][2][10] == 9 then --if you're at the bottom level
                button[2][3][9] = 0 --don't draw decrease
                button[2][2][8] = "None" -- set the text to be "All Rooms"
            else --otherwise
                local progtypetext = {"All Chips", ".EXE Actions", "Gridranges", "Conditions", "Orderers", "Passives", "Uploads", "Syntax", "..."}
                button[2][2][8] = progtypetext[button[2][2][10]] -- set the text to the stat
            end
        end
    end

    function hbplantint()
        impulsetrigger(viewplayer, viewvirus, 1, {0, nil, nil, nil, nil})
    end

    function loadrandomaiforlevel()
        player[viewplayer][3] = loadrandomai(viewplayer, viewvirus, player[viewplayer][1][viewvirus][2], player[viewplayer][1][viewvirus][1])
    end
--



button = {
    -- Buttons on the main menu --- button[1][n] is the nth button
    -- the layout takes the form 1: x start, 2: y start, 3:  width, 4:  height, 5: color for colorselect, 6: colorstrength, 7: {lclick function, rclick function, wheel function}, 8: text, 9: is visible 1=yes 0=no, 10: not existing normally but set to values for the button to remember.
    {
        {WINDOW_WIDTH / 2 - 50, 10, 100, 100, 9, 0.1, {0, 0, 0}, "none", 1},
        {WINDOW_WIDTH / 2 - 50, 10, 100, 100, 9, 0.8, {leavemainmenu, 0, 0}, "Proceed to shipview", 0},
        {45, 10, 50, 50, 5, 1.4, {mmplayervirus, 0, 0}, "Player:\nadd virus", 1, "none"},
        {15, 20, 20, 20, 5, 1.0, {mmpvdecrease, 0, 0}, "none", 0},
        {105, 20, 20, 20, 5, 1.8, {mmpvincrease, 0, 0}, "none", 0},
        {WINDOW_WIDTH - 95, 10, 50, 50, 8, 1.4, {mmopponentvirus, 0, 0}, "Opponent:\nadd virus", 0, "none"},
        {WINDOW_WIDTH - 125, 20, 20, 20, 8, 1.0, {mmovdecrease, 0, 0}, "none", 0},
        {WINDOW_WIDTH - 35, 20, 20, 20, 8, 1.8, {mmovincrease, 0, 0}, "none", 0},
        {45, 10, 50, 50, 5, 1.4, {mmplayervlevel, 0, 0}, "jefrk", 0},
        {WINDOW_WIDTH - 95, 10, 50, 50, 8, 1.4, {mmopponentvlevel, 0, 0}, "jderk", 0},
        {WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT - 110, 100, 100, 9, 0.8, {mmquickstart, 0, 0}, "QUICKSTART", 1},
    },
    -- Buttons for the shipview gamestate
    {
        {WINDOW_WIDTH / 2 - 50, 10, 100, 100, 9, 0.8, {leaveshipview, 0, 0}, "Proceed to battlegrid", 1},
        {WINDOW_WIDTH - 125, 10, 50, 50, 8, 1.4, {0, 0, 0}, "All Chips", 1, 1},
        {WINDOW_WIDTH - 155, 20, 20, 20, 8, 1.0, {statroomdecrease, 0, 0}, "none", 1},
        {WINDOW_WIDTH - 65, 20, 20, 20, 8, 1.8, {statroomincrease, 0, 0}, "none", 1},
    },
    --Buttons for the battlegrid gamestate
    {
        {WINDOW_WIDTH/2 - 40, WINDOW_HEIGHT - 30, 25, 25, 9, 0.7, {hbcontrol, 0, 0}, "I", 1, 1},
        {WINDOW_WIDTH/2, WINDOW_HEIGHT - 30, 25, 25, 9, 0.7, {hbincrement, 0, 0}, "+", 1},
        {WINDOW_WIDTH/2 + 40, WINDOW_HEIGHT - 30, 25, 25, 9, 0.7, {hbplantint, 0, 0}, "hb", 1},
        {WINDOW_WIDTH/2 + 80, WINDOW_HEIGHT - 30, 25, 25, 9, 0.7, {timecontrol, 0, 0}, "time", 1, 1},
        {WINDOW_WIDTH/2 + 120, WINDOW_HEIGHT - 30, 25, 25, 9, 0.7, {timeincrement, 0, 0}, "time+", 1}
    },
    {

    },
    {
        {WINDOW_WIDTH/16, WINDOW_HEIGHT/8, 7 * WINDOW_WIDTH/8, 3 * WINDOW_HEIGHT/4, 9, 0.7, {starttextincrement, 0, 0}, "Start", 1, 1},
        {3 * WINDOW_WIDTH/32, WINDOW_HEIGHT/2, WINDOW_WIDTH/4, WINDOW_HEIGHT/4 + WINDOW_HEIGHT/8, 9, 1.0, {starterpick1, 0, 0}, "Placeholder", 0, 1},
        {12 * WINDOW_WIDTH/32, WINDOW_HEIGHT/2, WINDOW_WIDTH/4, WINDOW_HEIGHT/4 + WINDOW_HEIGHT/8, 9, 1.0, {starterpick2, 0, 0}, "Placeholder", 0, 2},
        {21 * WINDOW_WIDTH/32, WINDOW_HEIGHT/2, WINDOW_WIDTH/4, WINDOW_HEIGHT/4 + WINDOW_HEIGHT/8, 9, 1.0, {starterpick3, 0, 0}, "Placeholder", 0, 3},
        {3 * WINDOW_WIDTH/32, WINDOW_HEIGHT/2, WINDOW_WIDTH/3, WINDOW_HEIGHT/4 - WINDOW_HEIGHT/16, 9, 1.0, {micropackpick, 0, 0}, "Placeholder", 0, 1},
        {21 * WINDOW_WIDTH/32 + WINDOW_WIDTH/4 - WINDOW_WIDTH/3, WINDOW_HEIGHT/2, WINDOW_WIDTH/3, WINDOW_HEIGHT/4 - WINDOW_HEIGHT/16, 9, 1.0, {macropackpick, 0, 0}, "Placeholder", 0, 3},
    },
}

dbprogroom = {
    alternate, -- 1
    randomise, --2 
    deactivate, --3
    reboot, --4
}

dbconditions = {
    checkempty, --1
    checkenemy, --2
    checkfriendly, --3
    checkwoundup, --4
    checksub50hp, --5
    checksub20hp, --6
}

dbprogstats = {
    {
        542, 303, 388, 359, 276, 299, 324, 440
    },
    {
        236, 303, 542, 480, 304, 408, 159, 499
    },
    {
        388, 632, 303, 256, 440, 344, 409, 159
    },
}

gamestarttext = {
    {0},
    { --[2]--Starting Text
        {
            "You awaken in the ruins of a facility. A desperate defence was fought here. You hear a tinny voice over distant speakers, the words awaken broken memories."
        },
        {
            "A microchip. A ravenous virus. A city fallen. A void."
        },
        {
            "Your head splits in pain as you try to recollect more, suddenly the speaker blares to life again, this time from the room you are in. 'PROTOCOL 1418: VIRAL LOAD EXCEEDED: PILOT CELLS SCRAMBLE' You look around as the voice bounces off of empty walls and debris, a few withered husks in pilot clothes are strewn around, but otherwise the hangers stand empty. Any fighting here ceased long ago."
        },
        {
            "Still, you found yourself drawn to the end of the hangars, and in the final stalls three craft sit, seemingly pristene despite the chaos around them. Somehow the craft seem familiar, and some sense of duty resonates dully within you, to take one of these and revenge the fallen."
        },
        {
            "Overriding the Security Protocols that spring to life as you enter the hangars, you inspect the three remeaining craft."
        },
        {
            "As you board your chosen craft, you are prompted to choose an installation style."
        }
    },
    {   --[3]--Description of starting ship.
        {
            "Hound\nLevel 5\n\n\nComplexity:beginner.\n\n'Reliable and Efficient, the 'Hound' ubiquitous, relying on their lack of weak stats and strong Intelligence to outpace and outlast competitors.'"
        },
        {
            "Golem\nLevel 5\n\n\nComplexity:Intermediate.\n\n'The 'Golem' seems as ancient as c-space itself, straightforwardly relying on Strength and Toughness and with a high Will, the 'Golem' design has seen little need to change or adapt.'"
        },
        {
            "Zephyr\nLevel 5\n\n\nComplexity:Intermediate.\n\n Chasing 'Zephrys' means to do the impossible. The Zephyr has unparralelled speed with which it can move across c-space at high speeds."
        },
    },
    {   --[4]--Descriptions of the starting packs
        {
            "MicroManagement Pack\n\nContains Chips: Forward, Up, Backward, Down, Move, Attack, Hijack, Keybound, Wait, Manual_Release\n\n Streamlines Manual control of the Company during battle."
        },
        {
            "MacroManagement Pack\n\nContains Chips: OnMap, Towards, EnemyUnit, Move, Attack, Distance1, Hijack, RestructureB x1\n\n Streamlines Automatic control of the Company during battle."
        },
    }
}