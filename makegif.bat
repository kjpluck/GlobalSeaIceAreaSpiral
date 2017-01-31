

ffmpeg -v warning -i processing-movie.mp4 -vf "palettegen" -y palette.png
ffmpeg -v warning -i processing-movie.mp4 -i palette.png -lavfi "paletteuse" -y GlobalSeaIceAreaSpiral.gif