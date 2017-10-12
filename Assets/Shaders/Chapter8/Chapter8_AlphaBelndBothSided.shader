// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Boks/Chapter8/Chapter8_AlphaBelndBothSided"
{
	Properties
	{
		_Color("Color tint",Color)=(1,1,1,1)
		_MainTex ("Main Texture", 2D) = "white" {}
		_AlphaScale("Alpha Scale",Range(0,1))=1.0
	}
	SubShader
	{
		Tags{"Queue"="AlphaTest" "IgnoreProjector"="true" "RenderType"="Transparent"}

		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			Cull Front

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _AlphaScale;
			
			struct a2v{
				float4 vertex:POSITION;//POSITION
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};

			v2f vert(a2v a){
				v2f v;
				v.pos=UnityObjectToClipPos(a.vertex);
				v.worldNormal=UnityObjectToWorldNormal(a.normal);
				v.worldPos=mul(unity_ObjectToWorld,a.vertex).xyz;
				v.uv=a.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;

				return v;
			}

			fixed4 frag(v2f i):SV_Target{
				fixed3 worldNormal =normalize(i.worldNormal);
				fixed3 worldLightDir =normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed4 texColor = tex2D(_MainTex,i.uv);

				fixed3 albedo = texColor.rgb*_Color.rgb;

				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;

				fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));

				return fixed4(ambient+diffuse,texColor.a*_AlphaScale);
			}



			ENDCG
		}

		Pass{
			ZWrite On
			ColorMask 0
		}

		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			Cull Back

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _AlphaScale;
			
			struct a2v{
				float4 vertex:POSITION;//POSITION
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};

			v2f vert(a2v a){
				v2f v;
				v.pos=UnityObjectToClipPos(a.vertex);
				v.worldNormal=UnityObjectToWorldNormal(a.normal);
				v.worldPos=mul(unity_ObjectToWorld,a.vertex).xyz;
				v.uv=a.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;

				return v;
			}

			fixed4 frag(v2f i):SV_Target{
				fixed3 worldNormal =normalize(i.worldNormal);
				fixed3 worldLightDir =normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed4 texColor = tex2D(_MainTex,i.uv);

				fixed3 albedo = texColor.rgb*_Color.rgb;

				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;

				fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));

				return fixed4(ambient+diffuse,texColor.a*_AlphaScale);
			}



			ENDCG
		}
	}

	FallBack "Transparent/Cutout/VertexLit"
}
