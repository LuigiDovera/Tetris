
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

--	Elementos de gameplay
	pontos = 0
	pontuando = false

	math.randomseed(os.time())
	nextBlock = math.random(1, 5)

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

-- musica e sons
	music = {main = nil, menu = nil, over = nil}

	sound = {movInvalido = nil, pontuou = nil}


function blockCreator()
	player.mY = 1
	player.mX = math.ceil(matriz.largura/2)

	if nextBlock == 1 then 
		player.shape = 'i' 
		player.mY = 2
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY-1, player.mX
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY+2, player.mX

		img = blocks.img.i
	end
	--[[if nextBlock == 1 then 
		player.shape = 'l' 
		player.mY = 2
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY, player.mX
		player.adj[2].mY, player.adj[2].mX = player.mY, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY, player.mX

		img = blocks.img.l
	end]]
	if nextBlock == 2 then 
		player.shape = 'j' 
		player.mY = 2
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY+1, player.mX-1
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY-1, player.mX

		img = blocks.img.j
	end
	if nextBlock == 3 then 
		player.shape = 'o'
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY, player.mX+1
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX+1
		player.adj[3].mY, player.adj[3].mX = player.mY+1, player.mX

		img = blocks.img.o 
	end
	if nextBlock == 4 then 
		player.shape = 'z'
		player.orientacao = 'cima'

		player.adj[1].mY, player.adj[1].mX = player.mY, player.mX-1
		player.adj[2].mY, player.adj[2].mX = player.mY+1, player.mX
		player.adj[3].mY, player.adj[3].mX = player.mY+1, player.mX+1

		img = blocks.img.z
	end
	--if nextBlock == 6 then player.shape = 's' return blocks.img.s end
	if nextBlock == 5 then 
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

	math.randomseed(os.time())
	nextBlock = math.random(1, 5)

	--nextBlock = 1

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

function corpoTotalmenteIsolado()
	--[[matrizTeste = {}
	for i=1, 4 do
		matrizTeste[i] = {}
		for j=1, 4 do
			matrizTeste[i][j] = nil
		end
	end]]

	if nextBlock == 1 then
		blocoLetra = "I" 
		--[[for i=1, 4 do
			matrizTeste[i][1] = blocks.img.i 
		end]]
	end
	--[[if nextBlock == 1 then 

		img = blocks.img.l
	end]]
	if nextBlock == 2 then 
		blocoLetra = "J"
		--[[matrizTeste[2][1] = blocks.img.j
		matrizTeste[2][2] = blocks.img.j
		matrizTeste[2][3] = blocks.img.j
		matrizTeste[1][3] = blocks.img.j]] 		

	end
	if nextBlock == 3 then 
		blocoLetra = "O"
		--[[matrizTeste[1][1] = blocks.img.o
		matrizTeste[2][1] = blocks.img.o
		matrizTeste[1][2] = blocks.img.o
		matrizTeste[2][2] = blocks.img.o ]]
	end
	if nextBlock == 4 then 
		blocoLetra = "Z"
		--[[matrizTeste[1][1] = blocks.img.z
		matrizTeste[1][2] = blocks.img.z
		matrizTeste[2][2] = blocks.img.z
		matrizTeste[3][2] = blocks.img.z ]]
	end
	--if nextBlock == 6 then player.shape = 's' return blocks.img.s end
	if nextBlock == 5 then 
		blocoLetra = "T"
		--[[matrizTeste[1][1] = blocks.img.t
		matrizTeste[2][1] = blocks.img.t
		matrizTeste[3][1] = blocks.img.t
		matrizTeste[2][2] = blocks.img.t]] 
	end

	return blocoLetra
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
		love.audio.play(sound.movInvalido)
	end 
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

	love.window.setIcon( love.image.newImageData("assets/img/icon.png") )

	fonte.large = love.graphics.newFont("assets/font/Gamer.ttf", 200)
	fonte.medium = love.graphics.newFont("assets/font/Gamer.ttf", 96)
	fonte.small = love.graphics.newFont("assets/font/Gamer.ttf", 64)
	fonte.tiny = love.graphics.newFont("assets/font/Gamer.ttf", 32)

	music.main = love.audio.newSource("assets/music/main.mp3", "stream")
	music.menu = love.audio.newSource("assets/music/menu.mp3", "stream")
	music.over = love.audio.newSource("assets/music/over.mp3", "stream")

	sound.movInvalido = love.audio.newSource("assets/sound/movInvalido.wav", "static")
	sound.pontuou = love.audio.newSource("assets/sound/pontuou.wav", "static")

	-- Inicializando o jogador
	blockCreator()
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
					love.audio.stop()
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

			if #linhasCompletas == 1 then
				pontos = pontos + 100*#linhasCompletas
				love.audio.play(sound.pontuou)
			elseif #linhasCompletas == 2 then
				pontos = pontos + 125*#linhasCompletas
				love.audio.play(sound.pontuou)
			elseif #linhasCompletas == 3 then
				pontos = pontos + 175*#linhasCompletas
				love.audio.play(sound.pontuou)
			elseif #linhasCompletas == 4 then
				pontos = pontos + 200*#linhasCompletas
				love.audio.play(sound.pontuou)
			end

			-- fim da atualização de linhas
			pontuando = false
			blockCreator()

			if not validaMovimentacao('cair') then
					tela_atual = 3
					item_atual = 1
					love.audio.stop()
			end

		end
		
		-- Se o jogador estiver no fundo da matriz ou se a posição abaixo do jogador estiver ocupada
		-- então é gerado um novo bloco jogável e a posição do jogador é relocada para tal
		if not validaMovimentacao('cair') or cruzandoFronteiras('cair') then
			pontuando = true
			spawned = true
			
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
			if love.keyboard.isDown(' ') or love.keyboard.isDown('return') then
				if tela_atual == 1 then
					if item_atual == 1 then
						tela_atual = 4
						item_atual = 1
					elseif item_atual == 2 then
						love.event.quit()
					end
					love.audio.stop()
				elseif tela_atual == 2 then
					if item_atual == 1 then
						tela_atual = 4
						item_atual = 1
					elseif item_atual == 2 then
						love.event.quit()
					end
					love.audio.stop()
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
						blockCreator() 
					elseif item_atual == 2 then
						love.event.quit()
					end
					love.audio.stop()
				end

				actionTimer = actionTimerMax
			end
		end
	end
	if tela_atual == 1 or tela_atual == 2 then
		love.audio.play(music.menu)
	elseif tela_atual == 3 then
		love.audio.play(music.over)
	elseif tela_atual == 4 then
		love.audio.play(music.main)
	end
