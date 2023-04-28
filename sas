using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    Animator anim;
    Rigidbody2D rb;
    SpriteRenderer sr;

    [Header("Move")]

    [SerializeField] Vector3 startPoint;
    [SerializeField] Transform legs;
    [SerializeField] LayerMask maskGround;
    [SerializeField] private float speed = 5f;
    [SerializeField] float jumpDistance = 1.5f;
    private bool isDead = false;
    private bool inPortal = false;
    private bool isJump = false;
    float radiusLegs = 0.04f;



    private void Awake()
    {
        startPoint = transform.position;
        sr = GetComponent<SpriteRenderer>();
        anim = GetComponent<Animator>();
        rb = GetComponent<Rigidbody2D>();
    }
    private void Update()
    {
        if (!isDead)
        {
            if (Input.GetKey(KeyCode.A))
            {
                sr.flipX = true;
                anim.SetBool("isRun", true);
                rb.velocity = new Vector2(-speed, rb.velocity.y);
            }
            if (Input.GetKey(KeyCode.D))
            {
                sr.flipX = false;
                anim.SetBool("isRun", true);
                rb.velocity = new Vector2(speed, rb.velocity.y);
            }
            if (Input.GetKeyUp(KeyCode.A) || Input.GetKeyUp(KeyCode.D))
            {
                anim.SetBool("isRun", false);
                rb.velocity = Vector2.zero;
            }
            if (Input.GetKeyDown(KeyCode.W) && !isJump)
            {
                Jump(jumpDistance);
            }
            if (inPortal && Input.GetKey(KeyCode.E)) //������ '�' 
            { 
                GameManager.instance.OpenPortal(); //��������� ����� ��� ������������ ������� 
            }
        }
    }
    private void FixedUpdate()
    {
        OnGround(!Physics2D.OverlapCircle(legs.position, radiusLegs, maskGround));
    }
    private void OnGround(bool onGround)
    {
        anim.SetBool("isJump", onGround);
        isJump = onGround;
    }
    private void Jump(float distance)
    {
        if (!isJump)
        {
            rb.velocity = Vector2.zero;
            rb.AddForce(Vector2.up * speed * jumpDistance, ForceMode2D.Impulse);
        }
    }
    private void GetDamage()
    {
        isDead = true;
        transform.position = startPoint;
        GameManager.instance.HealthDamage();
        anim.SetBool("isRun", false);
        anim.SetBool("isJump", false);
        rb.velocity = Vector2.zero;
        StartCoroutine(DeadPause());
    }
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Coin"))
        {
            GameManager.instance.RemoveCoin();
            Destroy(collision.gameObject);
        }
        if (collision.CompareTag("Enemy"))
        {
            GetDamage();
        }
        if (collision.CompareTag("Portal"))
        {
            inPortal = true;
            GameManager.instance.ShowTextInfo("������� \"E\" ��� �������� �� ��������� �������");
        }
    }
    //��������� ������ �� �������� 

    private void OnTriggerExit2D(Collider2D collision)
    {

        if (collision.CompareTag("Portal")) //���� �������� ������ 

        {

            inPortal = false; //��������� ���� 

            GameManager.instance.TextFalse(); //������ ����� 

        }

    }

    IEnumerator DeadPause()
    {

        SpriteRenderer sprite = GetComponent<SpriteRenderer>(); //�������� ������ � ��������������� +
        Color startColor = Color.white; //��������� ���� 
        Color blinkColor = new Color(0.3f, 0.4f, 0.6f, 0.3f); //���� ������� 

        for (int i = 0; i < 3; i++) //��������� 3 ����
        {
            sprite.color = blinkColor; //������ ���� 
            yield return new WaitForSeconds(0.2f); //���� 
            sprite.color = startColor;
            yield return new WaitForSeconds(0.2f);
        }
        isDead = false;
        GameManager.instance.TextFalse();
    }
}
    /* void FixedUpdate()
     {
         float x = Input.GetAxisRaw("Horizontal") * speed;
         float y = Input.GetAxisRaw("Vertical") * speed;

         if (x != 0)
         {
             anim.SetBool("isRun", true);
         }
         else
         {
             anim.SetBool("isRun", false);
         }
         //Character flip
         if (x > 0 && !facingRight)
         {
             Flip();
         }
         if (x < 0 && facingRight)
         { 
             Flip(); 
         }
         rb.velocity = new Vector3(x, y);
     }
     private void Flip()
     {
         facingRight = !facingRight;
         Vector3 Scaler = transform.localScale;
         Scaler.x *= -1;
         transform.localScale = Scaler;
     }*/
