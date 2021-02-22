using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerUIController : MonoBehaviour
{
    private PlayerController PC;
    [SerializeField] private Text ammoDisplay;
    [SerializeField] private Text UniqueGUIDText;
    [SerializeField] private string UniqueGUID;
    private void Start()
    {
        PC = GetComponent<PlayerController>();
        UniqueGUID = PC.playerGUID;
    }

    private void LateUpdate()
    {
        UpdateAmmoDisplay();
        UpdateIsReloading();
        UpdateUniqueGUID();
    }

    void UpdateAmmoDisplay()
    {
        if (!PC.isReloading)
        {
            ammoDisplay.text = PC.currentAmmo.ToString() + "/" + PC.totalAmmo.ToString();
        }
    }
    void UpdateIsReloading()
    {
        if(PC.isReloading)
        {
            ammoDisplay.text = "Reloading";
        }
    }
    void UpdateUniqueGUID()
    {
        UniqueGUIDText.text = UniqueGUID;
    }
}
