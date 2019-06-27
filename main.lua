
blocks = {img ={i=nil, l=nil, j=nil, o=nil, z=nil, s=nil, t=nil}}


-- Inicializando a matriz principal que armazenará a informação dos blocos
	matriz = {largura = 7, altura = 11}
	for i=1, matriz.altura do
		matriz[i] = {}
		for j=1, matriz.largura do
			matriz[i][j] = nil
		end
	end

--Bloco do jogador
	--O objeto guardará a posição atual do bloco 'jogável' do player
	--A posição se dá pelos indices do bloco na matriz
	player = {mX = math.floor(matriz.largura/2), mY = 1, shape = nil}
	
--timers
	--timer para a movimentação vertical do blocos
		fallTimerMax = 1
		fallTimer = fallTimerMax
	--timer para restringir as ações do jogador, evitando eventuais bugs
		actionTimerMax = 0.2
		actionTimer = actionTimerMax

function updateMatriz()
end

function topBlock()
	-- Percorre toda a coluna em que o jogador se encontra. 
	-- Quando encontrar um bloco, retorna a 'altura' do bloco 
	for i=1, matriz.altura do
		if matriz[i][player.mX] ~= nil and i ~= player.mY then
			return i - 1 
		end
	end
	return matriz.altura
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

	-- Inicializando o jogador
	matriz[player.mY][player.mX] = blockRandomizer()

end

function love.update(dt)
	-- update dos timers
	fallTimer = fallTimer - (1*dt)
	actionTimer = actionTimer - (1*dt)

	--'gravidade' sendo aplicada
	if fallTimer <= 0 then
		matriz[player.mY + 1][player.mX] = matriz[player.mY][player.mX]
		matriz[player.mY][player.mX] = nil
		player.mY = player.mY + 1

		fallTimer = fallTimerMax
	end

	-- Controles do usuário
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
		if player.mX >= matriz.largura + 1 then 
			player.mX = matriz.largura
		else
			matriz[player.mY][player.mX] = matriz[player.mY][player.mX - 1]
			matriz[player.mY][player.mX - 1] = nil
		end

		actionTimer = actionTimerMax
	end
		-- fim da movimentação horizontal

		-- movimentação vertical
	if (love.keyboard.isDown('s') or love.keyboard.isDown('down'))
		and actionTimer <=0 then

		topo = topBlock()
		
		matriz[player.mY][player.mX],matriz[topo][player.mX]
			= matriz[topo][player.mX],matriz[player.mY][player.mX]

		player.mY = topo

		actionTimer = actionTimerMax
	end 
		-- fim da movimentação vertical
	-- fim dos controles do usuário


	-- Se o jogador estiver no fundo da matriz ou se a posição abaixo do jogador estiver ocupada
	-- então é gerado um novo bloco jogável e a posição do jogador é relocada para tal
	if player.mY == matriz.altura or matriz[player.mY + 1][player.mX] ~= nil then
		player.mX = math.floor(matriz.largura/2) --meio da matriz
		player.mY = 1
		matriz[player.mY][player.mX] = blockRandomizer()
	end

	-- Contabilizando pontos e destruindo linhas
	for i=1, matriz.altura do
		for j=1, matriz.largura do
			if matriz[i][j] ~= nil then
				fullLine = true
			else 
				fullLine = false
			end

			if not fullLine then break end
		end

		-- Se a linha estiver completa, então um for externo irá realizar a ação da 'gravidade' 
		-- nos blocos superiores
		if fullLine then
			for j=1, matriz.largura do
				matriz[i][j] = nil
			end 
			caindo = true 
		end
	end

	if caindo then
		for i=matriz.altura, 2, -1 do
			for j=1, matriz.largura do
				matriz[i][j], matriz[i-1][j] = matriz[i][j], matriz[i-1][j]
			end
		end 
		caindo = false
	end
	-- fim da atualização de linhas
	



end

function love.draw(dt)
	for i=1, matriz.altura do
		for j=1, matriz.largura do
			if matriz[i][j] ~= nil then
				love.graphics.draw(matriz[i][j], 50*(j-1), 50*(i-1))
			end
		end
	end
end