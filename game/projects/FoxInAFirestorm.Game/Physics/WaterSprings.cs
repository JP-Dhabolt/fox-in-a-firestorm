using FoxInAFirestorm.Game.Math;

namespace FoxInAFirestorm.Game.Physics;

public class WaterSprings
{
    public IList<Spring> Points;
    private double _startX;
    private double _endX;
    private double _surfaceHeight;
    private double _springConstant;
    private double _dampingConstant;
    private double _velocitySpread;

    public WaterSprings(double startX, double endX, double surfaceHeight, double distanceBetweenPoints, double springConstant, double dampingConstant, double velocitySpread)
    {
        _startX = startX;
        _endX = endX;
        _surfaceHeight = surfaceHeight;
        _springConstant = springConstant;
        _dampingConstant = dampingConstant;
        _velocitySpread = velocitySpread;
        var numberOfSegments = Convert.ToInt32((_endX - _startX) / distanceBetweenPoints);
        Points = new List<Spring>(numberOfSegments);
        InitLine(numberOfSegments);
    }

    public Spring GetClosestSpring(double xPosition)
    {
        return Points.MinBy(p => System.Math.Abs(xPosition - p.XPos)) ?? Points[0];
    }

    public void TriggerWaves(double xPosition, double impactForce)
    {
        var spring = GetClosestSpring(xPosition);
        spring.Velocity += impactForce;
    }

    public void ProcessWaves()
    {
        DetermineSpringNewYValues();
        SpreadVelocity();
    }

    private void DetermineSpringNewYValues()
    {
        foreach (var springPoint in Points)
        {
            springPoint.DetermineNewY(_surfaceHeight);
        }
    }

    private void SpreadVelocity()
    {
        for (int i = 0; i < Points.Count; i++)
        {
            var currentSpring = Points[i];
            if (i > 0)
            {
                var earlySpring = Points[i - 1];
                double delta = _velocitySpread * (currentSpring.YPos - earlySpring.YPos);
                earlySpring.Velocity += delta;
            }

            if (i < Points.Count - 1)
            {
                var lateSpring = Points[i + 1];
                double delta = _velocitySpread * (currentSpring.YPos - lateSpring.YPos);
                lateSpring.Velocity += delta;
            }
        }
    }

    private void InitLine(int numberOfSegments)
    {
        for (int i = 0; i < numberOfSegments; i++)
        {
            double x = _startX + (_endX - _startX) / numberOfSegments * i;
            var spring = new Spring(_springConstant, _dampingConstant)
            {
                XPos = x,
                YPos = _surfaceHeight
            };
            Points.Add(spring);
        }
    }
}
