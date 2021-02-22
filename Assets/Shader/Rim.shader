Shader "Custom/Rim"
{
	Properties
	{
		_Color("Rim Color", Color) = (0,0.5,0.5,0.5)
		_Power("Power",Range(0.5,8)) = 3
		_Diffuse("Diffuse Map", 2D) = "white"{}
		_StripeWidth("Stripe Width", Range(0,20)) = 10
    }
    SubShader
    {
        
        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows


		half _Power;
		sampler2D _Diffuse;
		float4 _Color;
		half _StripeWidth;

        struct Input
        {
			float2 uv_Diffuse;
			float3 viewDir;
			float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Albedo = (tex2D(_Diffuse, IN.uv_Diffuse)).rgb;
			//o.Emission = (rim > 0.6 ? float3(1,0,0): rim > 0.3 ? float3(0,1,0): 0);
			//o.Emission = IN.worldPos.y > 1 ? float3(0, 1, 0): float3(1, 0, 0);
			o.Emission = frac(IN.worldPos.y * (20- _StripeWidth) * 0.5) > 0.4 ? float3(0, 1, 0) * rim : float3(1, 0, 0) * rim;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
