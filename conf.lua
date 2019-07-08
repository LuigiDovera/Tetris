function love.conf(t)
	t.title = "Tetris" -- The title of the window the game is in (string)
	t.version = "0.9.1"         -- The LÖVE version this game was made for (string)
	t.window.width = 50*7 + 250   --[valor base (blocks.lado) * largura em blocos (matriz.largura)]
	t.window.height = 50*11		--[valor base (blocks.lado) * altura em blocos (matriz.altura)]

	-- For Windows debugging
	t.console = true
end