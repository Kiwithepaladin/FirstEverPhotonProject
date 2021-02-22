Shader "Shaders/Nadav's//BumpDiffuse"
{
    Properties
	{
		_DiffuseTexture("Diffuse Texture", 2D) = "white"{}
		_NormalMapTexture("Normal Map Texture", 2D) = "bump"{}
		_IntensityX("Intensity Normal Map", Range(0,10)) = 1
		_IntensityY("Intensity Albedo", Range(0,10)) = 1
	}
		SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert
		sampler2D _DiffuseTexture;
		sampler2D _NormalMapTexture;
		half _IntensityX;
		half _IntensityY;

	struct Input
	{
		float2 uv_DiffuseTexture;
		float2 uv__NormalMapTexture;
	};
	void surf(Input IN, inout SurfaceOutput o)
	{
		o.Albedo = tex2D(_DiffuseTexture, IN.uv_DiffuseTexture * _IntensityY).rgb;
		//o.Albedo *= float3(_IntensityY, _IntensityY, 1);
		o.Normal = UnpackNormal(tex2D(_NormalMapTexture, IN.uv__NormalMapTexture));
		o.Normal *= float3(_IntensityX, _IntensityX, 1);
	}


	ENDCG
	}
    FallBack "Diffuse"
}
