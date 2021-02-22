Shader "Custom/StandardPBRSPEC"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _ColorSpecular ("Color", Color) = (1,1,1,1)
        _MetalicTex ("Metaflic(R)", 2D) = "white" {}
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_Slider("Emission", Range(0,10)) = 5
    }
    SubShader
    {
        CGPROGRAM
		#pragma surface surf StandardSpecular

        sampler2D _MetalicTex;
		half _Metallic;
		fixed4 _Color;
		fixed3 _ColorSpecular;
		half _Slider;
        struct Input
        {
            float2 uv_MetalicTex;
        };

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
			o.Albedo = _Color.rgb;
			o.Smoothness = 1 - tex2D(_MetalicTex, IN.uv_MetalicTex).r;
			o.Specular = _ColorSpecular.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
