﻿Shader "mattatz/ProceduralFlower/BudNormal" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Bend ("Bend", Range(0.0, 1.0)) = 0.5
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass {
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "ProceduralFlower.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata v) {
				v2f o;

				v.vertex.xyz = bend_bud(v.vertex.xyz);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				fixed4 col = tex2D(_MainTex, i.uv);
				col = fixed4((normalize(i.normal) + 1.0) * 0.5, 1.0);
				// col = fixed4(abs(i.uv.x), i.uv.y, 0, 1.0);
				return col;
			}

			ENDCG
		}
	}
}
