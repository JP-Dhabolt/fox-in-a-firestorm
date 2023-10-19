using Godot;
using FoxInAFirestorm.Game;

public partial class StateLabel : Label
{
	private PlaceholderGenerator _generator;
	public override void _Ready()
	{
		_generator = new PlaceholderGenerator();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Text = _generator.Generate();
	}
}
