// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Boks/Chapter6/Chapter6_DiffuseVertexLevel"{
	Properties{
		_Diffuse("Diffuse Color",Color)=(1,1,1,1)
	}
	SubShader{
		Pass{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct a2v{
				float4 vertex:POSITION;
				float4 normal:NORMAL;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				fixed3 color:COLOR;
			};

			//Cdiffuse=Clight*Cdiffuse*max(1,dot(n,l))
			v2f vert(a2v v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);

				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 normalWS = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(normalWS,worldLight));

				o.color=ambient+diffuse;

				return o;
			}

			fixed4 frag(v2f i):SV_TARGET{
				return fixed4(i.color,1.0);
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}