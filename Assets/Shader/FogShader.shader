Shader "Custom/FogShader"
{
	Properties
	{
	   _Color("Main Color", Color) = (1, 1, 1, .5)
	   _Scale("Noise scale", Vector) = (1.0, 1.0, 1.0)
	   _Offset("Noise offset", Vector) = (1.0, 1.0, 1.0)
	   _Postion1("Position 1", Range(0,1)) = 1
	   _IntersectionThresholdMax("Intersection Threshold Max", float) = 1
	}
		SubShader
	{
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent"  }

		Pass
		{
		   Blend SrcAlpha OneMinusSrcAlpha
		   ZWrite Off
		   CGPROGRAM
		   #pragma vertex vert
		   #pragma fragment frag
		   #pragma multi_compile_fog
		   #include "UnityCG.cginc"

		   struct appdata
		   {
			   float4 vertex : POSITION;
			   float3 normal : NORMAL;
		   };

		   struct v2f
		   {
			   float4 scrPos : TEXCOORD0;
			   UNITY_FOG_COORDS(1)
			   float3 normal : COLOR2;
			   float4 vertex : SV_POSITION;
		   };

		   sampler2D _CameraDepthTexture;
		   float4 _Color; 
		   float4 _IntersectionColor;
		   float _IntersectionThresholdMax;
		   float3 _Scale;
		   float3 _Offset;
		   float _Postion1;

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
			   o.vertex = UnityObjectToClipPos(v.vertex);
			   o.scrPos = ComputeScreenPos(o.vertex);
			   _Offset.xy += _Time.y;
			   float noiseval = RandomNoise(_Scale*(_Offset + v.vertex));
			   float displacement = dot(float3(0.21, 0.72, 0.07), noiseval) * _Postion1;
			   float4 newVertexPos = v.vertex + float4(v.normal * displacement, 0);

			   UNITY_TRANSFER_FOG(o, o.vertex);


			   o.vertex += UnityObjectToClipPos(newVertexPos);
			   return o;
		   }


			half4 frag(v2f i) : SV_TARGET
			{
			   float depth = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)));
			   float diff = saturate(_IntersectionThresholdMax * (depth - i.scrPos.w));

			   
			   fixed4 col = lerp(fixed4(_Color.rgb, 0.8), _Color, diff * diff * diff * (diff * (6 * diff - 15) + 10));
			   float noiseval = RandomNoise(_Scale*((_Offset * _Time) + i.vertex));


			   if (noiseval < 0.99)
			   {

				   col.a *= 1 - ((i.vertex.z / i.vertex.w) * noiseval);
			   }
			   UNITY_APPLY_FOG(i.fogCoord, col);
			   return col;
			}

			ENDCG
		}
	}
}