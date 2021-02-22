using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class Utilities
{
    public static IEnumerator TimerCoroutine(Action theDelegate, float delay, bool isTimerRunning)
    {
        if (isTimerRunning)
            yield break;
        isTimerRunning = true;
        yield return new WaitForSeconds(delay);
        theDelegate();
        isTimerRunning = false;
    }
}
