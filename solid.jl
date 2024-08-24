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
    outer = Object(1:T, JEllipse(O, 2 * outer_radius, 2 * outer_radius;
                                 color = "white", action = :stroke,
                                 linewidth = 5.0))
end

act!(l1, Action(1:T, outer_anim(col_frac), translate()))

isdir("output") || mkdir("output")

render(
    video;
    # liveview=true,
    pathname = "output/solid.mp4",
)
