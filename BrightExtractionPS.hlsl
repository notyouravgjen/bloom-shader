// Bloom/Glow effect: extract "bright" pixels

Texture2D<float4> Texture : register(t0);
sampler TextureSampler : register(s0);

float4 main(float4 color : COLOR0, float2 texCoord : TEXCOORD0) : SV_Target0
{
    float4 textureColor = Texture.Sample(TextureSampler, texCoord); // sample the pixel color
	float4 finalColor = {0, 0, 0, 1};

	// Calculate brightness from HSL
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

	if(1/high + 1/low > .9)
	{
		finalColor = textureColor;
	}

	return finalColor;
}
