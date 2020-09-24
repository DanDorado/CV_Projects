Viral/Beuracrobots game in LUA.

Current iteration runs a hardcoded save/load location specific to my own PC, this currently needs to be manually changed within the code whenever the code is run on a new computer.
This behaviour will be patched out when I take up the project again.


You are a player who can collect viruses, virtual "creatures" which behave in various ways based off of the way that "programmes" are placed in their microchips.

A virus has eight stats:

Intelligence: the amount of space to place programmes on your microchip.
Speed: Effects the amount of times that your virus will send an "impulse" to the microchip each turn.
Strength: Boosts physical damage.
Toughness: Reduces incoming physical damage.
Technique: Boosts special damage.
Fortitude: Reduces incoming special damage.
Cunning: Boosts hacks.
Will: Resists hacks.

As your virus increases in level you can gain extra stats, and also learn new programmes to use.

For the submitted project, you choose your own virus and level.

On the second screen use 123...n to shift to the "n"th virus of the current player, and shift 123..."n" to shift to the nth player.

The programmes you can add are shown on the bottom of the screen.

The three main types of programme that can be inputted are "exe", "range", and "condition"

An "exe" programme will attempt to perform an action when an impulse reaches it. It will check the ranges inside the impulse at random, and check if they are appropriate for the action. If so it will perform the action on that range and then end the turn.

For example if a "move" exe programme is reached by an impulse containing the ranges "forward" and "up" then it will check them at random, if the first range is "forward" but that range is innapropriate then it will check the "up" instead. If all ranges are innapropriate then your turn will end anyway.
Some "exe" programmes are softlocked, such that if an impulse reaches them without any ranges inside then it will provide its own set of ranges, e.g. an "attack" exe file will attack the direction that a virus is facing is it isn't told otherwise. Others are hardlocked, such that they will always provide their own ranges and ignore any offered ranges, e.g. the "wander" exe,

A "range" programme will input coordinates onto an impulse as it passes. Any number of ranges can be stored inside an impulse. These ranges can either be absolute, for example "forwards" gives the range (0, 1), where as "facing" will change its coordinate depending on which way the virus is facing.

A "condition" programme will check each range on an impulse, and then remove every range that doesn't pass its test. e.g. the "checkEnemy" programme will remove each range from an impulse which doesn't contain an enemy virus.

An impulse will travel right to left from the top-left of the microchip when starting your "turn". If it encounters an exe programme then it will trigger the action (if a correct range is accepted) and disappear.
If it doesn't reach an exe in that row, either because there are none, or beacuse it doesn't pass a condition programme with any of its stored ranges, then it will softerror and move to the next row of the chip.

There are other types of programmes that you can use to fine-tune this process as well as programmes that can be "uploaded" to your chip by friendly or unfriendly viruses, such as "poison" or "armorPlate"

As this is happening, the virus itself will be carrying out its actions on the "battlegrid", normally with the aim of getting an opposing virus into negative hp.

There is a simple save/load feature which I designed which can convert any arrays containing most datatypes into a .txt file and then reconstruct them when needed, this is perhaps the most interesting part of the project from a programming perspective, and could be improved by using a cypher for security (although right now I can edit these .txt manually to fine-tune virus builds)

This is far from the final iteration of Beuracrobots, even though it reached 6000+ lines of code. This project is a prototype to prove that the logic is sound, and I will be moving from lua to unity for the future.
