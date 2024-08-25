using Javis, Animations, Colors
using Luxor: setmode

function ground(args...)
    background("black")
    sethue("white")
end

inner_anim(radius) = Animation(
    [0, .15, .55, 0.85, 1],
    [O, Point(0, radius), Point(0, -0.8 * radius),
     Point(0, 0.2 * radius), O],
    [linear(), expin(3.0), linear(), linear()]
)

Y = 600
T = 100
col_frac = 0.5
col_dur = 0.03
col = ceil(Int64, col_frac * T)
comp_steps = ceil(Int64, col_dur * T)
impulse_start = col - 5
impulse_end = col + 5
outer_radius = 30
inner_radius = 20
diff_radii = outer_radius - inner_radius

outer_anim(col_frac, col_dur) = Animation(
    [0, col_frac, col_frac + col_dur, col_frac + 2 * col_dur, 1],
    [
        Point(0, -div(Y, 2)+3*outer_radius),
        Point(0, (div(Y, 2)-outer_radius)),
        Point(0, (div(Y, 2)-inner_radius)),
        Point(0, (div(Y, 2)-outer_radius)),
        Point(0, -div(Y, 2)+3*outer_radius)
    ],
    [polyin(2), linear(), linear(), polyout(2)]
)

# color_anim = Animation(
#     [0.0,1.0], # must go from 0 to 1
#     [
#         Lab(RGB(1.0, 0.0, 0.0)),
#         Lab(RGB(0.0, 0.0, 1.0))],
#     linear(),
# )

color_anim = Animation(
    [0, 0.5, 1], # must go from 0 to 1
    [
        Lab(colorant"red"),
        Lab(colorant"cyan"),
        Lab(colorant"black"),
    ],
    [sineio(), sineio()],
)

video = Video(400, Y)
Background(1:T, ground)

# Floor
Object(1:T,
    JLine(
        Point(-100, div(Y, 2)), Point(100, div(Y, 2)),
        color = "white",
        linewidth = 5,
    ),
)


# Ball
l1 = @JLayer 1:T begin
    outer = Object(1:T, JEllipse(O, 2 * outer_radius, 2 * outer_radius;
                                 color = Lab(RGB(1.0, 0.0, 0.0)),
                                 action = :fill))
    # inner = Object(1:T, JCircle(inner_radius; color = "white", action = :fill), O)
    act!(outer, Action((col - 1):(col + comp_steps),
                       change(:h, 2 * outer_radius => 2 * inner_radius)))
    act!(outer, Action((col + comp_steps):(col + 2 * comp_steps),
                       change(:h,  2 * inner_radius => 2 * outer_radius)))
    act!(outer, Action((col - 1):(col + comp_steps),
                       change(:w, 2 * outer_radius => 3.0 * outer_radius)))
    act!(outer, Action((col + comp_steps):(col + 2 * comp_steps),
                       change(:w,  3.0 * outer_radius => 2 * outer_radius)))
    act!(outer, Action(30:T, change(:color, "blue")))


end
act!(l1, Action(1:T, outer_anim(col_frac, col_dur), translate()))

# Occluder
OCC_W = 4 * outer_radius
OCC_H = 6 * outer_radius
OCC_P = O - Point(div(OCC_W, 2), div(OCC_H, 2) + 10)
l2 = @JLayer 1:T begin
    Object(1:T, JRect(OCC_P, OCC_W, OCC_H,  color = "white", action=:fill))
end

isdir("output") || mkdir("output")

render(
    video;
    liveview=true,
    # pathname = "output/squishy.mp4",
)
