Shader "Custom/CloudShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Scale("Noise scale", Vector) = (1.0, 1.0, 1.0)
		_Offset("Noise offset", Vector) = (1.0, 1.0, 1.0)
		_AnimSpeed("Animation Speed", Vector) = (0,0,0,0)
		_EdgeColour1("Edge colour 1", Color) = (1.0, 1.0, 1.0, 1.0)
		_EdgeColour2("Edge colour 2", Color) = (1.0, 1.0, 1.0, 1.0)
	}

		SubShader
		{
			Tags { "Queue" = "Transparent"}
				Blend One One
				Cull Back
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
			half _Dissolve;
			float4 _EdgeColour1;
			float4 _EdgeColour2;
			float4 _AnimSpeed;

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
				o.normal = v.normal;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				float noiseval = RandomNoise(_Scale*(_Offset + v.vertex));
				
				return o;
			}
			fixed4 frag(v2f i) : SV_Target
			{
				float4 worldPos = mul(unity_ObjectToWorld, i.vertex);
				float noiseval = RandomNoise(_Scale*(_Offset + i.vertex));

				float displacment = (cos(worldPos.y) + cos(worldPos.x + (_AnimSpeed * _Time)));
				i.vertex.yz += displacment;
				fixed4 temp = lerp(noiseval, displacment, _EdgeColour1.x) * _Time;
				return temp;
			}
			ENDCG
		}

		}
}