// Paramters
const Y_EXT = 400;
const BALL_RADIUS = 50;
const BALL_SQUISH_Y = 0.66;
const BALL_EXPAND_X = 1.75;
const T_FALL = 500;
const T_SQUISH = 100;
const T_TOTAL = 2 * T_FALL + T_SQUISH;
const PCT_CHANGE_COLOR = 0.1;

const controlsProgressEl = document.querySelector(".controls .progress");
const frameCounter = document.getElementById("animframe");
const ballEl = document.getElementById("ball");
const boxEl = document.getElementById("box");

// from https://stackoverflow.com/a/49833666
function isBehindOccluder() {
  const boundingRect = ballEl.getBoundingClientRect();
  // adjust coordinates to get more accurate results
  const left = boundingRect.left + 1;
  const right = boundingRect.right - 1;
  const top = boundingRect.top + 1;
  const bottom = boundingRect.bottom - 1;
  return (
    boxEl.contains(document.elementFromPoint(left, top)) &
    boxEl.contains(document.elementFromPoint(right, top)) &
    boxEl.contains(document.elementFromPoint(left, bottom)) &
    boxEl.contains(document.elementFromPoint(right, bottom))
  );
}

// initialize animation timeline
let tl = anime.timeline({
  targets: "#ball",
  easing: "linear",
  autoplay: false,
  loop: true,
  easing: "easeInOutQuad",
  update: function (anim) {
    controlsProgressEl.value = Math.round(anim.progress);
    const ms = Math.round((anim.progress * tl.duration) / 100);
    frameCounter.innerHTML = `Time (ms): ${ms}`;
    if (isBehindOccluder() & (Math.random() < PCT_CHANGE_COLOR)) {
      console.log("changing color =)");
      tl.set("#ball", { background: "red" });
    }
  },
});

document.querySelector(".controls .play").onclick = tl.play;
document.querySelector(".controls .pause").onclick = tl.pause;
document.querySelector(".controls .reverse").onclick = tl.reverse;
document.querySelector(".controls .restart").onclick = tl.restart;

// starting location
tl.set("#ball", {
  translateY: -Y_EXT,
});

tl.add({
  translateY: { value: Y_EXT - BALL_RADIUS, duration: T_FALL },
  easing: "easeInQuad",
});

tl.add({
  translateY: [
    { value: Y_EXT - BALL_RADIUS * BALL_SQUISH_Y },
    { value: Y_EXT - BALL_RADIUS },
  ],
  scaleX: [{ value: BALL_EXPAND_X }, { value: 1 }],
  scaleY: [{ value: BALL_SQUISH_Y }, { value: 1 }],
  duration: T_SQUISH,
  easing: "linear",
});

tl.add({
  translateY: { value: -Y_EXT, duration: T_FALL },
  easing: "easeOutQuad",
});

controlsProgressEl.addEventListener("input", function () {
  const frame = tl.duration * (controlsProgressEl.value / 100);
  frameCounter.innerHTML = `Time (ms): ${Math.round(frame)}`;
  tl.seek(frame);
});
