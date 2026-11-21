extends Node2D
class_name ConfettiParticles
@onready var green: CPUParticles2D = $green
@onready var red: CPUParticles2D = $red
@onready var blue: CPUParticles2D = $blue
@onready var yellow: CPUParticles2D = $yellow

@onready var timer: Timer = $Timer

var particles:Array[CPUParticles2D]

func _ready() -> void:
	particles = [green,red,blue,yellow]


func emit():
	for particle:CPUParticles2D in particles:
		particle.emitting = true
