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

float _Threshold;
float _Intensity;

v2f vert_Gather(appdata v)
{
	v2f o;
	o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	return o;
}

float4 frag_Gather(v2f i) : SV_Target
{
	half3 col = tex2D(_MainTex, i.uv).rgb;
	float lum = luma(linear_to_srgb(col.rgb));
	half bloom = _Intensity *saturate(lum - _Threshold);
	return float4(col * bloom, 1.0f);
}
