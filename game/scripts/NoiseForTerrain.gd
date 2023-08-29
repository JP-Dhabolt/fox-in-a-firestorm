extends Node
class_name NoiseForTerrain

enum NoiseForTerrainType {
	INITIAL = 0,
	RANDOM = 1,
}

static func get_noise_by_type(noise_type: NoiseForTerrainType) -> FastNoiseLite:
	match noise_type:
		NoiseForTerrainType.INITIAL:
			return _generate_initial_noise()
		NoiseForTerrainType.RANDOM:
			return _generate_random_noise()
		_:
			return FastNoiseLite.new()

static func _generate_initial_noise() -> FastNoiseLite:
	var fast_noise = FastNoiseLite.new()
	fast_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	fast_noise.domain_warp_enabled = true
	fast_noise.domain_warp_amplitude = 89.5
	fast_noise.domain_warp_fractal_gain = 0.979
	fast_noise.domain_warp_fractal_octaves = 1
	fast_noise.domain_warp_fractal_type = FastNoiseLite.DomainWarpFractalType.DOMAIN_WARP_FRACTAL_PROGRESSIVE
	fast_noise.domain_warp_frequency = 0.98
	fast_noise.domain_warp_type = FastNoiseLite.DomainWarpType.DOMAIN_WARP_BASIC_GRID
	fast_noise.fractal_gain = 0.008
	fast_noise.fractal_lacunarity = 0.95
	fast_noise.fractal_octaves = 9
	fast_noise.fractal_ping_pong_strength = 8.34
	fast_noise.fractal_weighted_strength = 5.68
	fast_noise.frequency = 0.875
	fast_noise.fractal_type = FastNoiseLite.FractalType.FRACTAL_FBM
	return fast_noise

static func _generate_random_noise() -> FastNoiseLite:
	var fast_noise = FastNoiseLite.new()
	fast_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	fast_noise.domain_warp_enabled = randi_range(0, 1) == 0
	fast_noise.domain_warp_amplitude = randf_range(0.0, 100.0)
	fast_noise.domain_warp_fractal_gain = randf_range(0.0, 1.0)
	fast_noise.domain_warp_fractal_octaves = randi_range(1, 10)
	fast_noise.domain_warp_fractal_type = randi_range(0, 2) as FastNoiseLite.DomainWarpFractalType
	fast_noise.domain_warp_frequency = randf_range(0.0, 1.0)
	fast_noise.domain_warp_type = randi_range(0, 2) as FastNoiseLite.DomainWarpType
	fast_noise.fractal_gain = randf_range(0.0, 1.0)
	fast_noise.fractal_lacunarity = randf_range(0.0, 10.0)
	fast_noise.fractal_octaves = randi_range(1, 10)
	fast_noise.fractal_ping_pong_strength = randf_range(0.0, 10.0)
	fast_noise.fractal_weighted_strength = randf_range(0.0, 10.0)
	fast_noise.frequency = randf_range(0.0, 1.0)
	fast_noise.fractal_type = randi_range(0, 3) as FastNoiseLite.FractalType
	return fast_noise