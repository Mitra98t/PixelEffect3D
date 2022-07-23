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
    
    return floor(NdotL / mm.Detail) == 0 ? floor(NdotL / mm.Detail) + mm.DarkestShadow : floor(NdotL / mm.Detail);
}
#endif

void LightingCelShaded_float(float3 Normal,float4 ColorIn, float Brightness, float Strength, float Detail, float Offset, float DarkestShadow, out float3 Color){
#if defined(SHADERGRAPH_PREVIEW)
    Color = float3(0.3f,0.3f,0.3f);
#else
    Light light = GetMainLight();
    Mods mm;
    
    mm.Brightness = Brightness;
    mm.Strength = Strength;
    mm.Detail = Detail;
    mm.Offset = Offset;
    mm.DarkestShadow = DarkestShadow;
    mm.Color = float3(ColorIn.x, ColorIn.y, ColorIn.z);

    Color = mm.Color;

    Color *= light.color * Toon(Normal, light, mm) * mm.Strength + mm.Brightness;
#endif
}
#endif