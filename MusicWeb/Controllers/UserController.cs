using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MusicWeb.Models;
using System.Data;
using System.Web.Security;
using System.Web.Hosting;
using System.Security.Cryptography;
using System.Text;
using System.Net.Mail;
using System.Net.Mime;
using System.Net;

namespace MusicWeb.Controllers
{
    public class UserController : Controller
    {
        private readonly string MAIL_USER = "linhpeter04@gmail.com";
        private readonly string MAIL_PASSWORD = "ulej omwh dsuh ynqs";

        MusicWebEntities data = new MusicWebEntities();
        // GET: User
        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Register(User user, FormCollection fc)
        {
            var displayName = fc["DisplayName"];
            var email = fc["Email"];
            var password = fc["Password"];
            var confirmPassword = fc["ConfirmPassword"];
            var gender = fc["Gender"];
            var dateofbirth = String.Format("{0:dd/MM/yyyy}", fc["NgaySinh"]);
            var createdDate = DateTime.Now;

            if (String.IsNullOrEmpty(displayName))
            {
                TempData["error1"] = "Vui lòng nhập họ tên";
            }
            else if (String.IsNullOrEmpty(email))
            {
                TempData["error2"] = "Vui lòng nhập email";
            }
            else if (String.IsNullOrEmpty(password))
            {
                TempData["error8"] = "Vui lòng nhập mật khẩu";
            }
            else if (String.IsNullOrEmpty(confirmPassword))
            {
                TempData["error3"] = "Vui lòng xác nhận mật khẩu";
            }
            else if (password != confirmPassword)
            {
                TempData["error4"] = "Mật khẩu xác nhận không khớp";
            }
            else if (String.IsNullOrEmpty(gender))
            {
                TempData["error5"] = "Vui lòng chọn giới tính";
            }
            else if (String.IsNullOrEmpty(dateofbirth))
            {
                TempData["error6"] = "Vui lòng chọn ngày sinh";
            }
            else if (data.Users.FirstOrDefault(u => u.Email == email) != null)
            {
                TempData["error7"] = "Email đã đăng ký";
            }
            else
            {
                user.DisplayName = displayName;
                user.Email = email;
                user.Password = password;
                user.DateOfBirth = Convert.ToDateTime(dateofbirth);
                user.Gender = Convert.ToString(gender);
                user.CreatedAt = createdDate;

                data.Users.Add(user);
                data.SaveChanges();

                sendMail(
                    user.Email,
                    user.DisplayName,
                    user.Password,
                    user.Gender,
                    createdDate,
                    "Account created successfully"
               );


                return RedirectToAction("Login");
            }
            return Register();
        }
        
        [HttpGet]
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(FormCollection fc, User user)
        {
            var email = fc["Email"];
            var password = fc["Password"];

            if (String.IsNullOrEmpty(email))
            {
                TempData["error1"] = "Vui lòng nhập email";
                return View();
            }
            else if (String.IsNullOrEmpty(password))
            {
                TempData["error2"] = "Vui lòng nhập mật khẩu";
                return View();
            }
            else
            {
                User account = data.Users.FirstOrDefault(u => u.Email == email && u.Password == password);

                if (account != null)
                {
                    TempData["success"] = "Đăng nhập thành công";
                    Session["Account"] = account;
                    Session["DisplayName"] = account.DisplayName;

                    HttpCookie cookies = new HttpCookie("UserLogin");
                    cookies["TaiKhoan"] = account.Email;
                    cookies["DisplayName"] = HttpUtility.UrlEncode(account.DisplayName);

                    cookies.Expires = DateTime.Now.AddDays(15);

                    FormsAuthentication.SetAuthCookie(email, true);
                    Response.Cookies.Add(cookies);

                    return RedirectToAction("Home", "MusicWeb");
                }
                else
                {
                    TempData["error3"] = "Email hoặc mật khẩu không đúng";
                }
            }
            return View();
        }


        [HttpGet]
        public ActionResult Logout()
        {
            Session.Clear();  // Xóa thông tin trong session

            HttpCookie cookies = Request.Cookies["UserLogin"];

            if (cookies != null)
            {
                string mail = cookies["TaiKhoan"];
                string name = cookies["DisplayName"];
                cookies.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookies);
            }
            return RedirectToAction("Home", "MusicWeb");
        }

        private void sendMail(string email, string displayName, string password, string gender, DateTime createdDate, string subject)
        {

            string filePath = HostingEnvironment.MapPath("~/Template/MailFrame.html");

            string mailTemplate = System.IO.File.ReadAllText(filePath);


            SmtpClient smtp = new SmtpClient()
            {
                Port = 587,
                Host = "smtp.gmail.com",
                EnableSsl = true,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(MAIL_USER, MAIL_PASSWORD),
                DeliveryMethod = SmtpDeliveryMethod.Network
            };


            mailTemplate = mailTemplate.Replace("*|USER_EMAIL|*", email);
            mailTemplate = mailTemplate.Replace("*|USER_NAME|*", displayName);
            mailTemplate = mailTemplate.Replace("*|USER_PASSWORD|*", password);
            mailTemplate = mailTemplate.Replace("*|USER_GENDER|*", gender);
            mailTemplate = mailTemplate.Replace("*|USER_DATE|*", createdDate.ToString("dd/MM/yyyy HH:mm:ss"));



            AlternateView htmlView = AlternateView.CreateAlternateViewFromString(mailTemplate, Encoding.UTF8, MediaTypeNames.Text.Html);


            MailMessage message = new MailMessage();
            message.From = new MailAddress(MAIL_USER);
            message.ReplyToList.Add(MAIL_USER);
            message.To.Add(new MailAddress(email));
            message.Subject = subject;


            message.AlternateViews.Add(htmlView);
            message.IsBodyHtml = true;

            smtp.Send(message);
        }

        public ActionResult ProfleUser()
        {
            if (Session["Account"] != null)
            {
                var user = (User)Session["Account"];
                return View(user);
            }
            return View();
        }
    }
}