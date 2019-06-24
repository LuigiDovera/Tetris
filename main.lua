
blocks = {img ={i=nil, l=nil, j=nil, o=nil, z=nil, s=nil, t=nil}}


-- Inicializando a matriz principal que armazenará a informação dos blocos
	matriz = {}
	for i=1, 11 do
		matriz[i] = {}
		for j=1, 7 do
			matriz[i][j] = nil
		end
	end

--Bloco do jogador
	--O objeto guardará a posição atual do bloco 'jogável' do player
	--A posição se dá pelos indices do bloco na matriz
	player = {mX = 4, mY = 1, shape = nil}
	
--timers
	--timer para a movimentação vertical do blocos
		fallTimerMax = 1
		fallTimer = fallTimerMax
	--timer para restringir as ações do jogador, evitando eventuais bugs
		actionTimerMax = 0.1
		actionTimer = actionTimerMax

function updateMatriz()


end


function blockRandomizer()
	n = math.random(1, 7)

	if n == 1 then return blocks.img.i end
	if n == 2 then return blocks.img.l end
	if n == 3 then return blocks.img.j end
	if n == 4 then return blocks.img.o end
	if n == 5 then return blocks.img.z end
	if n == 6 then return blocks.img.s end
	if n == 7 then return blocks.img.t end
end	

function love.load(arg)
	blocks.img.i = love.graphics.newImage("assets/img/i.png")
	blocks.img.l = love.graphics.newImage("assets/img/l.png")	
	blocks.img.j = love.graphics.newImage("assets/img/j.png")
	blocks.img.o = love.graphics.newImage("assets/img/o.png")
	blocks.img.z = love.graphics.newImage("assets/img/z.png")
	blocks.img.s = love.graphics.newImage("assets/img/s.png")
	blocks.img.t = love.graphics.newImage("assets/img/t.png")

	matriz[player.mY][player.mX] = blocks.img.t

end

function love.update(dt)
	-- update dos timers
	fallTimer = fallTimer - dt
	actionTimer = actionTimer - dt

	--'gravidade' sendo aplicada
	if fallTimer <= 0 then
		matriz[player.mY + 1][player.mX] = matriz[player.mY][player.mX]
		matriz[player.mY][player.mX] = nil
		player.mY = player.mY + 1

		fallTimer = fallTimerMax
	end

	-- movimentação horizontal
	if (love.keyboard.isDown('a') or love.keyboard.isDown('left')) 
		and actionTimer <=0 then
		player.mX = player.mX - 1

		if player.mX <= 0 then 
			player.mX = 1 
		else
			matriz[player.mY][player.mX] = matriz[player.mY][player.mX + 1]
			matriz[player.mY][player.mX + 1] = nil
		end
		
		actionTimer = actionTimerMax
	end

	if (love.keyboard.isDown('d') or love.keyboard.isDown('right')) 
		and actionTimer <=0 then
		player.mX = player.mX + 1
		if player.mX >= 8 then 
			player.mX = 7
		else
			matriz[player.mY][player.mX] = matriz[player.mY][player.mX - 1]
			matriz[player.mY][player.mX - 1] = nil
		end

		actionTimer = actionTimerMax
	end

	if player.mY == 11 or matriz[player.mY + 1][player.mX] ~= nil then
		player.mX = 4
		player.mY = 1
		matriz[player.mY][player.mX] = blockRandomizer()
	end

	--[[for i=1, 11 do
		for j=1, 7 do
			if matriz[i][j] ~= nil then fullLine = true
			else fullLine = false
			end

			if not fullLine then break end
		end
		if fullLine then
		end
	end
	]]



end

function love.draw(dt)
	for i=1, 11 do
		for j=1, 7 do
			if matriz[i][j] ~= nil then
				love.graphics.draw(matriz[i][j], 50*(j-1), 50*(i-1))
			end
		end
	end
end