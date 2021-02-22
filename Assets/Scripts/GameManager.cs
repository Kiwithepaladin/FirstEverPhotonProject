using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    [SerializeField] private GameObject[] grid;
    private void Start()
    {
        grid = GameObject.FindGameObjectsWithTag("Tile");
        ChangeName();
    }

    private void ChangeName()
    {
        foreach (var tile in grid)
        {
            tile.name = "Cube" + tile.transform.localPosition.x + " " + tile.transform.localPosition.z;
        }
    }
}
