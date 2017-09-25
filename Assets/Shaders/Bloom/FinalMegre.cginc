#include "UnityCG.cginc"
#include "Common.cginc"

struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
};

struct v2f
{
	float2 uv : TEXCOORD0;
	float4 vertex : SV_POSITION;
};

sampler2D _MainTex;
float4 _MainTex_ST;
float4 _MainTex_TexelSize;

float _Exposure;

sampler2D _bloomTex;
sampler2D _ColorLUT;

//------------------------------------------------------------------------
float3 ACESToneMapping(float3 color, float adapted_lum)
{
	float A = 2.51f;
	float B = 0.03f;
	float C = 2.43f;
	float D = 0.59f;
	float E = 0.14f;

	color *= adapted_lum;
	return (color * (A * color + B)) / (color * (C * color + D) + E);
}

//------------------------------------------------------------------------
float3 CEToneMapping(float3 color, float adapted_lum)
{
	return 1 - exp(-adapted_lum * color);
}

//------------------------------------------------------------------------
float3 F(float3 x)
{
	const float A = 0.22f;
	const float B = 0.30f;
	const float C = 0.10f;
	const float D = 0.20f;
	const float E = 0.01f;
	const float F = 0.30f;

	return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

float3 Uncharted2ToneMapping(float3 color, float adapted_lum)
{
	float WHITE = 11.2f;
	return F(1.6f * adapted_lum * color) / F(WHITE);
}

//------------------------------------------------------------------------
v2f vert_FinalMegre(appdata v)
{
	v2f o;
	o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	return o;
}

float4 frag_FinalMegre(v2f i) : SV_Target
{
	half3 origin = tex2D(_MainTex, i.uv).rgb;
	half3 bloom = tex2D(_bloomTex, i.uv).rgb;
	half3 color = ACESToneMapping(origin + bloom, _Exposure);
	color = linear_to_srgb(color);
	color = apply_saturation(color);
	color.r = tex2D(_ColorLUT, half2(color.r, 0.5)).r;
	color.g = tex2D(_ColorLUT, half2(color.g, 0.5)).g;
	color.b = tex2D(_ColorLUT, half2(color.b, 0.5)).b;
	color = srgb_to_linear(color);
	//
	return float4(color, 1.0f);
}
