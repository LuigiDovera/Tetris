
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
	playerB = {mX = nil, mY = nil}
	
--timers
	--timer para a movimentação vertical do blocos
		fallTimerMax = 1
		fallTimer = fallTimerMax


function updateMatriz()

end

function love.load(arg)
	blocks.img.i = love.graphics.newImage("assets/img/i.png")
	blocks.img.l = love.graphics.newImage("assets/img/l.png")	
	blocks.img.j = love.graphics.newImage("assets/img/j.png")
	blocks.img.o = love.graphics.newImage("assets/img/o.png")
	blocks.img.z = love.graphics.newImage("assets/img/z.png")
	blocks.img.s = love.graphics.newImage("assets/img/s.png")
	blocks.img.t = love.graphics.newImage("assets/img/t.png")

end

function love.update(dt)
	--[[
	fallTimer = fallTimer - dt
	if fallTimer < 0 then
		matriz[playerB.mY + 1][playerB.mX] = matriz[playerB.mY][playerB.mX]
		matriz[playerB.mY][playerB.mX] = nil
		playerB.mY = playerB.mY + 1
	end
	]]

	if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
		player.mX = player.mX - 1
	end
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