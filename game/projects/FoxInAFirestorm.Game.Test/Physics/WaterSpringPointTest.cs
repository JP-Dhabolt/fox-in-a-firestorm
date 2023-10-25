using FoxInAFirestorm.Game.Math;
using FoxInAFirestorm.Game.Physics;
using Xunit;

namespace FoxInAFirestorm.Game.Test.Physics;

public class WaterSpringPointTest
{
    [Fact]
    public void WaterSpringPoint_Instantiates_As_Expected()
    {
        var point = new Vector2D(0, 1);
        var spring = new Spring(0.01, 0.02, 2);
        var uut = new WaterSpringPoint(point, spring);
        Assert.Equal(spring, uut.Spring);
        Assert.Equal(point, uut.Point);
    }
}