using FoxInAFirestorm.Game.Math;
using Xunit;

namespace FoxInAFirestorm.Game.Test.Math;

public class Vector2DTest
{
    [Fact]
    public void Vector2D_Creates_As_Expected()
    {
        double x = 21.2;
        double y = 31.3;
        var uut = new Vector2D(x, y);
        Assert.Equal(x, uut.X);
        Assert.Equal(y, uut.Y);
    }
}