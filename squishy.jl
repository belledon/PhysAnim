using Javis, Animations, Colors

function ground(args...)
    background("black")
    sethue("white")
end

function inner_evolve()
end

outer_anim(col_frac) = Animation(
    [0, col_frac, 1],
    [Point(0, -50), Point(0, 170), Point(0, -50)],
    [polyin(2), polyout(2)]
)


inner_anim(radius) = Animation(
    [0, .15, .55, 0.85, 1],
    [O, Point(0, radius), Point(0, -0.8 * radius),
     Point(0, 0.2 * radius), O],
    [linear(), expin(3.0), linear(), linear()]
)

T = 100
col_frac = 0.5
col = ceil(Int64, col_frac * T)
impulse_start = col # - 1
impulse_end = col + 15
outer_radius = 30
inner_radius = 10
diff_radii = outer_radius - inner_radius


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
    outer = Object(1:T, JCircle(outer_radius; color = "white", action = :stroke,
                                linewidth = 5.0), O)
    inner = Object(1:T, JCircle(inner_radius; color = "white", action = :fill), O)
    act!(inner, Action(impulse_start:impulse_end,
                       inner_anim(diff_radii),
                       translate()))
end

act!(l1, Action(1:T, outer_anim(col_frac), translate()))

isdir("output") || mkdir("output")

render(
    video;
    # liveview=true,
    pathname = "output/squishy.mp4",
)
