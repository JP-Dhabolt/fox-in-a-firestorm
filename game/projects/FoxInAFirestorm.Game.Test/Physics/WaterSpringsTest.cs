using FoxInAFirestorm.Game.Physics;
using Xunit;

namespace FoxInAFirestorm.Game.Test.Physics;

public class WaterSpringsTest
{
    [Fact]
    public void WaterSprings_Constructor_Inits_As_Expected()
    {
        double startX = 0, endX = 100, surfaceHeight = 50, distanceBetweenPoints = 5;
        double springConstant = 0.01, dampeningConstant = 0.01;
        var uut = new WaterSprings(startX, endX, surfaceHeight, distanceBetweenPoints, springConstant, dampeningConstant);
        Assert.Equal(20, uut.Points.Count);
    }

    [Theory]
    [InlineData(2, 0)]
    [InlineData(30, 6)]
    [InlineData(98, 19)]
    public void WaterSprings_GetClosestSpring_Returns_As_Expected(double xLocation, int expectedIndex)
    {
        var uut = GenerateUUT();
        var expectedSpring = uut.Points[expectedIndex].Spring;
        var closestSpring = uut.GetClosestSpring(xLocation);
        Assert.Equal(expectedSpring, closestSpring);
    }

    [Theory]
    [InlineData(2, 0)]
    [InlineData(30, 6)]
    [InlineData(98, 19)]
    public void WaterSprings_TriggerWaves_Adds_Velocity_To_Spring_As_Expected(double xLocation, int expectedIndex)
    {
        double impactForce = 23.4;
        var uut = GenerateUUT();
        uut.TriggerWaves(xLocation, impactForce);
        var spring = uut.Points[expectedIndex].Spring;
        Assert.Equal(impactForce, spring.Velocity, 0.000001);
    }

    private WaterSprings GenerateUUT()
    {
        double startX = 0, endX = 100, surfaceHeight = 50, distanceBetweenPoints = 5;
        double springConstant = 0.01, dampeningConstant = 0.01;
        return new WaterSprings(startX, endX, surfaceHeight, distanceBetweenPoints, springConstant, dampeningConstant);
    }
}
