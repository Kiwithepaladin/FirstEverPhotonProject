Shader "Shaders/Nadav's/ChallangeShader"
{
	Properties
	{
		_ATexture("Texture",2D) = "White"{}
		_ETexture("Texture",2D) = "Black"{}
	}
		SubShader
	{
	   CGPROGRAM
		#pragma surface surf Lambert
	   struct Input
		{
		   float2 uv_ATexture;
		   float2 uv_ETexture;
		};
		sampler2D _ATexture;
		sampler2D _ETexture;

		void surf(Input IN, inout SurfaceOutput o) {
			
			o.Albedo = (tex2D(_ATexture, IN.uv_ATexture)).rgb;
			o.Emission = (tex2D(_ETexture, IN.uv_ETexture)).rgb;
		}
			ENDCG
	}
		FallBack "Diffuse"
}
