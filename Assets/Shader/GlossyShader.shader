Shader "Shaders/Nadav's/GlossyShader"
{
    Properties
    {
       	_DiffuseTexture("Diffuse Texture", 2D) = "white"{}
		_NormalMapTexture("Normal Map Texture", 2D) = "bump"{}
		_CubeMap("Cube Map",CUBE) = "white" {}
		_IntensityX("Intensity Normal Map", Range(0,10)) = 1
		_IntensityY("Intensity Albedo", Range(0,10)) = 1
	}
		SubShader
		{
			CGPROGRAM
			#pragma surface surf Lambert

			float _IntensityX;
			sampler2D _DiffuseTexture;
			sampler2D _NormalMapTexture;

		samplerCUBE _CubeMap;

        struct Input
        {
            float2 uv_DiffuseTexture;
            float2 uv_NormalMapTexture;
			float3 worldRefl; INTERNAL_DATA
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Albedo = texCUBE(_CubeMap, IN.worldRefl).rgb;
			o.Normal = UnpackNormal(tex2D(_NormalMapTexture, IN.uv_NormalMapTexture));
			o.Normal *= float3(_IntensityX, _IntensityX, 1);
			o.Emission = texCUBE(_CubeMap, WorldReflectionVector(IN, o.Normal)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
