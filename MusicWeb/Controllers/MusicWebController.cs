using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Threading.Tasks;
using System.Data.Entity;
using MusicWeb.Models;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography.X509Certificates;

namespace MusicWeb.Controllers
{
    public class MusicWebController : Controller
    {
        MusicWebEntities data = new MusicWebEntities();

        // GET: MusicWeb
        public ActionResult Home()
        { 
            var baihat = data.Songs.ToList();

            // Lấy toàn bộ danh sách bài hát nổi tiếng dựa trên số lượt like
            var popularSongs = data.Songs
                                         .OrderByDescending(s => s.LikeCount) 
                                         .ToList();

            // Lấy danh sách nghệ sĩ nổi tiếng dựa trên số lượng người theo dõi, không giới hạn số lượng
            var famousArtists = data.Artists
                                .OrderByDescending(a => a.FollowerCount)  // Sắp xếp theo FollowerCount giảm dần
                                .ToList();




            ViewBag.BaiHat = baihat;
            ViewBag.PopularSongs = popularSongs;
            ViewBag.FamousArtists = famousArtists;

            return View();
        }

        public ActionResult NavbarPartial()
        {
            return PartialView();
        }


        public ActionResult PlaylistPartial()
        {
            var baihat = data.Songs.Include(a => a.Artist).ToList();
            return PartialView(baihat);
        }
    }
}