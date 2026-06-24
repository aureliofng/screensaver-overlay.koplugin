local UIManager = require("ui/uimanager")
local InfoMessage = require("ui/widget/infomessage")
local InputDialog = require("ui/widget/inputdialog")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local ImageWidget = require("ui/widget/imagewidget")
local RenderImage = require("ui/renderimage")
local lfs = require("libs/libkoreader-lfs")
local _ = require("gettext")
local Geom = require("ui/geometry")
local Screen = require("device").screen
local logger = require("logger")

local ScreensaverOverlay = WidgetContainer:extend{
    name = "screensaver_overlay",
    images_folder = "/mnt/onboard/.adds/screensaver_overlay/",
    current_widget = nil,
    current_image = nil,
    had_activity = true,
}

function ScreensaverOverlay:init()
    if not self.ui or not self.ui.menu then return end
    local saved = G_reader_settings:readSetting("screensaver_overlay_folder")
    if saved then
        self.images_folder = saved
    end
    self.ui.menu:registerToMainMenu(self)
end

-- Paso de página = hubo actividad
function ScreensaverOverlay:onPageUpdate()
    self.had_activity = true
end

function ScreensaverOverlay:getRandomImage()
    local images = {}
    local folder = self.images_folder
    if lfs.attributes(folder, "mode") ~= "directory" then
        return nil
    end
    for file in lfs.dir(folder) do
        if file ~= "." and file ~= ".." then
            local ext = file:match("%.(%a+)$")
            if ext and ext:lower() == "png" then
                local full_path = folder .. file
                if full_path ~= self.current_image then
                    table.insert(images, full_path)
                end
            end
        end
    end
    if #images == 0 then
        return self.current_image
    end
    math.randomseed(os.time())
    return images[math.random(#images)]
end

-- Widget transparente a toques
local PassthroughImageWidget = WidgetContainer:extend{}
function PassthroughImageWidget:onTapSelect() return false end
function PassthroughImageWidget:onHoldSelect() return false end
function PassthroughImageWidget:onPan() return false end
function PassthroughImageWidget:onSwipe() return false end

function ScreensaverOverlay:showOverlay()
    if self.current_widget ~= nil then return end

    -- Cambiar imagen solo si hubo actividad desde el último bloqueo
    if self.had_activity or self.current_image == nil then
        self.current_image = self:getRandomImage()
        self.had_activity = false
    end

    if self.current_image == nil then return end

    local screen_w = Screen:getWidth()
    local screen_h = Screen:getHeight()

    -- RenderImage escala al cargar para no agotar memoria
    local bb = RenderImage:renderImageFile(self.current_image, false, screen_w, screen_h)
    if not bb then
        logger.warn("ScreensaverOverlay: no se pudo renderizar", self.current_image)
        return
    end

    local image_widget = ImageWidget:new{
        image = bb,
        image_disposable = true,
        width = screen_w,
        height = screen_h,
        scale_factor = 0,
        alpha = true,
    }

    local overlay = PassthroughImageWidget:new{
        dimen = Geom:new{ x = 0, y = 0, w = screen_w, h = screen_h },
        image_widget,
    }

    self.current_widget = overlay
    overlay.modal = true
    overlay.dithered = true
    UIManager:show(overlay, "full")
    UIManager:forceRePaint()
end

function ScreensaverOverlay:hideOverlay()
    if self.current_widget ~= nil then
        UIManager:close(self.current_widget)
        self.current_widget = nil
        UIManager:forceRePaint()
    end
end

function ScreensaverOverlay:onSuspend()
    self:showOverlay()
end

function ScreensaverOverlay:onResume()
    self:hideOverlay()
end

function ScreensaverOverlay:addToMainMenu(menu_items)
    menu_items.screensaver_overlay = {
        text = _("Screensaver Overlay"),
        sorting_hint = "more_tools",
        sub_item_table = {
            {
                text_func = function()
                    return _("Carpeta: ") .. self.images_folder
                end,
                keep_menu_open = true,
                callback = function()
                    local input_dialog
                    input_dialog = InputDialog:new{
                        title = _("Ruta de la carpeta"),
                        input = self.images_folder,
                        buttons = {
                            {
                                {
                                    text = _("Cancelar"),
                                    callback = function()
                                        UIManager:close(input_dialog)
                                    end,
                                },
                                {
                                    text = _("Guardar"),
                                    is_enter_default = true,
                                    callback = function()
                                        local path = input_dialog:getInputText()
                                        if path:sub(-1) ~= "/" then
                                            path = path .. "/"
                                        end
                                        self.images_folder = path
                                        G_reader_settings:saveSetting("screensaver_overlay_folder", path)
                                        UIManager:close(input_dialog)
                                    end,
                                },
                            },
                        },
                    }
                    UIManager:show(input_dialog)
                end,
            },
            {
                text = _("Probar overlay ahora"),
                callback = function()
                    local ok, err = pcall(function() self:showOverlay() end)
                    if not ok then
                        UIManager:show(InfoMessage:new{ text = "Error: " .. tostring(err) })
                    end
                end,
            },
            {
                text = _("Cerrar overlay"),
                callback = function()
                    self:hideOverlay()
                end,
            },
        },
    }
end

return ScreensaverOverlay
