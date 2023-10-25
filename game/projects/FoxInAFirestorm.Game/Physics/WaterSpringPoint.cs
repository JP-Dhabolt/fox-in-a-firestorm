using System.Drawing;
using FoxInAFirestorm.Game.Math;

namespace FoxInAFirestorm.Game.Physics;

public struct WaterSpringPoint
{
    public Vector2D Point;
    public Spring Spring;

    public WaterSpringPoint(Vector2D point, Spring spring)
    {
        Point = point;
        Spring = spring;
    }
}
