
zombies = {
            {
            -- front
            },
            -- front stop
            {
            },
            -- right
            {
            },
            -- right stop
            {
	    }
            -- left
            {
            },
            -- left stop
            {
            },
            -- die
            {
            }
            }
fail = 
baloon = 
counter = 0

Screen = class()
theScreen = nil
function Screen:init(w, h)
    self.width = w
    self.height = h
end

Zombie = class()
theZombies = nil
GAME_NUM_ZOMBIES = 5
baloonImage = image.new(baloon)
ZOMBIE_STATE_INIT = 0
ZOMBIE_STATE_MOVE_FRONT  = 1
ZOMBIE_STATE_MOVE_FRONT_STOP  = 2
ZOMBIE_STATE_MOVE_RIGHT = 3
ZOMBIE_STATE_MOVE_RIGHT_STOP = 4
ZOMBIE_STATE_MOVE_LEFT  = 5
ZOMBIE_STATE_MOVE_LEFT_STOP  = 6
ZOMBIE_STATE_DIE  = 7
ZOMBIE_NUM_STATES  = 7

ZOMBIE_BALOON_X_OFFSET = 14
ZOMBIE_BALOON_Y_OFFSET = -35
ZOMBIE_TEXT_X_OFFSET = 20
ZOMBIE_TEXT_Y_OFFSET = -15
ZOMBIE_DIRECTION_CHANGE_PROBABILITY = 0.05

function Zombie:init()
    self.state = ZOMBIE_STATE_INIT
    self.nextState = -1
    self.x = math.floor(math.random()*(theScreen.width-120))
    self.y = math.floor(math.random()*(theScreen.height-120)) + 50
    self.a = math.floor(math.random()*50)
    self.b = math.floor(math.random()*50)
    self.c = self.a + self.b
    self.tempc = '?'
    self.life = 0
    self.numFrames = 0
    self.counter = 0
    if math.random()>0.5 then
        self:changeState(ZOMBIE_STATE_MOVE_RIGHT)
    else
        self:changeState(ZOMBIE_STATE_MOVE_LEFT)
    end
end

function Zombie:reset()
    self.state = ZOMBIE_STATE_INIT
    self.nextState = -1
    self.x = math.floor(math.random()*(theScreen.width-120))
    self.y = math.floor(math.random()*(theScreen.height-120)) + 50
    self.a = math.floor(math.random()*50)
    self.b = math.floor(math.random()*50)
    self.c = self.a + self.b
    self.tempc = '?'
    self.life = 0
    self.numFrames = 0
    self.counter = 0
    if math.random()>0.5 then
        self:changeState(ZOMBIE_STATE_MOVE_RIGHT)
    else
        self:changeState(ZOMBIE_STATE_MOVE_LEFT)
    end
end

function Zombie:changeNextState(next_state)
--    print ("setting up nextState="..next_state)
    if self.nextState ~= ZOMBIE_STATE_DIE or next_state == ZOMBIE_STATE_INIT then
        self.nextState = next_state
    end
end

function Zombie:changeState(state)
    if state == ZOMBIE_STATE_MOVE_FRONT then
        self.numFrames = 7
        self:changeNextState(-1)
    elseif state == ZOMBIE_STATE_MOVE_FRONT_STOP then
        self.numFrames = 5
        self:changeNextState(ZOMBIE_STATE_MOVE_FRONT)
    elseif state == ZOMBIE_STATE_MOVE_RIGHT then
        self.numFrames = 7
        self:changeNextState(-1)
    elseif state == ZOMBIE_STATE_MOVE_RIGHT_STOP then
        self.numFrames = 6
        self:changeNextState(ZOMBIE_STATE_MOVE_RIGHT)
    elseif state == ZOMBIE_STATE_MOVE_LEFT then
        self.numFrames = 7
        self:changeNextState(-1)
    elseif state == ZOMBIE_STATE_MOVE_LEFT_STOP then
        self.numFrames = 5
        self:changeNextState(ZOMBIE_STATE_MOVE_LEFT)
    elseif state == ZOMBIE_STATE_DIE then
        self.numFrames = 10
        self:changeNextState(ZOMBIE_STATE_INIT)
    end
    self.state = state
end

