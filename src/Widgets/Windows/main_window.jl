mutable struct MainWindow <: WindowDNA
    window::Window
    window_rect::Vec2F
    last_open::Bool
    tex::Union{Nothing, Texture2D}
    function MainWindow()
        new(Window(),Vec2F(0,0), false)
    end
end

_Window_(self::MainWindow)::Window = self.window

getWindowName(self::MainWindow) = "Main View"

function render(self::MainWindow, app::AppDNA)
    if (isVisible(self))
        if !self.last_open
            self.tex = Texture2D(self.window_rect.x, self.window_rect.y, GL_RGB, GL_RGB, GL_FLOAT)
        end
        self.last_open =true
        
        isVisible_Ref = Ref(isVisible(self))

        CImGui.Begin(getWindowName(self),isVisible_Ref)

        renderContent(self, app)

        CImGui.End()
        
        setVisible(self,isVisible_Ref[])
    elseif self.last_open
        self.last_open = false
        destroy!(self.tex)
        self.tex = nothing
    end
end


function renderContent(self::MainWindow, app::AppDNA)
    mousePositionAbsolute = CImGui.GetMousePos()
    screenPositionAbsolute = CImGui.GetItemRectMin()
    mousePositionRelative = CImGui.ImVec2(mousePositionAbsolute.x - screenPositionAbsolute.x, mousePositionAbsolute.y - screenPositionAbsolute.y)
    isHovered = CImGui.IsItemHovered()
    isFocused = CImGui.IsItemFocused()
    
    rect = CImGui.GetContentRegionAvail()
    rect = Vec2T{Float32}(min(rect.x, Float32(app._opengl._width)), min(rect.y, Float32(app._opengl._height)))
    if self.window_rect != rect
        self.window_rect = rect
        resize!(self.tex, Int(rect.x), Int(rect.y))
    end

    screen_size = Vec2T{Int32}(Int32(rect.x), Int32(rect.y))
    image = screen_capture(app._opengl, app._cam, app._hovered, true, screen_size)
    upload!(self.tex, image[1])

    CImGui.PushStyleVar(CImGui.ImGuiStyleVar_FramePadding, (0.0,0.0))
    clicked::Bool = CImGui.ImageButton("screen",CImGui.ImTextureRef(UInt64(self.tex._id)), (rect.x, rect.y), CImGui.ImVec2(0,1), CImGui.ImVec2(1,0))

    CImGui.PopStyleVar()

    

end