// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Boks/Chapter7/Chapter7_TextureProperty"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct a2v{
				float4 vertex:POSITION;//POSITION
				float4 texcoord:TEXCOORD0;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD2;
			};

			v2f vert(a2v a){
				v2f v;
				v.pos=UnityObjectToClipPos(a.vertex);
				v.uv=a.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;

				return v;
			}

			fixed4 frag(v2f i):SV_Target{
				return fixed4(tex2D(_MainTex,i.uv).rgb,1.0);
			}



			ENDCG
		}
	}

	FallBack "Diffuse"
}
