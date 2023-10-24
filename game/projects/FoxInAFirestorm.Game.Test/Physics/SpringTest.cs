using FoxInAFirestorm.Game.Physics;
using Xunit;

namespace FoxInAFirestorm.Game.Test.Physics;

public class SpringTest
{
    [Fact]
    public void DetermineNewY_Returns_As_Expected_After_Init()
    {
        double height = 100;
        double constant = 0.010;
        double dampingConstant = 0.01;
        var uut = new Spring(constant, dampingConstant)
        {
            Height = height,
        };
        double targetHeight = 50;
        var newY = uut.DetermineNewY(targetHeight);
        double expectedNewY = (height - targetHeight) * -constant + height;
        Assert.Equal(expectedNewY, newY, 0.00001);
    }

    [Fact]
    public void DetermineNewY_Returns_As_Expected_With_Velocity()
    {
        double height = 100;
        double constant = 0.015;
        double dampingConstant = 0.01;
        double startingVelocity = 10;
        var uut = new Spring(constant, dampingConstant, velocity: startingVelocity)
        {
            Height = height,
        };
        double targetHeight = 50;
        double expectedNewY = (height - targetHeight) * -constant + height - dampingConstant * startingVelocity + startingVelocity;
        double newY = uut.DetermineNewY(targetHeight);
        Assert.Equal(expectedNewY, newY, 0.00001);
    }
}