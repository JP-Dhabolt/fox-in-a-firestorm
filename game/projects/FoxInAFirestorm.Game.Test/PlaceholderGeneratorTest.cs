using Xunit;

namespace FoxInAFirestorm.Game.Test;

public class PlaceholderGeneratorTest
{
    [Fact]
    public void Generate_Returns_Placeholder()
    {
        var generator = new PlaceholderGenerator();
        Assert.Equal("Placeholder", generator.Generate());
    }
}
