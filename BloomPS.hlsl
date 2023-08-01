// Bloom/Glow effect: additive blending (final step)

// The texture that shades onto the surface
Texture2D myTexture : register(t0);
//Texture2D myTexture2 : register(t1);
SamplerState mySampler : register(s0);

// Defines the input to this pixel shader
// - Should match the output of our corresponding vertex shader
struct VertexToPixel
{
	float4 position		: SV_POSITION;
	float2 texcoord		: TEXCOORD;
};

// Entry point for this pixel shader
float4 main(VertexToPixel input) : SV_TARGET
{
	float4 textureColor = myTexture.Sample(mySampler, input.texcoord); // sample the pixel color
	float4 finalColor = {0, 0, 0, 1};

	// Source: http://www.rastertek.com/dx11tut36.html
	// To create the blurred pixel we first set the color to black and then we add the center pixel and the eight neighbors to the final color based on the weight of each
	
	 // Create the weights that each neighbor pixel will contribute to the blur.
    float weight0 = 1.0f;
    float weight1 = 0.9f;
    float weight2 = 0.55f;
    float weight3 = 0.18f;
    float weight4 = 0.1f;

    // Create a normalized value to average the weights out a bit.
    float normalization = (weight0 + 2.0f * (weight1 + weight2 + weight3 + weight4));

    // Normalize the weights.
    weight0 = weight0 / normalization;
    weight1 = weight1 / normalization;
    weight2 = weight2 / normalization;
    weight3 = weight3 / normalization;
    weight4 = weight4 / normalization;

	// 1 2 3
	// 4(5)6
	// 7 8 9
	float blurSize = 5.0f/800.0f; // px over an 800 px screen

	float2 tc1 = {input.texcoord[0]-blurSize, input.texcoord[1]-blurSize};
	float2 tc2 = {input.texcoord[0], input.texcoord[1]-blurSize};
	float2 tc3 = {input.texcoord[0]+blurSize, input.texcoord[1]-blurSize};
	float2 tc4 = {input.texcoord[0]-blurSize, input.texcoord[1]};
	float2 tc5 = input.texcoord;
	float2 tc6 = {input.texcoord[0]+blurSize, input.texcoord[1]};
	float2 tc7 = {input.texcoord[0]-blurSize, input.texcoord[1]+blurSize};
	float2 tc8 = {input.texcoord[0], input.texcoord[1]+blurSize};
	float2 tc9 = {input.texcoord[0]+blurSize, input.texcoord[1]+blurSize};

	// Add the nine horizontal pixels to the color by the specific weight of each.
	finalColor += myTexture.Sample(mySampler, tc1) * weight4;
	finalColor += myTexture.Sample(mySampler, tc2) * weight3;
	finalColor += myTexture.Sample(mySampler, tc3) * weight2;
	finalColor += myTexture.Sample(mySampler, tc4) * weight1;
    finalColor += myTexture.Sample(mySampler, tc5) * weight0; // center pixel
	finalColor += myTexture.Sample(mySampler, tc6) * weight1;
	finalColor += myTexture.Sample(mySampler, tc7) * weight2;
	finalColor += myTexture.Sample(mySampler, tc8) * weight3;
	finalColor += myTexture.Sample(mySampler, tc9) * weight4;


	// todo: additive blending

	finalColor.a = 1.0f;
	return finalColor;
}