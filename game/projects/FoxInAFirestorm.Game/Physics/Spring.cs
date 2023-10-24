namespace FoxInAFirestorm.Game.Physics;

public class Spring
{
    public double Height { get; set; }
    
    private double _velocity;
    private double _springConstant;
    private double _dampingConstant;

    public Spring(double springConstant, double dampingConstant, double velocity = 0)
    {
        _springConstant = springConstant;
        _dampingConstant = dampingConstant;
        _velocity = velocity;
    }

    public double DetermineNewY(double targetHeight)
    {
        double displacement = Height - targetHeight;
        double loss = -_dampingConstant * _velocity;
        double force = -_springConstant * displacement + loss;
        _velocity += force;
        return Height + _velocity;
    }
}
