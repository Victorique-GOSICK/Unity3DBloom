#include "UnityCG.cginc"

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

sampler2D _bloomTex1;
sampler2D _bloomTex2;

v2f vert_BloomMegre(appdata v)
{
	v2f o;
	o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	return o;
}

float4 frag_BloomMegre(v2f i) : SV_Target
{
	half3 col0 = tex2D(_MainTex, i.uv).rgb;
	half3 col1 = tex2D(_bloomTex1, i.uv).rgb;
	half3 col2 = tex2D(_bloomTex2, i.uv).rgb;
	//
	return float4(col0 * 2.0 + col1 * 1.15  + col2 * 0.45, 1.0f);
}
