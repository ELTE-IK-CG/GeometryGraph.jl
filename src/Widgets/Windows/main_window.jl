mutable struct MainWindow <: WindowDNA
    window::Window

    width::Int64
    height::Int64

    function MainWindow()
        new(Window(),0,0)
    end
end

_Window_(self::MainWindow)::Window = self.window

getWindowName(self::MainWindow) = "Main View"

function render(self::MainWindow, app::AppDNA)
    if (isVisible(self))
        isVisible_Ref = Ref(isVisible(self))

        CImGui.Begin(getWindowName(self),isVisible_Ref)

        renderContent(self, app)

        CImGui.End()
        
        setVisible(self,isVisible_Ref[])
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
    
    size = CImGui.GetContentRegionAvail()

    
    CImGui.PushStyleVar(CImGui.ImGuiStyleVar_FramePadding, (0.0,0.0))
    clicked::Bool = CImGui.ImageButton("screen",CImGui.ImTextureRef(UInt64(texture._id)), size, CImGui.ImVec2(0,1), CImGui.ImVec2(1,0))

    CImGui.PopStyleVar()

    width = Int64(size.x)
    height = Int64(size.y)
    if width != self.width | height != self.height
        resize!(app._glfw, Cint(width), Cint(height))
        resize!(app._opengl, width, height)
        app._cam.aspect = app._glfw.width / app._glfw.height
        calculate_projection_matrix!(app._cam)
        _updateScene!(app)
    end

end