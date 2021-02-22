Shader "Custom/OutlineShader" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
	}
		SubShader{
			Pass {
			Cull off
				Tags { "Queue" = "opaque"}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				sampler2D _MainTex;
				fixed4 _Color;
				float4 _MainTex_TexalSize;

				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;
				};

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					float3 normal : NORMAL;
				};

				v2f vert(appdata v) {
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;

					return o;
				}

				fixed4 frag(v2f i) : COLOR 
				{

				half4 tex = tex2D(_MainTex,i.uv);
				tex.rgb *= tex.a;


				half4 outlineC = _Color;
				outlineC.a *= ceil(tex.a);
				outlineC.rgb *= outlineC.a;

				fixed upAlpha = tex2D(_MainTex, i.uv + fixed2(0,_MainTex_TexalSize.y)).a;
				fixed downAlpha = tex2D(_MainTex, i.uv -  fixed2(0, _MainTex_TexalSize.y)).a;
				fixed rightAlpha = tex2D(_MainTex, i.uv + fixed2(_MainTex_TexalSize.x,0)).a;
				fixed leftAlpha = tex2D(_MainTex, i.uv - fixed2(_MainTex_TexalSize.x,0)).a;

				return lerp(outlineC, tex, ceil(upAlpha * downAlpha * rightAlpha * leftAlpha));
				}

				ENDCG
			}
		}
			FallBack "Diffuse"
}