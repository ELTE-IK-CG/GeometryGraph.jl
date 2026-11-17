import GeometryGraph as GG # no using + renaming to test macro hygiene
using GLUtils

p1 = GG.Point(0,0,0)

p2 = GG.@Point () -> p1 .- (0,0,1)

test_global = 1

p3 = let
    test_local = 2

    GG.@Point() do
        println("test_global is: $test_global")
        println("test_local is: $test_local")

        (p1.x, p1.y, p2.z + 2)
    end
end

# for testing inner macro expansion
macro avg(p, q)
    :(($(esc(p)) .+ $(esc(q))) ./ 2)
end

GG.@ParametricCurve(range(-2pi,2pi,500)) do t
    @avg(p2, p3) .+ (t,0,cos(t))
end

color = [(0.0,1.0,0.0),(0.0,0.0,1.0)]
GG.@ParametricCurve(range(-2pi,2pi,500), color=color, style=GG.ARROW, size=17) do t
    @avg(p2, p3) .+ (t,0,cos(t)) .- (0,0,1)
end

pc1 = GG.@PointSet() do
    [p .+ (0,1,0) for p in [p1, p2, p3]]
end

pc2 = GG.@PointSet(color=(1,0,0),size=40) do
    [p .+ (0,1,0) for p in pc1]
end

GG.@SegmentSequence() do
    points = [p1, p2, p3]
    [i % 2 == 0 ? points[Int(ceil(i/2))] : pc1[Int(ceil(i/2))] for i in 1:6]
end

GG.@SegmentSequence(color=[(1.0,0.0,0.0),(0.0,1.0,0.0)],size=8,style="<-") do
    [i % 2 == 0 ? pc1[Int(ceil(i/2))] : pc2[Int(ceil(i/2))] for i in 1:6]
end

GG.@SegmentSequence(3) do
    [p for p in [p1, p2, p3]]
end

cone_height = GG.Slider(1,4,10)

s1_base = GG.Point(2,2,0)
GG.@ParametricSurface(range(0,2pi,50),range(0,1,50)) do u, v
    x = 3v * sign(cos(u)) * abs(cos(u))^1.85
    y = 2v * sign(sin(u)) * abs(sin(u))^1.85
    z = cone_height * v

    return s1_base .+ (x,y,z)
end

s2_base = GG.Point(-2,2,0)
GG.@ParametricSurface(range(0,2pi,50),range(0,1,50), color=(0.0,0.0,1.0,0.5)) do u, v
    x = 3v * sign(cos(u)) * abs(cos(u))^1.85
    y = 2v * sign(sin(u)) * abs(sin(u))^1.85
    z = cone_height * v

    return s2_base .+ (x,y,z)
end

t = GG.Toggle()

GG.@TextBox(() -> "Toggle is $(t ? "on" : "off"), cone_height slider is at $cone_height")

v = GG.@add_node!(() -> t)

GG.@TextBox() do 
    return "toggle through wrapper node: $(v)"
end

GG.Wait()
