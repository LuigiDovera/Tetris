
blocks = {img ={i=nil, l=nil, j=nil, o=nil, z=nil, s=nil, t=nil}, lado = 50, caindo = false}


-- Inicializando a matriz principal que armazenará a informação dos blocos
	matriz = {largura = 7, altura = 11}
	for i=1, matriz.altura + 1 do
		matriz[i] = {}
		for j=1, matriz.largura do
			matriz[i][j] = nil
		end
	end

--Bloco do jogador
	--O objeto guardará a posição atual do bloco 'jogável' do player
	--A posição se dá pelos indices do bloco na matriz
	player = {mX = math.ceil(matriz.largura/2), mY = 1, shape = nil, orientacao = nil, 
		caindo = false, adj = {}}

	for i=1, 3 do
		player.adj[i] = {mX = nil, mY = nil}
	end
	
--timers
	--timer para a movimentação vertical do blocos
		fallTimerMax = 1	
		fallTimer = fallTimerMax
	--timer para restringir as ações do jogador, evitando eventuais bugs
		actionTimerMax = 0.2
		actionTimer = actionTimerMax

function blockRandomizer()
	player.mY = 1
	player.mX = math.ceil(matriz.largura/2)

	math.randomseed(os.time())
	n = 1 --math.random(1, 5)

	if n == 1 then 
		player.shape = 'i' 
		player.mY = 2
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY-1, player.mX
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY+2, player.mX

		img = blocks.img.i
	end
	--[[if n == 1 then 
		player.shape = 'l' 
		player.mY = 2
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY, player.mX
		player.adj[2].mY, player.adj[2].mX = player.mY, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY, player.mX

		img = blocks.img.l
	end]]
	if n == 2 then 
		player.shape = 'j' 
		player.mY = 2
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY+1, player.mX-1
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY-1, player.mX

		img = blocks.img.j
	end
	if n == 3 then 
		player.shape = 'o'
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY, player.mX+1
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX+1
		player.adj[3].mY, player.adj[3].mX = player.mY+1, player.mX

		img = blocks.img.o 
	end
	if n == 4 then 
		player.shape = 'z'
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY, player.mX-1
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY+1, player.mX+1

		img = blocks.img.z
	end
	--if n == 6 then player.shape = 's' return blocks.img.s end
	if n == 5 then 
		player.shape = 't'
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY, player.mX-1
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY, player.mX+1 

		img = blocks.img.t
	end

	matriz[player.mY][player.mX] = img
	for i=1, 3 do
			matriz[player.adj[i].mY][player.adj[i].mX] = img
	end
end	


function contarColisoes(direcao, m)
	colisao = 0
	if direcao == 'esquerda' then
		if m[player.mY][player.mX - 1] ~= nil then
			colisao = colisao + 1
		end
		for i=1, 3 do
			if m[player.adj[i].mY][player.adj[i].mX - 1] ~= nil then
				colisao = colisao + 1
			end
		end
	elseif direcao == 'direita' then
		if m[player.mY][player.mX + 1] ~= nil then
			colisao = colisao + 1
		end
		for i=1, 3 do 
			if m[player.adj[i].mY][player.adj[i].mX + 1] ~= nil then
				colisao = colisao + 1
			end
		end
	elseif direcao == 'cair' then
		if m[player.mY + 1][player.mX] ~= nil then
			colisao = colisao + 1
		end
		for i=1, 3 do 
			if m[player.adj[i].mY + 1][player.adj[i].mX] ~= nil then
				colisao = colisao + 1
			end
		end
	end
	return colisao
end

function corpoIsolado()
	matrizTeste = {}
	for i=1, matriz.altura + 1 do
		matrizTeste[i] = {}
		for j=1, matriz.largura do
			matrizTeste[i][j] = nil
		end
	end

	matrizTeste[player.mY][player.mX] = matriz[player.mY][player.mX]
	for i=1, 3 do
		matrizTeste[player.adj[i].mY][player.adj[i].mX] = matriz[player.adj[i].mY][player.adj[i].mX]
	end

	return matrizTeste
end

function validaMovimentacao(direcao)
	if contarColisoes(direcao, matriz) 
		> contarColisoes(direcao, corpoIsolado()) then
		return false
	else
		return true
	end
end

function cruzandoFronteiras(direcao)
	if direcao == 'esquerda' then
		if player.mX <= 1 then
			return true
		end
		for i=1, 3 do
			if player.adj[i].mX <= 1 then
				return true
			end
		end
	elseif direcao == 'direita' then
		if player.mX >= matriz.largura then
			return true
		end
		for i=1, 3 do
			if player.adj[i].mX >= matriz.largura then
				return true
			end
		end
	elseif direcao == 'cair' then
		if player.mY >= matriz.altura then
			return true
		end
		for i=1, 3 do
			if player.adj[i].mY >= matriz.altura then
				return true
			end
		end
	end
	return false
end

