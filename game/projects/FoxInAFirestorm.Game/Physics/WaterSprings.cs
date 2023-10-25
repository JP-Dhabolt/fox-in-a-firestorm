using FoxInAFirestorm.Game.Math;

namespace FoxInAFirestorm.Game.Physics;

public class WaterSprings
{
    public IList<WaterSpringPoint> Points;
    private double _startX;
    private double _endX;
    private double _surfaceHeight;
    private double _springConstant;
    private double _dampingConstant;

    public WaterSprings(double startX, double endX, double surfaceHeight, double distanceBetweenPoints, double springConstant, double dampingConstant)
    {
        _startX = startX;
        _endX = endX;
        _surfaceHeight = surfaceHeight;
        _springConstant = springConstant;
        _dampingConstant = dampingConstant;
        var numberOfSegments = Convert.ToInt32((_endX - _startX) / distanceBetweenPoints);
        Points = new List<WaterSpringPoint>(numberOfSegments);
        InitLine(numberOfSegments);
    }

    public Spring GetClosestSpring(double xPosition)
    {
        return Points.MinBy(p => System.Math.Abs(xPosition - p.Point.X))
            .Spring;
    }

    public void TriggerWaves(double xPosition, double impactForce)
    {
        var spring = GetClosestSpring(xPosition);
        spring.Velocity += impactForce;
    }

    private void InitLine(int numberOfSegments)
    {
        for (int i = 0; i < numberOfSegments; i++)
        {
            double x = _startX + (_endX - _startX) / numberOfSegments * i;
            var point = new Vector2D(x, _surfaceHeight);
            var spring = new Spring(_springConstant, _dampingConstant);
            Points.Add(new WaterSpringPoint(point, spring));
        }
    }
}
