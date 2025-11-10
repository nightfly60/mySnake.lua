#!/usr/bin/env lua

-- config
local width = 30
local height = 15
local snake = {{x = 5, y = 5}, {x = 4, y = 5}, {x = 3, y = 5}}
local direction = {x = 1, y = 0}
local food = {x = 15, y = 8}
local gameOver = false
local score = 0

local inputFile = "/tmp/snake_input.txt" -- fichier temporaire pour les touches

-- effacer l'ecran
local function clearScreen()
	os.execute("clear")
end

-- générer un nouveau point de nourriture sur la map
local function generateFood()
	local valid = false
	while not valid do
		food.x = math.random(1, width)
		food.y = math.random(1, height)
		valid = true
		for _, segment in ipairs(snake) do
			if segment.x == food.x and segment.y == food.y then
				valid = false
				break
			end
		end
	end
end

-- dessiner le jeu
local function drawGame()
	clearScreen()

	print("+" .. string.rep("-", width) .. "+")

	for y = 1, height do
		local line = "|"
		for x = 1, width do
			local isSnake = false
			local isHead = false
			
			for i, segment in ipairs(snake) do
				if segment.x == x and segment.y == y then
					isSnake = true
					if i == 1 then isHead = true end
					break
				end
			end

			if isHead then
				line = line .. "@"
			elseif isSnake then
				line = line .. "o"
			elseif food.x == x and food.y == y then
				line = line .. "*"
			else
				line = line .. " "
			end
		end
		line = line .. "|"
		print(line)
	end

	print("+" .. string.rep("-", width) .. "+")
	print(string.format("Score: %d | Length: %d", score, #snake)) 
	print("Keys: ↑ : UP | ↓ : DOWN | ← : LEFT | → : RIGHT | ESC : QUIT -> Press ENTER to confirm")
	io.write("Your choice: ")
	io.flush()
end

local function updateGame()
	local newHead = {
		x = snake[1].x + direction.x,
		y = snake[1].y + direction.y
	}

	-- collisions
	if newHead.x < 1 or newHead.x > width or newHead.y < 1 or newHead.y > height then
		gameOver = true
		return
	end

	for _, segment in ipairs(snake) do
		if segment.x == newHead.x and segment.y == newHead.y then
			gameOver = true
			return
		end
	end

	-- ajouter une nouvelle tete
	table.insert(snake, 1, newHead)

	if newHead.x == food.x and newHead.y == food.y then
		score = score + 10
		generateFood()
	else
		table.remove(snake)
	end
end

math.randomseed(os.time())
os.execute("rm -f " .. inputFile)

clearScreen()
print("╔═══════════════════════════════════════╗")
print("║                                       ║")
print("║           🐍 SNAKE GAME 🐍            ║")
print("║                                       ║")
print("╚═══════════════════════════════════════╝")
print()
print("Keys:")
print("  - W : UP")
print("  - S : DOWN")
print("  - A : LEFT")
print("  - D : RIGHT")
print("  - Q : QUIT")
print()
print("Eat the stars ★ and grow !")
print()
print("Press ENTER to start the game...")
io.read()

while not gameOver do
	drawGame()

	local input = io.read()
	if input then
		input = input:lower():sub(1, 1)

		if input == "w" then
			if direction.y == 0 then direction = {x = 0, y = -1} end
		elseif input == "s" then
			if direction.y == 0 then direction = {x = 0, y = 1} end
		elseif input == "a" then
			if direction.x == 0 then direction = {x = -1, y = 0} end
		elseif input == "d" then
			if direction.x == 0 then direction = {x = 1, y = 0} end
		elseif input == "q" then
			gameOver = true
		end
	end

	if not gameOver then
		updateGame()
	end
end

clearScreen()
print("╔═══════════════════════════════════════╗")
print("║                                       ║")
print("║            💀 GAME OVER 💀            ║")
print("║                                       ║")
print("╚═══════════════════════════════════════╝")
print()
print("📊 Final score: " .. score)
print("📏 Final length: " .. #snake)
print()
print("Thanks for playing ! 🎮")
print()
