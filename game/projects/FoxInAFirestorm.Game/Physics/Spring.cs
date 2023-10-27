namespace FoxInAFirestorm.Game.Physics;

public class Spring
{
    public double YPos { get; set; }
    public double XPos { get; set; }
    public double Velocity { get; set; }
    private readonly double _springConstant;
    private readonly double _dampingConstant;

    public Spring(double springConstant, double dampingConstant)
    {
        _springConstant = springConstant;
        _dampingConstant = dampingConstant;
    }

    public void DetermineNewY(double targetHeight)
    {
        double displacement = YPos - targetHeight;
        double loss = -_dampingConstant * Velocity;
        double force = -_springConstant * displacement + loss;
        Velocity += force;
        YPos += Velocity;
    }
}
