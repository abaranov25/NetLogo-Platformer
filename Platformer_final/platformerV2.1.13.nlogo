;GOALS:
   ;create death by lava (so respawn points on each level) DONE
   ;fix glitch in horizontal world wrap DONE
   ;more levels
   ;level fusion (yellow door leads to next level) DONE
   ;add blue doors to all levels and upload to common server DONE
   ;level 19
   ;intro outro

globals [main setupComplete spawnxcor spawnycor level scoreround scoretotal ti tf] ;tracks controllable turtle, used in setup, used for respawning
turtles-own [disX disY vX vY aX aY jumpToken dir] ;displacement, velocity, acceleration vectors, jumptoken, direction

;mechanics

to intro
  if level = 0 [
    ca
    resize-world -150 150 -150 150
    set-patch-size 1.6
    import-pcolors "intro.png"
    set level -5.9
  ]
  if level <= -6 [
    set level 0
  ]
  if level = -5 [
    resize-world -16 16 -16 16
    set-patch-size 14.6
    intro2
    set level -4.9
  ]
  if level = -4 [
    intro3
    set level -3.9
  ]
  if level = -3 [
    intro4
    set level -2.9
  ]
  if level = -2 [
    set level 1.1
    resize-world -16 16 -16 16
    set-patch-size 14.6
  ]
end

to intro2 ;instructions 1
  ca
  ask patch 14 -7 [
    set plabel "Hold Down Mouse Button To Move"]
  ask patches with [pycor = 1 and (pxcor >= -4 and pxcor <= 4)] [
    set pcolor white]
  cro 1 [set size 4 setxy 0 1.5]
  ask patch 3 3 [
    set plabel "->"]
  ask patch -2 3 [
    set plabel "<-"]
  ask patch 15 -15 [
    set plabel "E NEXT ->"]
  ask patch -7 -15 [
    set plabel "<- BACK Q"]
end

to intro3 ;instructions 2
  ca
  cro 1 [set size 4 setxy -9 1.5]
  cro 1 [set size 4 setxy 9 4]
  ask patches with [pycor = 1 and ((pxcor >= -12 and pxcor <= -9) or (pxcor >= 5 and pxcor <= 8))] [
    set pcolor white]
  ask patches with [pycor = 4 and ((pxcor >= -6 and pxcor <= -3) or (pxcor >= 11 and pxcor <= 14))] [
    set pcolor white]
  ask patch 7 -4 [
    set plabel "Press  W  To Jump"]
  ask patch 9 -8 [
    set plabel "Check Info Tab For More"]
  ask patch 7 -10 [
    set plabel "Jumping Mechanics"]
  ask patch 15 -15 [
    set plabel "E NEXT ->"]
  ask patch -7 -15 [
    set plabel "<- BACK Q"]
end

to intro4 ;instructions 3
  ca
  ask patches with [pxcor = -14] [
    if pycor = 12 or pycor = 11 [
      set pcolor blue]
    if pycor = 6 or pycor = 5 [
      set pcolor yellow]
    if pycor = 0 or pycor = -1 [
      set pcolor red]
    if pycor = -6 or pycor = -7 [
      set pcolor white]
  ]
  ask patch 12 11 [
    set plabel "Spawn Point"]
  ask patch 12 5 [
    set plabel "Goal"]
  ask patch 12 -1 [
    set plabel "Lava"]
  ask patch 12 -7 [
    set plabel "Platform"]
  ask patch 15 -15 [
    set plabel "E NEXT ->"]
  ask patch -7 -15 [
    set plabel "<- BACK Q"]
end


to setup ;allows setup2 to be lodged in forever button
  ca
  set setupComplete 0
  set level 0
end

;sets local vector field

to levelsetup
  cro 1 [
      set size 4
      set main who
      set disX 0
      set disY 0
      set vX 0
      set vY 0
      set aX 0
      set aY -12.5
    ]
    cro 3 [set hidden? true set shape "lbound" set heading 0] ;left hitbox creation
    cro 3 [set hidden? true set shape "rbound" set heading 0] ;right hitbox creation
    cro 2 [set hidden? true set shape "ubound" set heading 0] ;up hitbox creation
    cro 2 [set hidden? true set shape "dbound" set heading 0] ;down hitbox creation
end