end

function love.draw(dt)

	if tela_atual == 4 then
		love.graphics.setColor({102, 120, 89})
		love.graphics.rectangle('fill', 0, 0, blocks.lado*matriz.largura, blocks.lado*matriz.altura)

		love.graphics.setColor(255,255,255)

		for i=1, matriz.altura do
			for j=1, matriz.largura do
				if matriz[i][j] ~= nil then
					love.graphics.draw(matriz[i][j], blocks.lado*(j-1), blocks.lado*(i-1))
				end	
			end
		end

		love.graphics.setColor({102, 120, 89})
		love.graphics.rectangle('fill', 400, 150, 100, 100)

		love.graphics.setColor(255,255,255)
		blocoLetra = corpoTotalmenteIsolado()
		love.graphics.setFont(fonte.small)
		love.graphics.print(blocoLetra, 410 , 160)
		--matrizNext = corpoTotalmenteIsolado()
		--bloco = love.graphics.newQuad(0, 0, 20, 20, 20, 20)
		--[[for i=1, #matrizNext do
			for j=1, #matrizNext[i] do
				if matrizNext[i][j] ~= nil then
					love.graphics.draw(matrizNext[i][j], bloco, 410 + 20*(j-1), 160 + 20*(i-1))
				end
			end
		end]]

		love.graphics.setFont(fonte.small)
		love.graphics.print("Pts: "..pontos, 360, 400)

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
		love.graphics.rectangle('fill', 200, 175, 240, 225)

		love.graphics.setColor(255,255,255)
		
		love.graphics.setColor({11, 65, 163})
		love.graphics.rectangle('fill', 225, 200, 190, 75)
		love.graphics.setColor({11, 65, 163})
		love.graphics.rectangle('fill', 225, 300, 190, 75)

		if item_atual == 1 then
			love.graphics.setColor({78, 245, 66})
			love.graphics.rectangle('fill', 225, 200, 190, 75)
		elseif item_atual == 2 then
			love.graphics.setColor({78, 245, 66})
			love.graphics.rectangle('fill', 225, 300, 190, 75)
		end	

		love.graphics.setColor(255,255,255)

		love.graphics.setFont(fonte.small)
		love.graphics.print("Resume", 250, 210)
		love.graphics.print("Exit", 275, 310)

	elseif tela_atual == 3 then

		love.graphics.setColor({102, 120, 89})
		love.graphics.rectangle('fill', 200, 100, 240, 350)

		love.graphics.setColor(255,255,255)

		love.graphics.setFont(fonte.small)
		love.graphics.print("Pts: "..pontos, 245, 100)

		love.graphics.setColor({11, 65, 163})
		love.graphics.rectangle('fill', 245, 250, 150, 75)
		love.graphics.setColor({11, 65, 163})
		love.graphics.rectangle('fill', 245, 350, 150, 75)

		if item_atual == 1 then
			love.graphics.setColor({78, 245, 66})
			love.graphics.rectangle('fill', 245, 250, 150, 75)
		elseif item_atual == 2 then
			love.graphics.setColor({78, 245, 66})
			love.graphics.rectangle('fill', 245, 350, 150, 75)
		end	

		love.graphics.setColor(255,255,255)

		love.graphics.setFont(fonte.small)
		love.graphics.print("Retry", 270, 260)
		love.graphics.print("Exit", 270, 360)
	end
end