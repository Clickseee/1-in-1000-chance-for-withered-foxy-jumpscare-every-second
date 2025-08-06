G.nxkoo_dies = {
    show_foxy = false,
    foxy_timer = 0,
    foxy_frames = {},
    foxy_frame_index = 1,
    foxy_frame_timer = 0,
    foxy_frame_delay = 0.1,
    path = SMODS.current_mod.path,
}

SMODS.Atlas {
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34,
    frames = 68,
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Sound{
    key = "fxy_jumpscare",
    path = "fnafjumpscare.ogg"
}

for i = 1, 14 do
    local full_path = G.nxkoo_dies.path .. "assets/customimages/foxy_" .. i .. ".png"
    local file_data = assert(NFS.newFileData(full_path))
    local image_data = assert(love.image.newImageData(file_data))
    G.nxkoo_dies.foxy_frames[i] = love.graphics.newImage(image_data)
end

local updatehook = Game.update
local foxy_check_timer = 0

function Game:update(dt)
    updatehook(self, dt)

    foxy_check_timer = (foxy_check_timer or 0) + dt
    if foxy_check_timer >= 1 then
        foxy_check_timer = foxy_check_timer - 1
        if math.random(1, 10000) == 1 then
            play_sound("fxy_jumpscare", 1, 1)
            G.nxkoo_dies.show_foxy = true
            G.nxkoo_dies.foxy_timer = 2
            G.nxkoo_dies.foxy_frame_index = 1
            G.nxkoo_dies.foxy_frame_timer = 0
        end
    end

    if G.nxkoo_dies.show_foxy then
        G.nxkoo_dies.foxy_timer = G.nxkoo_dies.foxy_timer - dt
        if G.nxkoo_dies.foxy_timer <= 0 then
            G.nxkoo_dies.show_foxy = false
        else
            G.nxkoo_dies.foxy_frame_timer = G.nxkoo_dies.foxy_frame_timer + dt
            if G.nxkoo_dies.foxy_frame_timer >= G.nxkoo_dies.foxy_frame_delay then
                G.nxkoo_dies.foxy_frame_timer = G.nxkoo_dies.foxy_frame_timer - G.nxkoo_dies.foxy_frame_delay
                G.nxkoo_dies.foxy_frame_index = G.nxkoo_dies.foxy_frame_index + 1
                if G.nxkoo_dies.foxy_frame_index > #G.nxkoo_dies.foxy_frames then
                    G.nxkoo_dies.foxy_frame_index = 1
                end
            end
        end
    end
end


local drawhook = love.draw
function love.draw()
    drawhook()

    local _xscale = love.graphics.getWidth() / 1920
    local _yscale = love.graphics.getHeight() / 1080

    if G.nxkoo_dies.show_foxy then
        local frame = G.nxkoo_dies.foxy_frames[G.nxkoo_dies.foxy_frame_index]
        if frame then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(frame, 0, 0, 0, _xscale, _yscale)
        end
    end
end

