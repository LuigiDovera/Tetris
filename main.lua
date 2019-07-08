
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
	
	pontos = 0
	pontuando = false
--timers
	--timer para a movimentação vertical do blocos
		fallTimerMax = 1	
		fallTimer = fallTimerMax
	--timer para restringir as ações do jogador, evitando eventuais bugs
		actionTimerMax = 0.2
		actionTimer = actionTimerMax

--telas e telas
	telas={{"Play","Exit"},
 		{"Retry", "Exit"},
 		{"Resume", "Exit"},
 		{}}

 	tela_atual = 1
 	item_atual = 1

 	wallpaper = nil

--fonte
	fonte = {large = nil, medium = nil, small = nil, tiny = nil}

function blockRandomizer()
	player.mY = 1
	player.mX = math.ceil(matriz.largura/2)

	math.randomseed(os.time())
	n = math.random(1, 5)

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
	if contarColisoes(direcao, matriz) > contarColisoes(direcao, corpoIsolado()) then
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
	elseif direcao == 'baixo' then

	elseif direcao == 'cima' then

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
			for i=1, 3 do

			end
		elseif shape == 'o' then

		elseif shape == 'z' then
	
		elseif shape == 't' then
	
		elseif shape == 'i' then

		end
	elseif direcao == 'cima' then
		if shape == 'j' then

		elseif shape == 'o' then

		elseif shape == 'z' then
	
		elseif shape == 't' then

		elseif shape == 'i' then
	
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

	wallpaper = love.graphics.newImage("assets/img/wallpaper.png")

	fonte.large = love.graphics.newFont("assets/font/Gamer.ttf", 200)
	fonte.medium = love.graphics.newFont("assets/font/Gamer.ttf", 96)
	fonte.small = love.graphics.newFont("assets/font/Gamer.ttf", 64)
	fonte.tiny = love.graphics.newFont("assets/font/Gamer.ttf", 32)

	-- Inicializando o jogador
	blockRandomizer()
end

function love.update(dt)
	if tela_atual == 4 then
		if not pontuando then			
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
					actionTimer = actionTimerMax

				end

				if love.keyboard.isDown('escape') and actionTimer <=0 then
					tela_atual = 2
					item_atual = 1
				end
				-- fim da movimentação vertical
				-- fim dos controles do usuário
			else
				fallTimerMax = 0.05
				if not validaMovimentacao('cair') or cruzandoFronteiras('cair') then
					player.caindo = false
					fallTimerMax = 1
				end
			end

		else
			-- Contabilizando pontos e destruindo linhas
			linhasCompletas = {}
			contador = 0
			linhasDestruidas = 0
			for i=1, matriz.altura do
				blocosLinha = 0
				for j=1, matriz.largura do
					if matriz[i][j] ~= nil then
						blocosLinha = blocosLinha + 1
					end
					if blocosLinha < j then  
						break 
					end
					if blocosLinha >= matriz.largura then
						linhasDestruidas = linhasDestruidas + 1
						linhasCompletas[linhasDestruidas] = i
					end
				end
				if linhasDestruidas > contador then
					for j=1, matriz.largura do
						matriz[i][j] = nil
					end 
					contador = contador + 1
					blocks.caindo = true 
				end
			end

			if blocks.caindo then
				for k=1, linhasDestruidas do
					for i=linhasCompletas[k], 2, -1 do
						for j=1, matriz.largura do
							matriz[i][j], matriz[i-1][j] = matriz[i-1][j], matriz[i][j]
						end
					end
				end
				blocks.caindo = false
			end	
			-- fim da atualização de linhas
			pontuando = false
			blockRandomizer()
		end
		
		-- Se o jogador estiver no fundo da matriz ou se a posição abaixo do jogador estiver ocupada
		-- então é gerado um novo bloco jogável e a posição do jogador é relocada para tal
		if not validaMovimentacao('cair') or cruzandoFronteiras('cair') then
			pontuando = true
			
		end
	else
		actionTimer = actionTimer - (1*dt)
		if actionTimer <=0 then
			if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
		    	item_atual = item_atual - 1
		    	if item_atual<1 then
		       		item_atual = #telas[tela_atual]
		    	end

		    	actionTimer = actionTimerMax
			end
			if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
		    	item_atual = item_atual + 1
		    	if item_atual>#telas[tela_atual] then
		    	   item_atual = 1
		    	end

		    	actionTimer = actionTimerMax
			end
			if love.keyboard.isDown(' ') or love.keyboard.isDown('enter') then
				if tela_atual == 1 then
					if item_atual == 1 then
						tela_atual = 4
						item_atual = 1
					elseif item_atual == 2 then
						love.event.quit()
					end
				elseif tela_atual == 2 then
					if item_atual == 1 then
						tela_atual = 4
						item_atual = 1
					elseif item_atual == 2 then
						love.event.quit()
					end
				elseif tela_atual == 3 then
					if item_atual == 1 then
						tela_atual = 4
						item_atual = 1

						pontos = 0
						for i=1, matriz.altura do
							for j=1, matriz.largura do
								matriz[i][j] = nil
							end
						end
						blockRandomizer() 
					elseif item_atual == 2 then
						love.event.quit()
					end
				end

				actionTimer = actionTimerMax
			end
		end
	end
end

function love.draw(dt)
	if tela_atual == 4 then
		for i=1, matriz.altura do
			for j=1, matriz.largura do
				if matriz[i][j] ~= nil then
					love.graphics.draw(matriz[i][j], blocks.lado*(j-1), blocks.lado*(i-1))
				end	
			end
		end
	elseif tela_atual == 1 then
		love.graphics.draw(wallpaper, 0, 0)
		love.graphics.setFont(fonte.large)
		love.graphics.print("Tetris", 100, 70)

		love.graphics.setColor({11, 65, 163})
		love.graphics.rectangle('fill', 225, 250, 150, 75)
		love.graphics.setColor({11, 65, 163})
		love.graphics.rectangle('fill', 225, 350, 150, 75)

		if item_atual == 1 then
			love.graphics.setColor({78, 245, 66})
			love.graphics.rectangle('fill', 225, 250, 150, 75)
		elseif item_atual == 2 then
			love.graphics.setColor({78, 245, 66})
			love.graphics.rectangle('fill', 225, 350, 150, 75)
		end	

		love.graphics.setColor(255,255,255)

		love.graphics.setFont(fonte.small)
		love.graphics.print("Play", 250, 260)
		love.graphics.print("Exit", 250, 360)

	elseif tela_atual == 2 then

		love.graphics.setColor({102, 120, 89})
		love.graphics.rectangle('fill', 200, 0, 200, 550)

		love.graphics.setColor(255,255,255)
		
		love.graphics.setColor({11, 65, 163})
		love.graphics.rectangle('fill', 225, 200, 150, 75)
		love.graphics.setColor({11, 65, 163})
		love.graphics.rectangle('fill', 225, 300, 150, 75)

		if item_atual == 1 then
			love.graphics.setColor({78, 245, 66})
			love.graphics.rectangle('fill', 225, 200, 150, 75)
		elseif item_atual == 2 then
			love.graphics.setColor({78, 245, 66})
			love.graphics.rectangle('fill', 225, 300, 150, 75)
		end	

		love.graphics.setColor(255,255,255)

		love.graphics.setFont(fonte.small)
		love.graphics.print("Resume", 250, 260)
		love.graphics.print("Exit", 250, 360)
	end

	--[[for i=1, #tela[tela_atual] do
    	love.graphics.print(tela[tela_atual][i], X, Y+ 20*i)
 	end]]
end