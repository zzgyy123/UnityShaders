﻿// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shader Boks/Chapter9/Chapter9_AlphaTestWithShadow"
{
Properties
	{
		_Color("Color tint",Color)=(1,1,1,1)
		_MainTex ("Main Texture", 2D) = "white" {}
		_Cutoff("Alpha cutoff",Range(0,1))=0.5
	}
	SubShader
	{
		Tags{"Queue"="AlphaTest" "IgnoreProjector"="true" "RenderType"="TransparentCutout"}
		Pass
		{
			Tags{"LightMode"="ForwardBase"}

			Cull Off

			CGPROGRAM
			
			#pragma multi_compile_fwdbase
			
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutoff;
			
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
				SHADOW_COORDS(3)
			};

			v2f vert(a2v v){
				v2f o;
				o.pos=UnityObjectToClipPos(v.vertex);
				o.worldNormal=UnityObjectToWorldNormal(v.normal);
				o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;

				TRANSFER_SHADOW(o);

				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				fixed3 worldNormal =normalize(i.worldNormal);
				fixed3 worldLightDir =normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed4 texColor=tex2D(_MainTex,i.uv);

				clip(texColor.a-_Cutoff);

				fixed3 albedo = texColor.rgb*_Color.rgb;

				fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;

				fixed3 diffuse=_LightColor0.rgb*albedo*max(0,dot(worldNormal,worldLightDir));

				UNITY_LIGHT_ATTENUATION(atten,i,i.worldPos);

				return fixed4(ambient+diffuse*atten,1.0);
			}



			ENDCG
		}
	}

	FallBack "Transparent/Cutout/VertexLit"
}
