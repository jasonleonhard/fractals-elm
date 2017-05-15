import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)

main =
    let
        a = (Point 0 0)
        b = (Point 1 0)
        init = (Line a b)
    in
        render (cantorStep init)

type alias Point = { x: Float, y: Float }

type alias Line = { a: Point, b: Point}

-- the Cantor dust is a 0.63-dimensional fractal, it is is compact, totally disconnected and has Lebesgue measure 0
cantorStep : Line -> List Line
cantorStep ln =
    let
        scaleFactor = 0.33333
        shiftFactor = 2 * scaleFactor
        left = (scale ln scaleFactor)
        right = (shift left (Point shiftFactor 0))
    in
        [left, right]

transform : Line -> Line
transform ln = (shift (scale ln 440) (Point 50 50))

render : List Line -> Html msg
render lns =
    svg [ width "500", height "500", viewBox "0 0 500 500", fill "#DCB35C" ]
      (List.map renderLine lns)

renderLine : Line -> Html msg
renderLine ln =
    let
        lnr = transform ln
        (a,b) = (lnr.a, lnr.b)
        x1s = toString( a.x )
        y1s = toString( a.y )
        x2s = toString( b.x )
        y2s = toString( b.y )
    in
        (line [x1 x1s, y1 y1s, x2 x2s, y2 y2s, strokeWidth "3", stroke "black"]) []

scalePoint : Point -> Float -> Point
scalePoint pt factor =
    let
        (x,y) = (pt.x, pt.y)
    in
        Point (x * factor) (y * factor)

scale : Line -> Float -> Line
scale ln factor =
    let
        (a,b) = (ln.a, ln.b)
        x = (scalePoint a factor)
        y = (scalePoint b factor)
    in
        Line x y

addp : Point -> Point -> Point
addp p q =
    let
        (px, py) = (p.x, p.y)
        (qx, qy) = (q.x, q.y)
    in
        Point (px+qx) (py+qy)


shift : Line -> Point -> Line
shift ln p =
    let
        (a,b) = (ln.a, ln.b)
    in
        Line (addp a p) (addp b p)
