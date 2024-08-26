using Javis, Animations, Colors

function ground(args...)
    background("black")
    sethue("white")
end

outer_anim(col_frac, col_dur, inner, outer) = Animation(
    [0, col_frac, col_frac + col_dur, col_frac + 2 * col_dur, 1],
    [
        Point(0, -div(Y, 2)+3*outer),
        Point(0, (div(Y, 2)-outer)),
        Point(0, (div(Y, 2)-inner)),
        Point(0, (div(Y, 2)-outer)),
        Point(0, -div(Y, 2)+3*outer)
    ],
    [polyin(2), linear(), linear(), polyout(2)]
)

function squishy_movie(
    change_color = false,
    Y = 600,
    T = 100,
    col_frac = 0.5,
    col_dur = 0.03,
    col = ceil(Int64, col_frac * T),
    comp_steps = ceil(Int64, col_dur * T),
    impulse_start = col - 5,
    impulse_end = col + 5,
    ball_radius = 30,
    inner_radius = 20,
    diff_radii = outer_radius - inner_radius
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
        ball = Object(1:T, JEllipse(O, 2 * ball_radius, 2 * ball_radius;
                                     color = Lab(RGB(0.4, 0.4, 0.3)),
                                     action = :fill))
        act!(ball, Action((col - 1):(col + comp_steps),
                           change(:h, 2 * ball_radius => 2 * inner_radius)))
        act!(ball, Action((col + comp_steps):(col + 2 * comp_steps),
                           change(:h,  2 * inner_radius => 2 * ball_radius)))
        act!(ball, Action((col - 1):(col + comp_steps),
                           change(:w, 2 * ball_radius => 3.0 * ball_radius)))
        act!(ball, Action((col + comp_steps):(col + 2 * comp_steps),
                           change(:w,  3.0 * ball_radius => 2 * ball_radius)))
        if change_color
            act!(outer, Action((col + 6 * comp_steps):T,
                               change(:color, Lab(RGB(0.3, 0.4, 0.4)))))
        end
    end
    act!(l1, Action(1:T, outer_anim(col_frac, col_dur), translate()))

    # Occluder
    OCC_W = 4 * ball_radius
    OCC_H = 6 * ball_radius
    OCC_P = O - Point(div(OCC_W, 2), div(OCC_H, 2) - 20)
    l2 = @JLayer 1:T begin
        Object(1:T, JRect(OCC_P, OCC_W, OCC_H,  color = "white", action=:fill))
    end

    isdir("output") || mkdir("output")

    render(
        video;
        liveview=true,
        # pathname = "output/squishy.mp4",
    )
end;

squishy_movie();
