mutable struct MainWindow <: WindowDNA
    window::Window
    function MainWindow()
        new(Window())
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
    CImGui.SetWindowSize((texture._width, texture._height))
    position = CImGui.GetCursorScreenPos()
    size = CImGui.GetContentRegionAvail()
    
    CImGui.PushStyleVar(CImGui.ImGuiStyleVar_FramePadding, (0.0,0.0))
    clicked::Bool = CImGui.ImageButton("screen",CImGui.ImTextureRef(UInt64(texture._id)), size, CImGui.ImVec2(0,1), CImGui.ImVec2(1,0))
    CImGui.PopStyleVar()
    
    
end