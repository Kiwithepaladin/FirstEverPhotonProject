using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;

public class BasicBullet : MonoBehaviour
{
    public string bulletID;
    public PhotonView pv;
    private float timeRemaining = 1f;

    private void Start()
    {
        pv = GetComponent<PhotonView>();
        if (!pv.IsMine)
        {
            pv.RPC("UpdateBulletTag", RpcTarget.All, "EnemyBullet");
        }
        pv.RPC("UpdateBulletID", RpcTarget.All);
        
    }
    private void Update()
    {
        if (pv.IsMine)
        {
            if (timeRemaining > 0)
            {
                timeRemaining -= Time.deltaTime;
            }
            else if (timeRemaining <= 0)
            {
                PhotonNetwork.Destroy(this.gameObject);
            }
        }
        else
        {
            return;
        }
            
    }
    private void OnCollisionEnter(Collision collision)
    {
        if (pv.IsMine)
        {
            PhotonNetwork.Destroy(this.gameObject);
        }
    }
    [PunRPC]
    void UpdateBulletID()
    {
        if (bulletID == "" || bulletID == null)
        {
            foreach (var player in GameObject.FindGameObjectsWithTag("Player"))
            {
                bulletID = player.GetComponent<PlayerController>().playerGUID;
            }
        }
    }
    [PunRPC]
    void UpdateBulletTag(string tag)
    {
        this.tag = tag;
    }
}
