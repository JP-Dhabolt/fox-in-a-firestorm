using FoxInAFirestorm.Game.Physics;
using Xunit;

namespace FoxInAFirestorm.Game.Test.Physics;

public class WaterSpringsTest
{
    [Fact]
    public void WaterSprings_Constructor_Inits_As_Expected()
    {
        var uut = GenerateUUT();
        Assert.Equal(20, uut.Points.Count);
    }

    [Theory]
    [InlineData(2, 0)]
    [InlineData(30, 6)]
    [InlineData(98, 19)]
    public void WaterSprings_GetClosestSpring_Returns_As_Expected(double xLocation, int expectedIndex)
    {
        var uut = GenerateUUT();
        var expectedSpring = uut.Points[expectedIndex];
        var closestSpring = uut.GetClosestSpring(xLocation);
        Assert.Equal(expectedSpring, closestSpring);
    }

    [Theory]
    [InlineData(2, 0)]
    [InlineData(30, 6)]
    [InlineData(98, 19)]
    public void WaterSprings_TriggerWaves_Adds_Velocity_To_Spring_As_Expected(double xLocation, int expectedIndex)
    {
        var uut = GenerateUUT();
        uut.TriggerWaves(xLocation, ConstValues.ImpactForce);
        var spring = uut.Points[expectedIndex];
        Assert.Equal(ConstValues.ImpactForce, spring.Velocity, ConstValues.EqualityTolerance);
    }

    [Fact]
    public void WaterSprings_ProcessWaves_Updates_Springs_As_Expected()
    {
        // Arrange
        var uut = GenerateUUT();
        uut.TriggerWaves(30, ConstValues.ImpactForce);
        var spring6 = uut.Points[6];
        var spring5 = uut.Points[5];
        var spring7 = uut.Points[7];
        double expected6Velocity = ConstValues.ImpactForce - ConstValues.DampeningConstant * ConstValues.ImpactForce;
        double expectedNewY = ConstValues.SurfaceHeight + expected6Velocity;
        double yDiff = expectedNewY - ConstValues.SurfaceHeight;
        double expected5And7Velocity =  yDiff * ConstValues.VelocitySpread;

        // Act
        uut.ProcessWaves();

        // Assert
        Assert.Equal(expectedNewY, spring6.YPos, ConstValues.EqualityTolerance);
        Assert.Equal(expected5And7Velocity, spring5.Velocity, ConstValues.EqualityTolerance);
        Assert.Equal(expected5And7Velocity, spring7.Velocity, ConstValues.EqualityTolerance);
    }

    private WaterSprings GenerateUUT()
    {
        return new WaterSprings(ConstValues.StartX, ConstValues.EndX, ConstValues.SurfaceHeight,
            ConstValues.DistanceBetweenPoints, ConstValues.SpringConstant, ConstValues.DampeningConstant,
            ConstValues.VelocitySpread);
    }
}