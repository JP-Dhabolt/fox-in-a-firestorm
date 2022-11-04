# Design Document

## What Even Is This Game?

`Fox in a Firestorm` is an "endless runner" type game in which the player controls a Sierra Nevada Red Fox.
This is one of the most endangered species in North America, and your goal is to escape a forest fire.

## Genre

The game is a 2D, auto-scrolling platformer, in the "endless runner" style.

## Mechanics

### Core Loop

The core loop of the game takes place on an auto-scrolling 2D, side-view level in which obstacles and interactables are added to the level over time.
The player controls a fox, and has the ability to move around relative to the auto-scrolling level.
The player accumulates "points" based on their time playing the level, and the level becomes increasingly difficult the longer it is played.
The level is over when the player goes off of the left of the screen, or "lose" due to other mechanics.

### Heat

There is a `Heat` meter in the game, which will cause the player to combust (and lose) if it climbs too high.
`Heat` is increased by colliding with fire obstacles that appear in the level.
`Heat` is decreased by colliding with water obstacles that appear in the level.

### Speed

The player has a base speed that controls how quickly they move relative to the auto-scrolling level.
`Speed` is temporarily decreased while in collision with water obstacles.
`Speed` is temporarily decreased while in collision with bush obstacles.
`Speed` is decreased as `Food` is decreased from the midpoint with more impact the closer to empty `Food` gets.
`Speed` is slighly decreased  as `Food` is increased from the midpoint, with more impact the closer to stuffed `Food` gets.

### Food

There is a `Food` meter which indicates how much energy a player has.
`Food` is decreased slowly over time.
`Food` is increased by eating rodents hidden in leaf piles.

### Jumping

There is a `Jumping` mechanism, which allows the player to leap over obstacles.
`Jumping` again while in the air will cause the fox to `Pounce`, allowing them to catch rodents.

### Obstacles

The following obstacle types will exist, with corresponding effects.
* Fire
    * Increases the `Heat` meter
* Water
    * Decreases the `Heat` meter
    * Decreases player `Speed`
* Trees
    * Block the players movement
    * No intrinsic effect
* Bushes
    * Decreases player `Speed`
* Leaf Pile (hiding rodents)
    * Increases player `Food`
    * Effect only occurs when `Pouncing` into the pile

## Story

It is approximately 30 years in the future, and the world is increasingly feeling the impact of global warming.
The super-rich use `Space-R` rockets to launch disposable drones to perform trades on the exclusive Low-Earth-Orbit (LEO) stock exchange.
One of the richest decides to add an extra chemical to the booster rocket's landing thrusters to perform the most extravegant gender reveal ever seen.
Unfortunately, this sparks one of the largest forest fires ever seen in the Sierra Nevada mountains, threatening your existence.
You are, of course, a Sierra Nevada Red Fox, and you must RUN FOR YOUR LIFE!

### Levels

1. The first level will have ALL mechanics enabled, and will be (almost?) impossible for the player to win.
    1. The intent is to introduce the main losing condition, which is going off the left of the screen.
    1. The level will be over quickly, and may include an extremely difficult section (as opposed to an impossible section) first, before a definitely impossible section.
    1. Regardless of whether the first section is a success or failure, the first loss will show that this was a DIFFERENT fox, and then move on to the rest of the game.
1. The second level be of medium length (no "endless" mode, yet)
    1. The intent is to showcase the `Heat` mechanic, along with `Speed`.
    1. The level will have an actual end, and will be relatively easy to complete.
    1. This will be a primarily water themed level.
1. The third level will be of medium length (no "endless" mode, yet)
    1. The intent is to showcase the `Food` mechanic, along with `Pounce`
    1. The level will have an actual end, and will be relatively easy to complete.
    1. This will be a primarily earth themed level.
1. The fourth level will be "endless".
    1. This is the core gameplay, and will have all mechanics enabled.
    1. The level will start off easy, and increasingly add more difficult elements.
    1. The scrolling will becoming increasingly faster.
    1. If the player can survive for some `X` amount of time, they will be shown the ending sequence and credits.
1. (Stretch) After surviving for `X` amount of time in the fourth level, a new mode may become unlocked.
    1. This level will continue with "endless" mode, but with additional (TBD) mechanics.
    1. As (potential) new mechanics are introduced, they will be done in additional Stretch levels (one per mechanic).

## Milestones

1. Week of 2022-11-01 (partial week)
    1. Kickoff week
    1. Game Concept and Design Doc
1. Week of 2022-11-06
    1. Core movement mechanics
    1. Artwork started
    1. Audio started
1. Week of 2022-11-13
    1. First 3 (shorter) levels
    1. Initial audio integrations
1. Week of 2022-11-20
    1. Endless level
    1. Art integration complete
    1. Audio integration complete
1. Week of 2022-11-27 (partial and final week)
    1. Menu and Credits
    1. Polish
    1. Potentially Stretch Goals