function playerMovement(direcao)
	if direcao == 'esquerda' and not cruzandoFronteiras(direcao) and validaMovimentacao(direcao) then
		img = matriz[player.mY][player.mX]

		matriz[player.mY][player.mX] = nil
		for i=1, 3 do
			matriz[player.adj[i].mY][player.adj[i].mX] = nil
		end

		player.mX = player.mX - 1
		for i=1, 3 do
			player.adj[i].mX = player.adj[i].mX - 1 
		end

		matriz[player.mY][player.mX] = img
		for i=1, 3 do
			matriz[player.adj[i].mY][player.adj[i].mX] = img
		end

 	elseif direcao == 'direita' and not cruzandoFronteiras(direcao) and validaMovimentacao(direcao) then
 		img = matriz[player.mY][player.mX]

		matriz[player.mY][player.mX] = nil
		for i=1, 3 do
			matriz[player.adj[i].mY][player.adj[i].mX] = nil
		end

		player.mX = player.mX + 1
		for i=1, 3 do
			player.adj[i].mX = player.adj[i].mX + 1 
		end

		matriz[player.mY][player.mX] = img
		for i=1, 3 do
			matriz[player.adj[i].mY][player.adj[i].mX] = img
		end

	elseif direcao == 'baixo' then
		if shape == 'j' then

		elseif shape == 'o' then

		elseif shape == 'z' then
	
		elseif shape == 't' then
	
		end
	elseif direcao == 'cima' then
		if shape == 'j' then

		elseif shape == 'o' then

		elseif shape == 'z' then
	
		elseif shape == 't' then
	
		end
	elseif direcao == 'cair' and not cruzandoFronteiras(direcao) and validaMovimentacao(direcao) then
		img = matriz[player.mY][player.mX]

		matriz[player.mY][player.mX] = nil
		for i=1, 3 do
			matriz[player.adj[i].mY][player.adj[i].mX] = nil
		end

		player.mY = player.mY + 1
		for i=1, 3 do
			player.adj[i].mY = player.adj[i].mY + 1 
		end

		matriz[player.mY][player.mX] = img
		for i=1, 3 do
			matriz[player.adj[i].mY][player.adj[i].mX] = img
		end
	else
		print('direção inválida')
	end 
end

function topBlock()
	-- Percorre toda a coluna em que o jogador se encontra. 
	-- Quando encontrar um bloco, retorna a 'altura' do bloco 
	for i=1, matriz.altura do
		if matriz[i][player.mX] ~= nil and i ~= player.mY 
			and i ~= player.adj[1].mY
			and i ~= player.adj[2].mY
			and i ~= player.adj[3].mY then
			return i - 1 
		end
	end
	return matriz.altura
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
	blockRandomizer()
	for i=8, matriz.altura do
		for j=2, matriz.largura do
			matriz[i][j] = blocks.img.l
		end
	end
end

function love.update(dt)
	-- update dos timers
	fallTimer = fallTimer - (1*dt)
	actionTimer = actionTimer - (1*dt)

	--'gravidade' sendo aplicada
	if fallTimer <= 0 then
		playerMovement('cair')
		fallTimer = fallTimerMax
	end

	if not player.caindo then
		-- Controles do usuário
			-- movimentação horizontal
		if (love.keyboard.isDown('a') or love.keyboard.isDown('left')) 
			and actionTimer <=0 then

			playerMovement('esquerda')
			
			actionTimer = actionTimerMax
		end

		if (love.keyboard.isDown('d') or love.keyboard.isDown('right')) 
			and actionTimer <=0 then

			playerMovement('direita')

			actionTimer = actionTimerMax
		end
			-- fim da movimentação horizontal

			-- movimentação vertical
		if love.keyboard.isDown(' ') and actionTimer <=0 then

			player.caindo = true

		end
			-- fim da movimentação vertical
		-- fim dos controles do usuário
	else
		fallTimerMax = 0.05
		if not validaMovimentacao('cair') then
			player.caindo = false
			fallTimerMax = 1
		end
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
			blocks.caindo = true 
		end
	end

	if blocks.caindo then
		for i=matriz.altura, 2, -1 do
			for j=1, matriz.largura do
				matriz[i][j], matriz[i-1][j] = matriz[i-1][j], matriz[i][j]
			end
		end 
		blocks.caindo = false
	end
	-- fim da atualização de linhas
	
	-- Se o jogador estiver no fundo da matriz ou se a posição abaixo do jogador estiver ocupada
	-- então é gerado um novo bloco jogável e a posição do jogador é relocada para tal
	if not validaMovimentacao('cair') or cruzandoFronteiras('cair') then
		blockRandomizer()
	end


end

function love.draw(dt)
	for i=1, matriz.altura do
		for j=1, matriz.largura do
			if matriz[i][j] ~= nil then
				love.graphics.draw(matriz[i][j], blocks.lado*(j-1), blocks.lado*(i-1))
			end
		end
	end
end