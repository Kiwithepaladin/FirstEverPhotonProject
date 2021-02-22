using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using UnityEngine.SceneManagement;
using System.IO;
using System;

public class RoomManager : MonoBehaviourPunCallbacks
{
    public static RoomManager Instance;
    public List<string> GUIDS;

    private void Awake()
    {
        if(Instance)
        {
            Destroy(gameObject);
            return;
        }
        GUIDS = new List<string>();
        DontDestroyOnLoad(gameObject);
        Instance = this;
    }
    public override void OnEnable()
    {
        base.OnEnable();
        SceneManager.sceneLoaded += onSceneLoaded;
        
    }
    private void Update()
    {
        GetComponent<PhotonView>().RPC("GetAllActiveGUIDS", RpcTarget.All);
    }
    public override void OnDisable()
    {
        base.OnDisable();
        SceneManager.sceneLoaded -= onSceneLoaded;
    }
    void onSceneLoaded(Scene scene, LoadSceneMode loadSceneMode)
    {
        if(scene.buildIndex == 1)
        {
            GameObject playerManager = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "PlayerManager"), Vector3.zero, Quaternion.identity);
        }
    }
    
    [PunRPC]
    void GetAllActiveGUIDS()
    {
        foreach (var player in GameObject.FindGameObjectsWithTag("Player"))
        {
            if (!GUIDS.Contains(player.GetComponent<PlayerController>().playerGUID))
            {
                GUIDS.Add(player.GetComponent<PlayerController>().playerGUID);
            }
        }
        for (int i = 0; i < GUIDS.Count; i++)
        {
            if (GUIDS[i].Equals(null))
                GUIDS.RemoveAt(i);
        }
    }
}