to setup2 ;creates turtle
  if setupComplete = 0 [
    ask turtles [die]
    ask patches [set plabel ""]
    cro 1 [
      set size 4
      set main who
      set disX 0
      set disY 0
      set vX 0
      set vY 0
      set aX 0
      set aY -12.5
    ]
    cro 3 [set hidden? true set shape "lbound" set heading 0] ;left hitbox creation
    cro 3 [set hidden? true set shape "rbound" set heading 0] ;right hitbox creation
    cro 2 [set hidden? true set shape "ubound" set heading 0] ;up hitbox creation
    cro 2 [set hidden? true set shape "dbound" set heading 0] ;down hitbox creation
    ask patches [level1]
    set level 1.1
    set setupComplete 1
  ]
end

;calculate vf:
;vf=vi+at
;t=.002 (500 fps)

to calcVf
  set vX (vX + aX * .002)
  set vY (vY + aY * .002)
end

;calculate dis
;dis=vt
;t=.002 (500 fps)

to calcDisf
  set disX (vX * .002)
  set disY (vY * .002)
end

;moves based on displacement

to move
  ask turtles with [shape = "default"] [
    calcVf
    calcDisf
    set xcor (xcor + disX)
    ifelse (pcolor != white)
      [set ycor (ycor + disY)]
      [ifelse ycor - pycor > .47 and ycor - pycor < .51
          [set vx 0 set vy 0]
          [set ycor (ycor + disY)]
      ]
    wait .002
  ]
end

;primitive movements

to moveX ;horizontal movement
  ask turtles with [shape = "default"] [
  ifelse mouse-down? = true [
    ifelse mouse-xcor < -15
    [set vX -5]
    [ifelse mouse-xcor > 15
      [set vX 5]
      [ifelse [xcor] of turtle main < mouse-xcor
        [set vX 5]
        [set vX -5]
      ]
    ]
  ]
  [set vX 0]]
end

to moveXnonprim
  ask turtles with [shape = "default"] [
    ifelse mouse-down? = true [
      ifelse mouse-xcor < [xcor] of turtle main
        [set vX -5]
        [set vX 5]
    ]
    [set vX 0]
  ]
end

to jumpY ;vertical movement
  if ucolor = white [set jumpToken 1]
  if shape = "default" [
    if jumpToken = 1 [
      set ycor (ycor + .1)
      set jumpToken 0
      set vY 10
    ]
  ]
end

;allows jumps while not stationary
;jumpTokenCheck replenishes when on platform
;it allows for 1 jump before not being able to jump (no double jumping!!)

to jumpTokenCheck
  ask turtles [
    if ucolor = white [
      set jumpToken 1
    ]
  ]
end

;ucolor = pcolor of main turtle

to-report ucolor ;report pcolor of turtle main
  report [pcolor] of patch [xcor] of turtle main [ycor] of turtle main
end

;hitboxes

to lbound ;left hitboxes
  ask turtles with [shape = "lbound"] [
  if color = gray [
      setxy ([xcor] of turtle main - .6) ([ycor] of turtle main + 1)
      if pcolor = white [
        ask turtle main [set vx 0 set xcor xcor + .001]
      ]
    ]
  if color = red [
      setxy ([xcor] of turtle main - .43) ([ycor] of turtle main + 1.7)
      if pcolor = white [
        ask turtle main [set vx 0 set xcor xcor + .001]
      ]
    ]
  if color = orange [
      setxy ([xcor] of turtle main - .6) ([ycor] of turtle main + .2)
      if pcolor = white [
        ask turtle main [set vx 0 set xcor xcor + .001]
      ]
    ]
  ]
end

to rbound ;right hitboxes
  ask turtles with [shape = "rbound"] [
  if color = gray [
    setxy ([xcor] of turtle main + .6) ([ycor] of turtle main + 1)
    if pcolor = white [
        ask turtle main [set vx 0 set xcor xcor - .001]
    ]
  ]
  if color = red [
      setxy ([xcor] of turtle main + .43) ([ycor] of turtle main + 1.7)
      if pcolor = white [ask turtle main [set vx 0 set xcor xcor - .001]]]
  if color = orange [
      setxy ([xcor] of turtle main + .6) ([ycor] of turtle main + .2)
      if pcolor = white [
        ask turtle main [set vx 0 set xcor xcor - .001]
      ]
    ]
  ]
end

to ubound ;up hitboxes
  ask turtles with [shape = "ubound"] [
  if color = gray [
      setxy ([xcor] of turtle main + .2) ([ycor] of turtle main + 2)
      if pcolor = white [
        ask turtle main [set vy 0 set ycor ycor - .001]
      ]
    ]
  if color = red [
      setxy ([xcor] of turtle main - .2) ([ycor] of turtle main + 2)
      if pcolor = white [
        ask turtle main [set vy 0 set ycor ycor - .001]
      ]
    ]
  ]