function Zombie:update()
    self.counter = self.counter + 1
    self.life = self.life + 1
    counterAtLimit = self.counter >= (self.numFrames-1)
    if counterAtLimit  then
        if self.nextState ~= -1 then
            self:changeState (self.nextState)
            counterAtLimit = false
        end
        self.counter = 0
    end
    if self.state == ZOMBIE_STATE_MOVE_RIGHT then
        if (self.x + 120)> theScreen.width or math.random() < ZOMBIE_DIRECTION_CHANGE_PROBABILITY then
            self:changeNextState(ZOMBIE_STATE_MOVE_LEFT)
        elseif math.random() < ZOMBIE_DIRECTION_CHANGE_PROBABILITY then
            self:changeNextState(ZOMBIE_STATE_MOVE_RIGHT_STOP)
        else
            self.x = self.x + 4
        end
    elseif self.state == ZOMBIE_STATE_MOVE_LEFT then
        if (self.x - 4) < 0 or math.random() < ZOMBIE_DIRECTION_CHANGE_PROBABILITY then
           self:changeNextState(ZOMBIE_STATE_MOVE_RIGHT)  
       elseif math.random() < ZOMBIE_DIRECTION_CHANGE_PROBABILITY then
            self:changeNextState(ZOMBIE_STATE_MOVE_LEFT_STOP)
        else
            self.x = self.x - 4
        end
    elseif self.state == ZOMBIE_STATE_MOVE_FRONT then
        if (self.y) > (theScreen.height-120) or math.random() < 0.001 then
           self:changeNextState(ZOMBIE_STATE_MOVE_RIGHT)  
       elseif math.random() < 0.3 then
            self:changeNextState(ZOMBIE_STATE_MOVE_FRONT_STOP)
        else
            self.y = self.y + 3
        end
    elseif self.state == ZOMBIE_STATE_INIT then
        self:reset()
    elseif self.life > 300 then
        self.life = -1000
        self:changeNextState(ZOMBIE_STATE_DIE)
    end
end

function Zombie:paint(gc)
    if self.state ~= ZOMBIE_STATE_INIT then
 --       print ("state="..self.state..", counter="..self.counter)
        gc:drawImage(zombieImages[self.state][self.counter+1], self.x, self.y)
        gc:drawImage(baloonImage, self.x+ZOMBIE_BALOON_X_OFFSET, self.y+ZOMBIE_BALOON_Y_OFFSET)
        gc:drawString(""..self.a.."+"..self.b.."="..self.tempc, self.x+ZOMBIE_TEXT_X_OFFSET, self.y+ZOMBIE_TEXT_Y_OFFSET)
    end
end

function Zombie:receiveChar(c)
--    print ("self.c="..self.c.." self.tc="..self.tempc.." c="..c)
    if self.state ~= ZOMBIE_STATE_DIE and self.state ~= ZOMBIE_STATE_INIT then
        if self.tempc == '?' and math.floor(self.c/10) == c then
            self.tempc = c
            self:changeNextState(ZOMBIE_STATE_MOVE_FRONT)
            return 1
        elseif tonumber(self.tempc) ~= nil and (self.c - tonumber(self.tempc)*10) == c then
     --       print("die!!!")
            self.tempc = self.c
            self:changeNextState(ZOMBIE_STATE_DIE)
            return 10
        end
    end
    return 0
end
backgroundImage =nil
function on.construction()
    backgroundImage = image.new(background)
    theScreen = Screen( platform.window:width(),  platform.window:height())
    theZombies = {}
	for i = 1, GAME_NUM_ZOMBIES do
		theZombies[i] = Zombie()
	end
    zombieImages = {}
    for i = 1, ZOMBIE_NUM_STATES do
        zombieImages[i] = {}
        for j in pairs(zombies[i]) do
            zombieImages[i][j] = image.new(zombies[i][j])
        end
    end
    timer.start(0.33)
end

function on.timer()
    counter = counter + 1
	for i = 1, GAME_NUM_ZOMBIES do
		if theZombies[i] ~= nil then
			theZombies[i]:update()
		end
	end
	platform.window:invalidate()
end

function on.paint(gc)
    gc:drawImage(backgroundImage, 0, 0)
	for i = 1, GAME_NUM_ZOMBIES do
		if theZombies[i] ~= nil then
	--        gc:drawString("Hello World!",10,200,"top")
			theZombies[i]:paint(gc)
		end
	end
end

function on.charIn(c)
--    print("received:"..c)
    for i = 1, GAME_NUM_ZOMBIES do
		if theZombies[i] ~= nil and tonumber(c) ~= nil  then
			if theZombies[i]:receiveChar(tonumber(c)) > 0 then
			    tempZombie = theZombies[1]
			    theZombies[1] = theZombies[i]
			    theZombies[i] = tempZombie
			    break
			end
		end
	end
	if c == 'r' then
        for i = 1, GAME_NUM_ZOMBIES do
            if theZombies[i] ~= nil then
                theZombies[i]:reset()
            end
        end
	end
end

function on.resize(w, h)
    print ("resize w="..w.." h="..h)
    theScreen.width = w
    theScreen.height = h
    for i = 1, GAME_NUM_ZOMBIES do
        if theZombies[i] ~= nil then
            theZombies[i]:reset()
        end
    end
end
