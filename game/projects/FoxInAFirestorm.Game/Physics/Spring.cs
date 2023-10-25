namespace FoxInAFirestorm.Game.Physics;

public class Spring
{
    public double Height { get; set; }
    public double Velocity;
    private double _springConstant;
    private double _dampingConstant;

    public Spring(double springConstant, double dampingConstant, double velocity = 0)
    {
        _springConstant = springConstant;
        _dampingConstant = dampingConstant;
        Velocity = velocity;
    }

    public double DetermineNewY(double targetHeight)
    {
        double displacement = Height - targetHeight;
        double loss = -_dampingConstant * Velocity;
        double force = -_springConstant * displacement + loss;
        Velocity += force;
        return Height + Velocity;
    }
}
