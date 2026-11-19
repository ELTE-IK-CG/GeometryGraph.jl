mutable struct MainWindow <: WindowDNA
    window::Window
    function MainWindow()
        new(Window())
    end
end

_Window_(self::MainWindow)::Window = self.window

getWindowName(self::MainWindow) = "Main View"

function renderContent(self::MainWindow, app::AppDNA)
    texture::Texture2D = app._opengl._rgbaTexture
    CImGui.SetWindowSize((texture._width, texture._height))
    position = CImGui.GetCursorScreenPos()
    CImGui.AddImage(CImGui.GetWindowDrawList(), CImGui.ImTextureRef(UInt64(texture._id)), position, CImGui.ImVec2(position.x + texture._width, position.y + texture._height), CImGui.ImVec2(0,1), CImGui.ImVec2(1,0))
end