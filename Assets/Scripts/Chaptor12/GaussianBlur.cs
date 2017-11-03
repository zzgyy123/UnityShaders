using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : PostEffectsBase
{

    public Shader gaussianBlurShader;
    private Material gaussianBlurMaterial = null;

    public Material material
    {
        get
        {
            gaussianBlurMaterial = CheckShaderAndCreateMaterial(gaussianBlurShader, gaussianBlurMaterial);
            return gaussianBlurMaterial;
        }
    }

    [Range(0, 4)]
    public int iterations = 3;

    [Range(0.2f, 3.0f)]
    public float blurSpeed = 0.6f;

    [Range(1, 8)]
    public int downSample = 2;

    //void OnRenderImage(RenderTexture source, RenderTexture destination)
    //{
    //    if(material!=null)
    //    {
    //        int rtw = source.width;
    //        int rth = source.height;

    //        RenderTexture buffer = RenderTexture.GetTemporary(rtw, rth, 0);

    //        Graphics.Blit(source, buffer, material, 0);

    //        Graphics.Blit(buffer,destination,material,1);

    //        RenderTexture.ReleaseTemporary(buffer);
    //    }
    //    else
    //    {
    //        Graphics.Blit(source, destination);
    //    }
    //}

    //void OnRenderImage(RenderTexture source, RenderTexture destination)
    //{
    //    if (material != null)
    //    {
    //        int rtw = source.width/downSample;
    //        int rth = source.height/downSample;

    //        RenderTexture buffer = RenderTexture.GetTemporary(rtw, rth, 0);
    //        buffer.filterMode = FilterMode.Bilinear;

    //        Graphics.Blit(source, buffer, material, 0);

    //        Graphics.Blit(buffer, destination, material, 1);

    //        RenderTexture.ReleaseTemporary(buffer);
    //    }
    //    else
    //    {
    //        Graphics.Blit(source, destination);
    //    }
    //}

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            int rtw = source.width / downSample;
            int rth = source.height / downSample;

            RenderTexture buffer0 = RenderTexture.GetTemporary(rtw, rth, 0);
            buffer0.filterMode = FilterMode.Bilinear;

            Graphics.Blit(source, buffer0);

            for(int i=0;i<iterations;++i)
            {
                material.SetFloat("_BlurSize", 1.0f + i * blurSpeed);

                RenderTexture buffer1 = RenderTexture.GetTemporary(rtw, rth, 0);

                //vertical
                Graphics.Blit(buffer0, buffer1, material, 0);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtw, rth, 0);
                //horizontal
                Graphics.Blit(buffer0, buffer1, material, 1);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                //这里必须先释放buffer0，再把buffer1赋给0，不能下面这样
                //buffer0=buffer1;
                //RenderTexture.ReleaseTemporary(buffer1);
                //这样0和1都没有了
            }

            Graphics.Blit(buffer0, destination);
            RenderTexture.ReleaseTemporary(buffer0);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
