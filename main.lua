
blocks = {img ={i=nil, l=nil, j=nil, o=nil, z=nil, s=nil, t=nil}}

matriz = {}
for i=1, 11 do
	matriz[i] = {}
	for j=1, 7 do
		matriz[i][j] = nil
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

end

function love.update(dt)
	matriz[10][1] = blocks.img.t
	matriz[5][5] = blocks.img.t

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