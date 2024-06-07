tell application "Arc" to do JavaScript 
"
const vidSpeed = document.querySelector('video').playbackRate;
vidSpeed = (vidSpeed - .5) % 1.5) + 1;
 " in document 1
