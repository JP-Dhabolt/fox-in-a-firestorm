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
            YPos = height,
        };
        double targetHeight = 50;
        uut.DetermineNewY(targetHeight);
        double expectedNewY = (height - targetHeight) * -constant + height;
        Assert.Equal(expectedNewY, uut.YPos, 0.00001);
        Assert.Equal(0, uut.XPos, 0.00001);
    }

    [Fact]
    public void DetermineNewY_Sets_Y_As_Expected()
    {
        double height = 100;
        double constant = 0.015;
        double dampingConstant = 0.01;
        double startingVelocity = 10;
        var uut = new Spring(constant, dampingConstant)
        {
            YPos = height,
            Velocity = startingVelocity
        };
        double targetHeight = 50;
        double expectedNewY = (height - targetHeight) * -constant + height - dampingConstant * startingVelocity + startingVelocity;
        uut.DetermineNewY(targetHeight);
        Assert.Equal(expectedNewY, uut.YPos, 0.00001);
    }
}