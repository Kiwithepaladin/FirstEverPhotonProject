using Photon.Pun;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;


public class PlayerController : MonoBehaviour
{
    [Header("Stats")]
    [SerializeField] public int health = 1;
    [SerializeField] public string playerGUID;
    [Header("Movement")]
    [SerializeField] GameObject cameraHolder;

    [SerializeField] float mouseSensitivity, sprintSpeed, walkSpeed, jumpForce, smoothTime;
    float verticalLookRotation;
    [SerializeField] bool grounded;
    Vector3 smoothMoveVelocity;
    Vector3 moveAmount;
    public bool isReloading = false;
    [Header("Shooting")]
    [SerializeField] private GameObject crossHair;
    [SerializeField] public int totalAmmo;
    [SerializeField] public int currentAmmo;
    Rigidbody rb;

    public PhotonView PV;

    void Awake()
    {

        rb = GetComponent<Rigidbody>();
        PV = GetComponent<PhotonView>();
    }

    void Start()
    {
        if (PV.IsMine)
        {
        }
        else
        {
            Destroy(GetComponentInChildren<Camera>().gameObject);
            Destroy(rb);
        }
    }

    void Update()
    {
        if (!PV.IsMine)
            return;
        else
        {
            Look();
            Move();
            Jump();
            ForceReload();

            if (health <= 0)
            {
                PhotonNetwork.Destroy(this.gameObject);
            }

            if (Input.GetKeyDown(KeyCode.Mouse0))
            {
                Shoot();
            }
        }
    }

    void Look()
    {
        transform.Rotate(Vector3.up * Input.GetAxisRaw("Mouse X") * mouseSensitivity);

        verticalLookRotation += Input.GetAxisRaw("Mouse Y") * mouseSensitivity;
        verticalLookRotation = Mathf.Clamp(verticalLookRotation, -90f, 90f);

        cameraHolder.transform.localEulerAngles = Vector3.left * verticalLookRotation;
    }
    void Move()
    {
        Vector3 moveDir = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical")).normalized;

        moveAmount = Vector3.SmoothDamp(moveAmount, moveDir * (Input.GetKey(KeyCode.LeftShift) ? sprintSpeed : walkSpeed), ref smoothMoveVelocity, smoothTime);
    }
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.tag.Equals("EnemyBullet"))
        {
            if (collision.collider.GetComponent<BasicBullet>().bulletID != null)
            {
                health--;
            }
        }
    }
    void Jump()
    {
        if (Input.GetKeyDown(KeyCode.Space) && grounded)
        {
            rb.AddForce(transform.up * jumpForce);
        }
    }
    public void SetGroundedState(bool _grounded)
    {
        grounded = _grounded;
    }

    void FixedUpdate()
    {
        if (!PV.IsMine)
            return;
        rb.MovePosition(rb.position + transform.TransformDirection(moveAmount) * Time.fixedDeltaTime);
    }
    void Shoot()
    {
        PV.RPC("RpcShoot", RpcTarget.All);
    }
    [PunRPC]
    void RpcShoot()
    {
        if (currentAmmo > 0 && !isReloading)
        {
            currentAmmo--;
            GameObject bullet = PhotonNetwork.Instantiate(Path.Combine("PhotonPrefabs", "BasicBullet"), crossHair.transform.position, cameraHolder.transform.rotation);
            bullet.transform.SetParent(this.transform);
            bullet.GetComponent<BasicBullet>().bulletID = playerGUID;
            bullet.GetComponent<Rigidbody>().velocity = cameraHolder.transform.TransformDirection(new Vector3(0, 0, 10f));
        }
        else if(currentAmmo <= 0 && !isReloading)
        {
            ReloadCourtine();
        }
    }
    void ForceReload()
    {
        if (Input.GetKeyDown(KeyCode.R) && !isReloading)
            ReloadCourtine();
    }
    void ReloadCourtine()
    {
        StartCoroutine(Reload(2.5f));
    }
    IEnumerator Reload(float delay)
    {
        isReloading = true;
        yield return new WaitForSeconds(delay);
        currentAmmo = totalAmmo;
        isReloading = false;
    }
}