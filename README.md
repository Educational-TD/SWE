# Geometry Defense: UI Prototype

## Overview

This prototype implements every menu described in the requirements: the startup menu, the settings menu, the scoreboard, and the credits. Each menu can be navigated and shows its relevant data.

The prototype also implements the core gameplay loop:

* **Tower upgrades:** Damage, fire rate, and range can all be upgraded.
* **Math questions:** The player must answer a question correctly for an upgrade to succeed. If the answer is incorrect, the correct solution is shown.
* **Combat:** Each tower fires projectiles at the closest enemy within its range.
* **Waves:** Waves continue until the player runs out of lives.

## 1. How to Run the Prototype

The prototype can be played in a web browser at:

**<https://educational-td.github.io/SWE/>**

### Alternative: Play on itch.io

1. Open the link above in your browser.
2. Click the back arrow in the bottom left corner of the screen.
3. Click the **Play on [itch.io](https://qnobletaylor.itch.io/test)** button to run the prototype.

## 2. Sample Scenarios

### Startup Screen

When the game starts, the player sees the startup screen.

### Starting a New Run

From the startup menu, the player can start a new run.

### Selecting a Tower

The player can click a tower to select it. A selected tower shows its range, its attack cooldown, and the damage it deals on each hit.

### Upgrading a Tower

Once a tower is selected, the player can press the buttons at the bottom of the screen to upgrade it. The upgrade succeeds only if the player answers the math question correctly.

### Pausing the Game

The player can pause the game at any time, except while answering a question.

### Settings

The player can open the settings from either the startup menu or the pause menu.

### Changing Keybinds

In the settings menu, the player can change their keybinds.

### Scoreboard

After leaving a run and returning to the startup menu, the player can view their best runs.

### Credits

The player can also view the credits for the game.
