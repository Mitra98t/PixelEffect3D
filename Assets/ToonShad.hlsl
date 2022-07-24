#ifndef LIGHTING_CEL_SHADED_INCLUDED
#define LIGHTING_CEL_SHADED_INCLUDED

/*
    Normal <- world normal
*/

#ifndef SHADERGRAPH_PREVIEW
struct Mods{
    float3 Color;
    float Brightness;
    float Strength;
    float Detail;
    float Offset;
    float DarkestShadow;
};

float Toon(float3 normal, Light l, Mods mm){
    float NdotL = max(0.0f,(dot(normalize(normal), normalize(l.direction)) + mm.Offset));
    // SHADOW ATTENUATION CAUSA ARTEFATTI A CAZZO DI CANE
    //* TOON SHADE ATTENUATION USING SHADOW AND ADDITIONAL LIGHT (if provided)
    float attenuation = l.shadowAttenuation * l.distanceAttenuation;
    NdotL *= attenuation;

    return floor(NdotL / mm.Detail) == 0 ? floor(NdotL / mm.Detail) + mm.DarkestShadow : floor(NdotL / mm.Detail);
}
float3 CalculateToonShading(float diffuse, Light l, Mods mm){
    return l.color * diffuse * mm.Strength + mm.Brightness;
}
#endif

void LightingCelShaded_float(float3 Normal, float3 Position, float4 ColorIn, float Brightness, float Strength, float Detail, float Offset, float DarkestShadow, out float3 Color){
#if defined(SHADERGRAPH_PREVIEW)
    Color = float3(0.3f,0.3f,0.3f);
#else
    //* MAIN LIGHT SHADOW COORDINATES
    #if SHADOWS_SCREEN
        float4 clipPos = TransformWorldToClip(Position);
        float4 ShadowCoord = ComputeScreenPos(clipPos);
    #else
        float4 ShadowCoord = TransformWorldToShadowCoord(Position);
    #endif

    Light light = GetMainLight(ShadowCoord);
    Mods mm;
    
    mm.Brightness = Brightness;
    mm.Strength = Strength;
    mm.Detail = Detail;
    mm.Offset = Offset;
    mm.DarkestShadow = DarkestShadow;
    mm.Color = float3(ColorIn.x, ColorIn.y, ColorIn.z);

    Color = mm.Color;

    Color *= CalculateToonShading(Toon(Normal, light, mm), light, mm);

    //* ADDITIONAL LIGHTS CALCULATION
    // int pixelLightCount = GetAdditionalLightsCount();
    // for(int i = 0; i < pixelLightCount; i++){
    //     light = GetAdditionalLight(i, Position, 1);
    //     float3 tmpColor = CalculateToonShading(Toon(Normal, light, mm), light, mm);
    //     Color *= tmpColor;
    // }
#endif
}
#endif