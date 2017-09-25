Shader "Hidden/Bloom"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		ZTest Always Cull Off ZWrite Off
		LOD 100

		//4 tap DownSample
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_DownSample
			#pragma fragment frag_DownSample
			#include "DownSample.cginc"
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_CircleSample
			#pragma fragment frag_CircleSample
			#pragma multi_compile __ DOWNSAMPE
			#include "DownSample.cginc"
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_Gather
			#pragma fragment frag_Gather
			#include "Gather.cginc"
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_BloomMegre
			#pragma fragment frag_BloomMegre
			#include "Megre.cginc"
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_FinalMegre
			#pragma fragment frag_FinalMegre
			#include "FinalMegre.cginc"
			ENDCG
		}
	}
}
