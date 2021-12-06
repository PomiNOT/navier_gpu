local vec = require("vector")
local RES_SCALE = 0.5

function love.load()
    w, h = love.graphics.getDimensions()
    w = w * RES_SCALE
    h = h * RES_SCALE
    front = love.graphics.newCanvas(w, h, { format = "rgba16f" })
    back = love.graphics.newCanvas(w, h, { format = "rgba16f" })
    tempFront = love.graphics.newCanvas(w, h, { format = "rgba16f" })
    tempBack = love.graphics.newCanvas(w, h, { format = "rgba16f" })
    seidelShaderCode = love.filesystem.read("gauss_seidel.glsl")
    seidelShader = love.graphics.newShader(seidelShaderCode)
    advectShaderCode = love.filesystem.read("advect.glsl")
    advectShader = love.graphics.newShader(advectShaderCode)
    drawShaderCode = love.filesystem.read("draw.glsl")
    drawShader = love.graphics.newShader(drawShaderCode)
    project1ShaderCode = love.filesystem.read("project1.glsl")
    project1Shader = love.graphics.newShader(project1ShaderCode)
    project2ShaderCode = love.filesystem.read("project2.glsl")
    project2Shader = love.graphics.newShader(project2ShaderCode)
    visualizeShaderCode = love.filesystem.read("visualize.glsl")
    visualizeShader = love.graphics.newShader(visualizeShaderCode)

    diffusionFactor = 5 * RES_SCALE
    iters = 30

    love.window.setTitle("Fluid Simulation")
end

function swap()
    front, back = back, front
end

function swapTemp()
    tempFront, tempBack = tempBack, tempFront
end

local movement = vec.new(0, 0)
function love.mousemoved(x, y, dx, dy)
    movement = vec.new(dx, dy)
end

function love.draw()
    tempFront:renderTo(function()
        love.graphics.clear()
        love.graphics.setShader(drawShader)
        local down = nil
        if love.mouse.isDown(1) then
            down = 1
        else
            down = 0
        end
        local x, y = movement:unpack()
        drawShader:send("mouseMovement", { x, y, down })
        drawShader:send("mousePosition", { love.mouse.getPosition() })
        drawShader:send("resScale", RES_SCALE)
        love.graphics.draw(front)
    end)

    love.graphics.reset()

    for i=1,iters do
        love.graphics.setCanvas(back)
        love.graphics.clear()
        love.graphics.setShader(seidelShader)
        seidelShader:send("iResolution", { w, h })
        seidelShader:send("alpha", diffusionFactor * love.timer.getDelta())
        seidelShader:send("beta", 1 + 4 * diffusionFactor * love.timer.getDelta())
        seidelShader:send("calculatingHeightfield", false)
        seidelShader:send("orig", tempFront)
        love.graphics.draw(front)
        swap()
    end

    love.graphics.reset()

    love.graphics.setCanvas(back)
    love.graphics.clear()
    love.graphics.setShader(advectShader)
    advectShader:send("iResolution", { w, h })
    advectShader:send("iTimeDelta", love.timer.getDelta())
    love.graphics.draw(front)
    swap()

    love.graphics.reset()

    love.graphics.setCanvas(tempFront)
    love.graphics.clear()
    love.graphics.setShader(project1Shader)
    project1Shader:send("iResolution", { w, h })
    love.graphics.draw(front)

    love.graphics.reset()

    for i=1,iters do
        love.graphics.setCanvas(tempBack)
        love.graphics.clear()
        love.graphics.setShader(seidelShader)
        seidelShader:send("iResolution", { w, h })
        seidelShader:send("alpha", 1)
        seidelShader:send("beta", 4)
        seidelShader:send("calculatingHeightfield", true)
        seidelShader:send("orig", tempFront)
        love.graphics.draw(tempFront)
        swapTemp()
    end

    love.graphics.reset()

    love.graphics.setCanvas(back)
    love.graphics.clear()
    love.graphics.setShader(project2Shader)
    project2Shader:send("iResolution", { w, h })
    project2Shader:send("heightField", tempFront)
    love.graphics.draw(front)
    swap()

    love.graphics.reset()
    love.graphics.scale(1 / RES_SCALE)
    love.graphics.setShader(visualizeShader)
    love.graphics.draw(front)
end