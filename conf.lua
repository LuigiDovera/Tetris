function love.conf(t)
	t.title = "Tetris" -- The title of the window the game is in (string)
	t.version = "0.9.1"         -- The LÖVE version this game was made for (string)
	t.window.width = 50*7     --[valor base * largura em blocos]
	t.window.height = 50*11		--[valor base * altura em blocos]

	-- For Windows debugging
	t.console = false
end