end

to dbound ;down hitboxes
  ask turtles with [shape = "dbound"] [
  if color = gray [
      setxy ([xcor] of turtle main + .2) ([ycor] of turtle main + .001)
      if pcolor = white [
        ask turtle main [set vy 0 set ycor ycor + .001]
      ]
    ]
  if color = red [
      setxy ([xcor] of turtle main - .2) ([ycor] of turtle main + .001)
      if pcolor = white [ask turtle main [set vy 0 set ycor ycor + .001]]]
  ]
end

to lava ;hitboxes react to lava
  if (shape = "dbound") or (shape = "lbound") or (shape = "ubound") or (shape = "rbound") [
    if pcolor = red [
      ask patches with [pcolor = blue] [
        if [pcolor] of patch (pxcor) (pycor - 1) = blue [set spawnxcor pxcor set spawnycor pycor]
      ]
      ask turtle main [
        set xcor spawnxcor
        set ycor spawnycor - 1.5
        set vX 0
        set vY 0
      ]
    ]
  ]
end

;levels (will delete)

to level1
  set pcolor black
  if pycor = -10 and (-14 < pxcor) and (-6 > pxcor) [set pcolor white]
  if pycor = -6 and (- 5 < pxcor ) and (3 > pxcor) [set pcolor white]
  if pycor = -2 and (4 < pxcor) and (12 > pxcor) [set pcolor white]
  if pycor < -14 [set pcolor red]
  if pxcor = 10 and (pycor = -1 or pycor = 0) [set pcolor yellow]
  if pxcor = -12 and (pycor = -9 or pycor = -8) [set pcolor blue]
  spawn
end

to level3 ;will convert to .csv
  if pycor = -10 and (-13 < pxcor) and (-5 > pxcor) [set pcolor white]
  if pycor = 10 and (5 < pxcor) and (13 > pxcor) [set pcolor white]
  if pxcor = 11 and (pycor = 11 or pycor = 12) [set pcolor yellow]
end

to spawn
  ask patches with [pcolor = blue] [
    if [pcolor] of patch (pxcor) (pycor - 1) = blue [set spawnxcor pxcor set spawnycor pycor]
  ]
  ask turtle main [
    set xcor spawnxcor
    set ycor spawnycor - 1.5
    set vX 0
    set vY 0
  ]
end

to lsetup [x] ;setup for each level, for convenience in levelnext procedure
  set level x + .1
  set setupComplete 1
  levelsetup
  spawn
end

to levelnext ;must plug commands for every level
  ask turtle main [
    if [pcolor] of patch xcor (ycor + 1) = yellow [
      set level level + .9
    ]
  ]
  if level = 2 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level2.csv"
    Set scoreround 1000
    set ti timer
    lsetup 2
  ]
  if level = 3 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level3.csv"
    Set scoreround 1000
    set ti timer
    lsetup 3
  ]
  if level = 4 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level4.csv"
    Set scoreround 1000
    set ti timer
    lsetup 4
  ]
  if level = 5 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level5.csv"
    Set scoreround 1000
    set ti timer
    lsetup 5
  ]
  if level = 6 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level6.csv"
    Set scoreround 1000
    set ti timer
    lsetup 6
  ]
  if level = 7 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level7.csv"
    Set scoreround 1000
    set ti timer
    lsetup 7
  ]
  if level = 8 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level8.csv"
    Set scoreround 1000
    set ti timer
    lsetup 8
  ]
  if level = 9 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level9.csv"
    Set scoreround 1000
    set ti timer
    lsetup 9
  ]
  if level = 10 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level10.csv"
    Set scoreround 1000
    set ti timer
    lsetup 10
  ]
  if level = 11 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level11.csv"
    Set scoreround 1000
    set ti timer
    lsetup 11
  ]
  if level = 12 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level12.csv"
    Set scoreround 1000
    set ti timer
    lsetup 12
  ]
  if level = 13 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level13.csv"
    Set scoreround 1000
    set ti timer
    lsetup 13
  ]
  if level = 14 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level14.csv"
    Set scoreround 1000
    set ti timer
    lsetup 14
  ]
  if level = 15 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level15.csv"
    Set scoreround 1000
    set ti timer
    lsetup 15
  ]
  if level = 16 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level16.csv"
    Set scoreround 1000
    set ti timer
    lsetup 16
  ]
  if level = 17 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level17.csv"
    Set scoreround 1000
    set ti timer
    lsetup 17
  ]
  if level = 18 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level18.csv"
    Set scoreround 1000
    set ti timer
    lsetup 18
  ]
  if level = 19 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level19.csv"
    Set scoreround 1000
    set ti timer
    lsetup 19
  ]
  if level = 20 [
    set-patch-size patch-size + (floor (scoreround) / 1000000)
    import-world "level20.csv"
    Set scoreround 1000
    set ti timer
    lsetup 20
  ]
  if level = 21 [
    scoringtotal
    resize-world -150 150 -150 150
    set-patch-size 1.6
    import-pcolors "outro.jpg"
    ask patch 120 -119 [set pcolor white]
    ask patch 120 -123 [set pcolor white]
    ask patch 120 -121 [set pcolor blue]
    ask patch 120 -122 [set pcolor blue]
    ask patch 119 -121 [set pcolor white]
    ask patch 121 -121 [set pcolor white]
    lsetup 21
    ask patch 138 -140 [
      set plabel "Thanks For Playing!"
      set plabel-color red]
  ]
