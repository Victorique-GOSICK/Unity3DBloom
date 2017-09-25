#include "UnityCG.cginc"

float _Saturation;

float luma(float3 c)
{
	return 0.212 * c.r + 0.701 * c.g + 0.087 * c.b;
}

float2 CircleSample(float Start, float Point, float Points)
{
	float angle = 2 * UNITY_PI / Points * (Point + Start);
	return float2(cos(angle), sin(angle));
}

// http://chilliant.blogspot.com/2012/08/srgb-approximations-for-hlsl.html
float3 srgb_to_linear(float3 c)
{
	return c * (c * (c * 0.305306011 + 0.682171111) + 0.012522878);
}

float3 linear_to_srgb(float3 c)
{
	return max(1.055 * pow(c, 0.416666667) - 0.055, 0.0);
}

float3 apply_saturation(float3 c)
{
	return lerp((float3)luma(c), c, _Saturation);
}