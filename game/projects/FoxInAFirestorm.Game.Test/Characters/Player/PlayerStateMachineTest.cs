using FoxInAFirestorm.Game.Characters.Player;
using Xunit;

namespace FoxInAFirestorm.Game.Test.Characters.Player;

public class PlayerStateMachineTest
{
    [Fact]
    public void PlayerStateMachine_Instantiates_As_Expected()
    {
        var uut = new PlayerStateMachine();
        Assert.NotNull(uut);
    }
}
