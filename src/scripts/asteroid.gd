class_name Asteroid extends RigidBody2D

## Determines the size of the meteor between small, medium and large.
@export_enum("Small:1", "Medium:2", "Large:3") var magnitude : int	 = AsteroidSize.Small
@export var velocity : float = 50
## Direction is passed as an angle in degrees.
@export_range(0, 360, 0.1) var direction : float = 180
var health : int = 1
var damage : int = 5
var fuel_damage : bool = false

# Possible textures are preloaded in the class to reduce load when spawning new asteroids.
# I don't know how to implement this in a more ellegant way.
const TextureSmall = preload("res://PNG/asteroid_small.png")
const TextureMid = preload("res://PNG/asteroid_mid.png")
const TextureLarge = preload("res://PNG/asteroid_large.png")

enum AsteroidSize {
	Small = 1, ## (5 hull damage) - Can be destroyed in one shot
	Medium = 2, ## (10 hull damage) - When shot 2 times, breaks into 3 smaller asteroids 
	Large = 3, ## (15 Hull damage, 1 Gallon of fuel) - When shot 3 times, breaks into 2 medium asteroids 
}

func _ready() -> void:
	match magnitude:
		AsteroidSize.Large:
			damage = 15
			fuel_damage = true
			health = 3
			self.mass = 4
			$Sprite.texture = TextureLarge
			$CollisionBoxLarge.disabled = false
		AsteroidSize.Medium:
			damage = 10
			fuel_damage = false
			health = 2
			self.mass = 2
			$Sprite.texture = TextureMid
			$CollisionBoxMid.disabled = false
		_:
			damage = 5
			fuel_damage = false
			health = 1
			self.mass = 1
			$Sprite.texture = TextureSmall
			$CollisionBoxSmall.disabled = false
	
	self.rotation_degrees = randf_range(0,360)
	self.visible = true
	
	# sets the linear velocity vector of the RigidBody2D to inputed velocity in the inputed direction
	self.linear_velocity = velocity * Vector2.from_angle(deg_to_rad(direction)).normalized()
