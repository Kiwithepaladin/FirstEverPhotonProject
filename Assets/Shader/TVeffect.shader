Shader "Custom/TVeffect"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Scale("Noise scale", Vector) = (1.0, 1.0, 1.0)
		_Offset("Noise offset", Vector) = (1.0, 1.0, 1.0)
		_EdgeColour1("Edge colour 1", Color) = (1.0, 1.0, 1.0, 1.0)
		_EdgeColour2("Edge colour 2", Color) = (1.0, 1.0, 1.0, 1.0)
		_TVeffectStrength("TV Effect Strength",Range(1,20)) = 1
	}

		SubShader
		{
			Tags { "Queue" = "Transparent"}
				Blend One One
				Cull off
				ZWrite on

		Pass
		{

		 CGPROGRAM


		 #pragma vertex vert
		 #pragma fragment frag


		#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float3 _Scale;
			float3 _Offset;
			float4 _EdgeColour1;
			float4 _EdgeColour2;
			float _TVeffectStrength;


			struct appdata
			{
			  float4 vertex : POSITION;
			  float2 uv : TEXCOORD0;
			  float3 normal : NORMAL;
			};

			struct v2f
			{
			   float2 uv : TEXCOORD0;
			   float4 vertex : SV_POSITION;
			   float3 viewDir : COLOR;
			   float3 normal : COLOR2;
			   float3 noise_uv : TEXCOORD1;
			};

			float hash(float n)
			{
				return frac(sin(n)*43758.5453);
			}
			float3 RandomNoise(float3 v)
			{
				float3 p = floor(v);
				float3 f = frac(v);

				f = f * f*(3.0 - 2.0*f); //smoothStep
				float n = p.x + p.y*57.0 + 113.0*p.z;

				return lerp(lerp(lerp(hash(n + 0.0), hash(n + 1.0), f.x),
					lerp(hash(n + 57.0), hash(n + 58.0), f.x), f.y),
					lerp(lerp(hash(n + 113.0), hash(n + 114.0), f.x),
						lerp(hash(n + 170.0), hash(n + 171.0), f.x), f.y), f.z);
			}

			v2f vert(appdata v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				o.normal = v.normal;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				float noiseval = RandomNoise(_Scale*(_Offset + v.vertex));

				//o.vertex += 0.1 * float4(noiseval * o.normal, 0);;

				o.noise_uv = v.vertex.xyz / v.vertex.w;
				return o;
			}
			fixed4 frag(v2f i) : SV_Target
			{
				float noiseval = RandomNoise(_Scale*(_Offset + i.noise_uv));
				noiseval = saturate(noiseval);
				fixed4 col = tex2D(_MainTex, i.uv);
				

				fixed4 sc = fixed4(i.noise_uv.xy, 0, 1);

				sc.xy -= 0.5;
				sc.xy *= i.noise_uv.xx;
				sc.xy += 0.5;

				sc.x = round(sc.x * i.vertex.x) / i.vertex.x;
				sc.y = round(sc.y * i.vertex.y) / i.vertex.y;

				float n = abs(hash(sc.xy * _Time.x * _TVeffectStrength));

				float4 stat = lerp(_EdgeColour1, _EdgeColour2, n.x);

				return fixed4(stat.xyz,1);
			}
			ENDCG
		}

		}
}