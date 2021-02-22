using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using System;
using System.IO;

public class PlayerManager : MonoBehaviour
{
    PhotonView PV;
    [SerializeField] GameObject myPlayer;
    private float waitTime = 1;
    [SerializeField] private bool isPlayerBeingSpawned = false;
    [Header("Spawn Points")]
    public GameObject[] spawnPoints;
    public string playerManagerID;

    private void Awake()
    {
        PV = GetComponent<PhotonView>();
        playerManagerID = Guid.NewGuid().ToString();
        if (PV.IsMine)
        {
            PV.RPC("PushGUIDStoMain", RpcTarget.All, playerManagerID);
        }
        if (!Application.isEditor)
        {
            Cursor.visible = false;
            Cursor.lockState = CursorLockMode.Locked;
        }
    }
    private void Start()
    {
        if(PV.IsMine)
        {
            CreateController();
        }
    }
    private void Update()
    {
        if (PV.IsMine)
        {
            if (myPlayer != null)
            {
                if (isPlayerBeingSpawned)
                {
                    StopCoroutine(Respawn(2.5f));
                }
                if (myPlayer.GetComponentInChildren<PlayerController>().health <= 0)
                {
                    KillPlayer();
                }

                if (Input.GetKeyDown(KeyCode.J) && !isPlayerBeingSpawned)
                    KillPlayer();
            }
            else if (!isPlayerBeingSpawned)
            {
                StartCoroutine(Respawn(2.5f));
            }
        }
        else
            return;
    }
    private void CreateController()
    {
        GameObject randomSpawnPoint = spawnPoints[UnityEngine.Random.Range(0, spawnPoints.Length)];
        myPlayer = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "Player"), randomSpawnPoint.transform.localPosition, randomSpawnPoint.transform.rotation);
        myPlayer.transform.SetParent(this.transform);
        
        PV.RPC("UpdatePlayerGUID", RpcTarget.All,playerManagerID);
    }
    [PunRPC]
    void PushGUIDStoMain(string p_m_ID)
    {
        if (!RoomManager.Instance.GUIDS.Contains(p_m_ID))
        {
            RoomManager.Instance.GUIDS.Add(p_m_ID);
        }
    }
    [PunRPC]
    private void PullGUIDtoMain(string p_m_ID)
    {
        if (RoomManager.Instance.GUIDS.Contains(p_m_ID))
        {
            RoomManager.Instance.GUIDS.Remove(p_m_ID);
        }
    }
    [PunRPC]
    void UpdatePlayerGUID(string p_m_ID)
    {
        if(myPlayer != null)
            myPlayer.GetComponentInChildren<PlayerController>().playerGUID = p_m_ID;
    }
    private void KillPlayer()
    {
        if(myPlayer != null)
        {
            PhotonNetwork.Destroy(myPlayer.gameObject);
            myPlayer = null;
        }
    }
    IEnumerator Respawn(float delay)
    {
        isPlayerBeingSpawned = true;
        yield return new WaitForSeconds(delay);
        CreateController();
        isPlayerBeingSpawned = false;
    }
    public void OnApplicationQuit()
    {
        PV.RPC("PullGUIDtoMain", RpcTarget.All,playerManagerID);
    }
}
