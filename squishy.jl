using Javis, Animations, Colors

function ground(args...)
    background("black")
    sethue("white")
end

function inner_evolve()
end



inner_anim(radius) = Animation(
    [0, .15, .55, 0.85, 1],
    [O, Point(0, radius), Point(0, -0.8 * radius),
     Point(0, 0.2 * radius), O],
    [linear(), expin(3.0), linear(), linear()]
)

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
        Point(0, -50),
        Point(0, 200-outer_radius),
        Point(0, 200-inner_radius),
        Point(0, 200-outer_radius),
        Point(0, -50)
    ],
    [polyin(2), linear(), linear(), polyout(2)]
)

video = Video(400, 400)
Background(1:T, ground)

# Floor
Object(1:T,
    JLine(
        Point(-100, 200), Point(100, 200),
        color = "darkgray",
        linewidth = 5,
    ),
)

l1 = @JLayer 1:T begin
    outer = Object(1:T, JEllipse(O, 2 * outer_radius, 2 * outer_radius;
                                 color = "white", action = :stroke,
                                 linewidth = 5.0))
    # inner = Object(1:T, JCircle(inner_radius; color = "white", action = :fill), O)
    act!(outer, Action((col - 1):(col + comp_steps),
                       change(:h, 2 * outer_radius => 2 * inner_radius)))
    act!(outer, Action((col + comp_steps):(col + 2 * comp_steps),
                       change(:h,  2 * inner_radius => 2 * outer_radius)))
    act!(outer, Action((col - 1):(col + comp_steps),
                       change(:w, 2 * outer_radius => 3.0 * outer_radius)))
    act!(outer, Action((col + comp_steps):(col + 2 * comp_steps),
                       change(:w,  3.0 * outer_radius => 2 * outer_radius)))
end

act!(l1, Action(1:T, outer_anim(col_frac, col_dur), translate()))

isdir("output") || mkdir("output")

render(
    video;
    # liveview=true,
    pathname = "output/squishy.mp4",
)
