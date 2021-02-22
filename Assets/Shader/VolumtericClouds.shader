Shader "Custom/VoluemetricClouds"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Scale("Noise scale", Vector) = (1.0, 1.0, 1.0)
		_Offset("Noise offset", Vector) = (1.0, 1.0, 1.0)
		_Postion1("Position 1", Range(0,1)) = 1
		_Postion2("Position 2", Range(0,1)) = 1
	}

		SubShader
		{
			Tags { "Queue" = "Geometry" "RenderType" = "Transparent"}

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
			float _Postion1;
			float _Postion2;
			float4 _Wobble;

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
			   float4 viewDir : COLOR;
			   float3 normal : COLOR2;
			   fixed noise_uv : TEXCOORD1;
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
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				_Offset.xy += _Time.y;
				float noiseval = RandomNoise(_Scale*(_Offset + v.vertex));
				float displacement = dot(float3(0.21, 0.72, 0.07), noiseval) * _Postion1;
				float4 newVertexPos = v.vertex + float4(v.normal * displacement, 0);

				if (newVertexPos.y > _Postion2)
					o.noise_uv = 1;
				else
					o.noise_uv = 0;

				o.vertex += UnityObjectToClipPos(newVertexPos);
				return o;
			}
			fixed3 frag(v2f i) : SV_Target
			{
				//if (i.noise_uv > 0.99) { discard; }
				float4 col = tex2D(_MainTex,i.uv);
				float noiseval = RandomNoise(_Scale*((_Offset * _Time) + i.vertex));
				return col;
			}
			ENDCG
		}
	}
}