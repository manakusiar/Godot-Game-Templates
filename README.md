# Godot Game Templates
This is a godot project where I actively create and improve various templates that are designed to be used threwout many of my smaller projects.
Their goal is to let me express my more short lasting creative impulses. Letting me save time and reuse my personally designed, wide range scripts, assets and scenes!

# Platformer components
## Entity Template.gd
Simple template, extending a CharacterBody2D. Connects to both the physics and input components

## PhysicsComponent.gd
A modular 2D platformer controller for Godot 4 that separates movement logic from entity scripts. It uses kinematic equations to calculate gravity based on desired jump height and distance.

### 1. Features
- **Dynamic Jump Physics:** Define jumps by pixels (height/distance) rather than arbitrary force.
- **Game Feel:** Includes Coyote Time, Jump Buffering, and Variable Jump Height (short hops).
- **Wall Mechanics:** Built-in wall sliding and wall jumping.
- **Component-Based:** Designed to work with an `InputComponent` and an `EntityTemplate`.

### 2. Parameters
- **Jump Height/Distance:** Precisely control jump arcs.
- **Multipliers:** Separate gravity scales for falling and wall sliding.
- **Air Control:** Configurable horizontal resistance and air movement multipliers.
- **Max Speed:** Clamps velocity while allowing external forces.

### 3. Setup
1. Attach this script to a `Node2D` inside your Entity.
2. Assign the **Local Input Component** and **Target** (CharacterBody2D) in the Inspector.
3. Call `handle_physics(delta)` in your entity's `_physics_process`:

```gdscript
func _physics_process(delta):
    $PhysicsComponent.handle_physics(delta)
```

## PlayerInputComponent.gd
A concrete implementation of `InputComponent` that translates Godot's Project Input Map into signals. It decouples raw player input from game logic, allowing for easy remapping and AI swapping.

### 1. Features
- **Signal-Based:** Emits signals for `attack`, `jump`, `aim`, `crouch`, and generic `abilities`.
- **Press/Release Detection:** Passes a boolean state for jump, aim, and crouch to support held inputs.
- **Axis Processing:** Automatically updates `movement_direction` using `Input.get_axis` every frame.
- **Dynamic Mapping:** Uses an `InputMapNames` resource to define which Input Map actions trigger which signals.

## 2. Configuration
Assign an **InputMapNames** resource in the Inspector and fill in the string fields with your project's action names (e.g., "ui_left", "jump", "attack").

## 3. Usage
This component is intended to be linked to the **PhysicsComponent** or other logic nodes:
```gdscript
# The PhysicsComponent listens to this automatically when linked:
$InputComponent.jump_input.connect(_jump_input)
```
