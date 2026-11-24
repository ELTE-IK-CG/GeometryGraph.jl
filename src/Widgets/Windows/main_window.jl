mutable struct MainWindow <: WindowDNA
    window::Window
    window_rect::Vec4F
    last_open::Bool
    function MainWindow()
        new(Window(),Vec4F(0,0,0,0), false)
    end
end

_Window_(self::MainWindow)::Window = self.window

getWindowName(self::MainWindow) = "Main View"

function render(self::MainWindow, app::AppDNA)
    if (isVisible(self))
        if !self.last_open
            enable_subviewport(app, self.window_rect)
            
        end
        self.last_open =true
        
        isVisible_Ref = Ref(isVisible(self))

        CImGui.Begin(getWindowName(self),isVisible_Ref, CImGui.ImGuiWindowFlags_NoBackground)

        renderContent(self, app)

        CImGui.End()
        
        setVisible(self,isVisible_Ref[])
    elseif self.last_open
        
        disable_subviewport(app)
        
        self.last_open =false
    end
end


function renderContent(self::MainWindow, app::AppDNA)
    texture::Texture2D = app._opengl._rgbaTexture
    io = CImGui.GetIO()
    #CImGui.SetWindowSize((texture._width, texture._height))
    mousePositionAbsolute = CImGui.GetMousePos()
    screenPositionAbsolute = CImGui.GetItemRectMin()
    mousePositionRelative = CImGui.ImVec2(mousePositionAbsolute.x - screenPositionAbsolute.x, mousePositionAbsolute.y - screenPositionAbsolute.y)
    isHovered = CImGui.IsItemHovered()
    isFocused = CImGui.IsItemFocused()
    
    size = CImGui.GetWindowSize()

    
    CImGui.PushStyleVar(CImGui.ImGuiStyleVar_FramePadding, (0.0,0.0))
    #clicked::Bool = CImGui.ImageButton("screen",CImGui.ImTextureRef(UInt64(texture._id)), size, CImGui.ImVec2(0,1), CImGui.ImVec2(1,0))

    CImGui.PopStyleVar()

    rect = Vec4F(
        screenPositionAbsolute.x,
        app._glfw.height - screenPositionAbsolute.y - size.y - CImGui.GetFrameHeight(),
        size.x,
        size.y - CImGui.GetFrameHeight()
    )
     if self.window_rect != rect
        self.window_rect = rect
        subwindow_resize!(app, rect)
        _updateScene!(app)
     end

end