// Bloom/Glow effect: horizontal blur

Texture2D<float4> Texture : register(t0);
sampler TextureSampler : register(s0);

float4 main(float4 color : COLOR0, float2 texCoord : TEXCOORD0) : SV_Target0
{
    float4 textureColor = Texture.Sample(TextureSampler, texCoord); // sample the pixel color
	float4 finalColor = {0, 0, 0, 1};

	// Source: http://www.rastertek.com/dx11tut36.html
	// To create the blurred pixel we first set the color to black and then we add the center pixel and the eight neighbors to the final color based on the weight of each
	
	// Create the weights that each neighbor pixel will contribute to the blur.
	float weight0 = 1.0f;
	float weight1 = 0.95f;
	float weight2 = 0.9f;
	float weight3 = 0.85f;
	float weight4 = 0.8f;
	float weight5 = 0.7f;
	float weight6 = 0.5f;
	float weight7 = 0.3f;
	float weight8 = 0.1f;

	// Create a normalized value to average the weights out a bit.
	float normalization = (weight0 + 2.0f * (weight1 + weight2 + weight3 + weight4));

	// Normalize the weights.
	weight0 = weight0 / normalization;
	weight1 = weight1 / normalization;
	weight2 = weight2 / normalization;
	weight3 = weight3 / normalization;
	weight4 = weight4 / normalization;

	// and more
	weight5 = weight5 / normalization;
	weight6 = weight6 / normalization;
	weight7 = weight7 / normalization;
	weight8 = weight8 / normalization;
	
	// Pixels:
	// 1 2 3 4(5)6 7 8 9
	float pixelSize = 1.0f/800.0f; // px over an 800 px screen
	
	// 1 2 3 4 5 6 7 8(9)10 11 12 13 14 15 16 17
	float2 tc1 = {texCoord[0]-pixelSize * 8, texCoord[1]};
	float2 tc2 = {texCoord[0]-pixelSize * 7, texCoord[1]};
	float2 tc3 = {texCoord[0]-pixelSize * 6, texCoord[1]};
	float2 tc4 = {texCoord[0]-pixelSize * 5, texCoord[1]};
	float2 tc5 = {texCoord[0]-pixelSize * 4, texCoord[1]};
	float2 tc6 = {texCoord[0]-pixelSize * 3, texCoord[1]};
	float2 tc7 = {texCoord[0]-pixelSize * 2, texCoord[1]};
	float2 tc8 = {texCoord[0]-pixelSize, texCoord[1]};
	float2 tc9 = texCoord;
	float2 tc10 = {texCoord[0]+pixelSize, texCoord[1]};
	float2 tc11 = {texCoord[0]+pixelSize * 2, texCoord[1]};
	float2 tc12 = {texCoord[0]+pixelSize * 3, texCoord[1]};
	float2 tc13 = {texCoord[0]+pixelSize * 4, texCoord[1]};
	float2 tc14 = {texCoord[0]+pixelSize * 5, texCoord[1]};
	float2 tc15 = {texCoord[0]+pixelSize * 6, texCoord[1]};
	float2 tc16 = {texCoord[0]+pixelSize * 7, texCoord[1]};
	float2 tc17 = {texCoord[0]+pixelSize * 8, texCoord[1]};

	// Add the nine horizontal pixels to the color by the specific weight of each.
	finalColor += Texture.Sample(TextureSampler, tc1) * weight8;
	finalColor += Texture.Sample(TextureSampler, tc2) * weight7;
	finalColor += Texture.Sample(TextureSampler, tc3) * weight6;
	finalColor += Texture.Sample(TextureSampler, tc4) * weight5;
	finalColor += Texture.Sample(TextureSampler, tc5) * weight4;
	finalColor += Texture.Sample(TextureSampler, tc6) * weight3;
	finalColor += Texture.Sample(TextureSampler, tc7) * weight2;
	finalColor += Texture.Sample(TextureSampler, tc8) * weight1;
	finalColor += Texture.Sample(TextureSampler, tc9) * weight0; // center pixel
	finalColor += Texture.Sample(TextureSampler, tc10) * weight1;
	finalColor += Texture.Sample(TextureSampler, tc11) * weight2;
	finalColor += Texture.Sample(TextureSampler, tc12) * weight3;
	finalColor += Texture.Sample(TextureSampler, tc13) * weight4;
	finalColor += Texture.Sample(TextureSampler, tc14) * weight5;
	finalColor += Texture.Sample(TextureSampler, tc15) * weight6;
	finalColor += Texture.Sample(TextureSampler, tc16) * weight7;
	finalColor += Texture.Sample(TextureSampler, tc17) * weight8;


	// TODO: additive blending

	finalColor.a = 1.0f;
	return finalColor;
}
