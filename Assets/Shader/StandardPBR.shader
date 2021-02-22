Shader "Custom/StandardPBR"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MetalicTex ("Metaflic(R)", 2D) = "white" {}
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        CGPROGRAM
		#pragma surface surf Standard

        sampler2D _MetalicTex;
		half _Metallic;
		fixed4 _Color;

        struct Input
        {
            float2 uv_MetalicTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			o.Albedo = _Color.rgb;
			o.Smoothness = tex2D(_MetalicTex, IN.uv_MetalicTex).r;
			o.Metallic = _Metallic;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
