using UnityEngine;
using System.Collections;

//https://pdfs.semanticscholar.org/4322/6a3916a85025acbb3a58c17f6dc0756b35ac.pdf
public class SampleAssistant
{
    public static Vector2 ToUnitDisk(Vector2 point)
    {
        float phi, r;
        float a = 2 * point.x - 1;
        float b = 2 * point.y - 1;
        if (a * a > b * b)
        {
            r = a;
            phi = (Mathf.PI / 4) * (b / a);
        }
        else
        {
            r = b;
            phi = (Mathf.PI / 2) - ((Mathf.PI / 4) * (a / b));
        }
        //
        return new Vector2(r * Mathf.Cos(phi), r * Mathf.Sin(phi));
    }
}
