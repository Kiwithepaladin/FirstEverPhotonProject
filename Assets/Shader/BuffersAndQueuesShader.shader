Shader "Custom/ShaderDotProduct"
{
    SubShader{
		CGPROGRAM
	#pragma surface surf Lambert
		struct Input {
		float3 viewDir;
};
	void surf(Input IN, inout SurfaceOutput o)
	{
		o.Albedo.r = 1 - dot(IN.viewDir, o.Normal);
	}
	ENDCG
    }
    FallBack "Diffuse"
}
