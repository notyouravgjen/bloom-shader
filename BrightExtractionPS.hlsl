// Bloom/Glow effect: extract "bright" pixels

Texture2D<float4> Texture : register(t0);
sampler TextureSampler : register(s0);

float4 main(float4 color : COLOR0, float2 texCoord : TEXCOORD0) : SV_Target0
{
    float4 textureColor = Texture.Sample(TextureSampler, texCoord); // sample the pixel color
	float4 finalColor = {0, 0, 0, 1};

	// "bright" is currently defined as grey/white pixels
	//if(textureColor[0] > 0.25 && textureColor[1] > 0.25 && textureColor[2] > 0.25)

	// "bright" is currently defined as grey/white pixels
	/*if(textureColor[0] + textureColor[1] + textureColor[2] > 1.25)
	{
		finalColor = textureColor;
	}
	*/
	//HSL version: Brightness based on Lightness
	float high, low;
	if(textureColor[0] > textureColor[1]){
		high = textureColor[0];
		low = textureColor[1];
	}
	else{
		high = textureColor[1];
		low = textureColor[0];
	}
	if(textureColor[2] > high)
	{
		high = textureColor[2];
	}
	else if(textureColor[2] < low){
		low = textureColor[2];
	}

	if(1/high + 1/low > .9)//Play around with that
	{
		finalColor = textureColor;
	}

	return finalColor;
}

/*
// The texture that shades onto the surface
Texture2D myTexture : register(t0);
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

	// "bright" is currently defined as grey/white pixels
	if(textureColor[0] > 0.25 && textureColor[1] > 0.25 && textureColor[2] > 0.25)
	{
		finalColor = textureColor;
	}

	return finalColor;
}
*/