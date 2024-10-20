using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MusicWeb.Areas.Admin.Controllers
{
    public class AdminHomeController : Controller
    {
        // GET: Admin/AdinHome
        public ActionResult HomeAd()
        {
            return View();
        }

        public ActionResult DashBoard()
        {
            return View();
        }
    }
}