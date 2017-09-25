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

v2f vert_DownSample(appdata v)
{
	v2f o;
	o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	return o;
}

float4 frag_DownSample(v2f i) : SV_Target
{
	float3 duv = float3(0.5, 0.5, -0.5) * _MainTex_TexelSize.xyx;
	half3 col0 = tex2D(_MainTex, i.uv + duv.xy).rgb;
	half3 col1 = tex2D(_MainTex, i.uv - duv.xy).rgb;
	half3 col2 = tex2D(_MainTex, i.uv + duv.zy).rgb;
	half3 col3 = tex2D(_MainTex, i.uv - duv.zy).rgb;
	return float4((col0 + col1 + col2 + col3) * 0.25f, 1.0f);
}


v2f vert_CircleSample(appdata v)
{
	v2f o;
	o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	return o;
}

float4 frag_CircleSample(v2f i) : SV_Target
{
	float start = 0.0f;
#ifdef DOWNSAMPE
	float scale = 4.0 / 3.0;
#else
	float scale = 2.0 / 3.0;
#endif
	//
	half3 col = tex2D(_MainTex, i.uv);
	half3 col0 = tex2D(_MainTex, i.uv + CircleSample(start, 0, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col1 = tex2D(_MainTex, i.uv + CircleSample(start, 1, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col2 = tex2D(_MainTex, i.uv + CircleSample(start, 2, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col3 = tex2D(_MainTex, i.uv + CircleSample(start, 3, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col4 = tex2D(_MainTex, i.uv + CircleSample(start, 4, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col5 = tex2D(_MainTex, i.uv + CircleSample(start, 5, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col6 = tex2D(_MainTex, i.uv + CircleSample(start, 6, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col7 = tex2D(_MainTex, i.uv + CircleSample(start, 7, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col8 = tex2D(_MainTex, i.uv + CircleSample(start, 8, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col9 = tex2D(_MainTex, i.uv + CircleSample(start, 9, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col10 = tex2D(_MainTex, i.uv + CircleSample(start, 10, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col11 = tex2D(_MainTex, i.uv + CircleSample(start, 11, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col12 = tex2D(_MainTex, i.uv + CircleSample(start, 12, 14) * _MainTex_TexelSize.xy * scale).rgb;
	half3 col13 = tex2D(_MainTex, i.uv + CircleSample(start, 13, 14) * _MainTex_TexelSize.xy * scale).rgb;
	float weight = 1.0f / 15.0f;
	//
	return float4((col + col0 + col1 + col2 + col3 + col4 + col5 + col6 + col7 + col8 + col9 + col10 + col11 + col12 + col13) * weight, 1.0f);
}