end

to scoringround
  set tf timer
  set scoreround (1000 - 10 * sqrt(10 * (tf - ti)))
end
to scoringtotal
  set scoretotal ((patch-size - 14.6) * 1000000)
end
@#$#@#$#@
GRAPHICS-WINDOW
419
10
908
500
-1
-1
1.6
1
26
1
1
1
0
1
1
1
-150
150
-150
150
0
0
1
ticks
30.0

BUTTON
69
239
143
272
NIL
jumpY
NIL
1
T
TURTLE
NIL
W
NIL
NIL
1

BUTTON
72
149
147
182
Play
ifelse level <= 0\n[intro]\n[setup2\nmove\nmoveX\nlbound\nrbound\nubound\ndbound\njumpTokenCheck\nscoringround\nask turtles [lava]\nlevelnext]
T
1
T
OBSERVER
NIL
P
NIL
NIL
1

BUTTON
156
239
220
272
Reset
setup
NIL
1
T
OBSERVER
NIL
R
NIL
NIL
1

MONITOR
158
138
215
183
NIL
level
0
1
11

BUTTON
76
195
139
228
Back
if level <= 1.1\n[set level level - 1.1]
NIL
1
T
OBSERVER
NIL
Q
NIL
NIL
1

BUTTON
152
194
215
227
Next
set level level + .9
NIL
1
T
OBSERVER
NIL
E
NIL
NIL
1

MONITOR
305
215
401
260
Round Score
scoreround
0
1
11

MONITOR
305
283
391
328
Final Score
scoretotal
0
1
11

MONITOR
168
372
247
417
NIL
patch-size
17
1
11

@#$#@#$#@
## >>> INSTRUCTIONS <<<

Click Play to begin the game
Click Reset to start from the beginning
Make sure mouse is not in command center
Hold down mouse to move (player moves towards mouse)
Press W to jump

## >>> GAME STRUCTURE <<<

White: You can land on white platforms, but you cannot jump through them.
Red: Lava will kill you and send you back to the spawn point.
Blue: Your starting point for each level. If you die, you will respawn here.
Yellow: This is your target. Go to the yellow doors to clear the level.

Jumping: There is no double jumping, but you can jump in the air if you fall off a platform.

[IMPORTANT] The world wraps horizontally and vertically.
@#$#@#$#@
default
true
0
Circle -7500403 true true 120 0 60
Rectangle -7500403 true true 142 45 157 75
Polygon -7500403 true true 105 60 195 60 165 90 165 120 180 150 150 135 120 150 135 120 135 90 105 60
Polygon -13840069 true false 120 60 120 75 135 90 135 120 165 120 165 90 180 75 180 60 120 60

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

control
true
0
Circle -7500403 true true 0 0 300
Rectangle -16777216 true false 135 135 165 240
Polygon -16777216 false false 90 135 210 135 150 60 90 135
Polygon -16777216 true false 90 135 210 135 150 60 90 135

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dbound
true
0
Rectangle -7500403 true true 15 120 285 150

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

lbound
true
0
Rectangle -7500403 true true 150 15 180 285

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rbound
true
0
Rectangle -7500403 true true 120 15 150 285

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

ubound
true
0
Rectangle -7500403 true true 15 150 285 180

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
