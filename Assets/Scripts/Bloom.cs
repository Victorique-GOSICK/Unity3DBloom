using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Bloom : MonoBehaviour
{
    public AnimationCurve redChannel = new AnimationCurve(new Keyframe(0f, 0f), new Keyframe(1f, 1f));
    public AnimationCurve greenChannel = new AnimationCurve(new Keyframe(0f, 0f), new Keyframe(1f, 1f));
    public AnimationCurve blueChannel = new AnimationCurve(new Keyframe(0f, 0f), new Keyframe(1f, 1f));

    private Texture2D rgbChannelTex;

    public float Threshold = 1.0f;
    public float Intensity = 1.0f;
    public float Saturation = 1.0f;

    public float Exposure = 1.0f;

    void _UpdateLUT()
    {
        if (!rgbChannelTex)
        {
            rgbChannelTex = new Texture2D(256, 4, TextureFormat.ARGB32, false, true);
        }
        //
        rgbChannelTex.hideFlags = HideFlags.DontSave;
        rgbChannelTex.wrapMode = TextureWrapMode.Clamp;
        if (redChannel != null && greenChannel != null && blueChannel != null)
        {
            for (float i = 0.0f; i <= 1.0f; i += 1.0f / 255.0f)
            {
                float rCh = Mathf.Clamp(redChannel.Evaluate(i), 0.0f, 1.0f);
                float gCh = Mathf.Clamp(greenChannel.Evaluate(i), 0.0f, 1.0f);
                float bCh = Mathf.Clamp(blueChannel.Evaluate(i), 0.0f, 1.0f);

                rgbChannelTex.SetPixel((int)Mathf.Floor(i * 255.0f), 0, new Color(rCh, gCh, bCh));
                rgbChannelTex.SetPixel((int)Mathf.Floor(i * 255.0f), 1, new Color(rCh, gCh, bCh));
                rgbChannelTex.SetPixel((int)Mathf.Floor(i * 255.0f), 2, new Color(rCh, gCh, bCh));
                rgbChannelTex.SetPixel((int)Mathf.Floor(i * 255.0f), 3, new Color(rCh, gCh, bCh));
            }
            rgbChannelTex.Apply();
        }
        Shader.SetGlobalTexture("_ColorLUT", rgbChannelTex);
    }

    void OnEnable()
    {
        if (_bloomMaterial == null)
        {
            _bloomMaterial = new Material(Shader.Find("Hidden/Bloom"));
        }
        //
        _UpdateLUT();
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_bloomMaterial == null)
        {
            Graphics.Blit(source, destination);
            return;
        }
        //
        _bloomMaterial.SetFloat("_Threshold", Threshold);
        _bloomMaterial.SetFloat("_Intensity", Intensity);
        _bloomMaterial.SetFloat("_Exposure", Exposure);
        _bloomMaterial.SetFloat("_Saturation", Saturation);

        RenderTexture rtdivision4x4 = RenderTexture.GetTemporary(source.width / 4, source.height / 4, 0, source.format);
        rtdivision4x4.filterMode = FilterMode.Bilinear;
        RenderTexture rtdivision8x8 = RenderTexture.GetTemporary(source.width / 8, source.height / 8, 0, source.format);
        rtdivision4x4.filterMode = FilterMode.Bilinear;
        RenderTexture rtdivision16x16 = RenderTexture.GetTemporary(source.width / 8, source.height / 8, 0, source.format);
        rtdivision4x4.filterMode = FilterMode.Bilinear;
        RenderTexture rtdivision32x32 = RenderTexture.GetTemporary(source.width / 16, source.height / 16, 0, source.format);
        rtdivision4x4.filterMode = FilterMode.Bilinear;
        RenderTexture rtdivision64x64 = RenderTexture.GetTemporary(source.width / 32, source.height / 32, 0, source.format);
        rtdivision64x64.filterMode = FilterMode.Bilinear;

        Graphics.Blit(source, rtdivision4x4, _bloomMaterial, 0);
        Graphics.Blit(rtdivision4x4, rtdivision8x8, _bloomMaterial, 2);//Gather Bloom part
        _bloomMaterial.EnableKeyword("DOWNSAMPE");
        Graphics.Blit(rtdivision8x8, rtdivision16x16, _bloomMaterial, 1);
        Graphics.Blit(rtdivision16x16, rtdivision32x32, _bloomMaterial, 1);
        Graphics.Blit(rtdivision32x32, rtdivision64x64, _bloomMaterial, 1);
        //
        _bloomMaterial.SetTexture("_bloomTex1", rtdivision32x32);
        _bloomMaterial.SetTexture("_bloomTex2", rtdivision64x64);

        rtdivision8x8.DiscardContents();
        Graphics.Blit(rtdivision16x16, rtdivision8x8, _bloomMaterial, 3);
        //
        _bloomMaterial.DisableKeyword("DOWNSAMPE");
        rtdivision4x4.DiscardContents();
        Graphics.Blit(rtdivision8x8, rtdivision4x4, _bloomMaterial, 1);
        //
        _bloomMaterial.SetTexture("_bloomTex", rtdivision4x4);
        Graphics.Blit(source, destination, _bloomMaterial, 4);

        RenderTexture.ReleaseTemporary(rtdivision4x4);
        RenderTexture.ReleaseTemporary(rtdivision8x8);
        RenderTexture.ReleaseTemporary(rtdivision16x16);
        RenderTexture.ReleaseTemporary(rtdivision32x32);
        RenderTexture.ReleaseTemporary(rtdivision64x64);
    }

    Material _bloomMaterial;
}
